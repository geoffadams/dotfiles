#!/usr/bin/env zsh
if ! (($+commands[docker])); then
    return
fi

! (($+_comps[docker])) && source <(docker completion zsh)

# Rich container completion: replaces the bare-name menu with a columnar
# name/status/uptime/image table when cobra offers container names; anything
# else falls back to docker's stock completion untouched.
if (($+_comps[docker])) && [[ ${_comps[docker]} != _docker_rich ]]; then

    # Keep docker's `ps` ordering (newest container first) instead of sorting
    # the menu alphabetically.
    zstyle ':completion:*:docker-containers' sort false

    # Colour the status column (2nd field) green/red. ( [^ ]##)# matches its
    # internal single-spaced words up to the double-space padding, without
    # eating the padding itself.
    zstyle ':completion:*:docker-containers' list-colors \
        '=(#b)(?##  )(Up[^ ]#( [^ ]##)#)*=0=0=32' \
        '=(#b)(?##  )(Exited[^ ]#( [^ ]##)#)*=0=0=31'

    # Populates `reply` (name -> display row) for the given candidate names.
    # Returns non-zero if any candidate isn't a known container.
    _docker_rich_containers() {
        local -a cands=("$@")
        typeset -gA reply=()
        local -a rows
        rows=(${(f)"$(docker ps -a --no-trunc \
            --format $'{{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}' 2>/dev/null)"})
        ((${#rows})) || return 1

        typeset -A st_of rf_of img_of
        local line name rest
        local maxname=0
        for line in $rows; do
            name=${line%%$'\t'*}
            rest=${line#*$'\t'}
            st_of[$name]=${rest%%$'\t'*}
            rest=${rest#*$'\t'}
            rf_of[$name]=${rest%%$'\t'*}
            img_of[$name]=${rest#*$'\t'}
        done

        local c
        for c in $cands; do
            (($+st_of[$c])) || return 1
            ((${#c} > maxname)) && maxname=${#c}
        done

        local statusw=22 uptimew=14 img
        local used=$((maxname + 2 + statusw + 2 + uptimew + 2))
        local avail=$((${COLUMNS:-100} - used - 1))
        ((avail < 8)) && avail=8
        for c in $cands; do
            img=${img_of[$c]}
            ((${#img} > avail)) && img="${img[1,avail-1]}…"
            reply[$c]="${(r:maxname:)c}  ${(r:statusw:)st_of[$c]}  ${(r:uptimew:)rf_of[$c]}  ${img}"
        done
    }

    # Docker's completions restore '_docker' and 'compdef _docker docker' on
    # every execution, so this wrapper uses a distinct name and temporarily
    # disables compdef for each _docker call.
    _docker_fallback() {
        local saved_comp=${_comps[docker]}
        (($+functions[compdef])) && functions[_docker_compdef_saved]=$functions[compdef]
        function compdef { : }
        {
            _docker "$@"
        } always {
            if (($+functions[_docker_compdef_saved])); then
                functions[compdef]=$functions[_docker_compdef_saved]
                unfunction _docker_compdef_saved
            else
                unfunction compdef 2>/dev/null
            fi
            _comps[docker]=$saved_comp
        }
    }

    # Completes paths inside a container via `docker exec … ls`, modelled on
    # zsh's _remote_files (used by scp); only works on running containers,
    # offering nothing for stopped ones.
    _docker_cp_remote_files() {
        local container=$1 expl ret=1 suf
        local -a remfiles remdispf remdispd
        local pfx="${PREFIX%%[^./][^/]#}"
        # Expand path to "/foo/bar/"* so glob expansion happens inside the container.
        remfiles=(${(M)${(f)"$(docker exec $container \
            sh -c "ls -d1FL -- ${(q)pfx}* 2>/dev/null" 2>/dev/null)"}%%[^/]#(|/)})
        compset -P '*/'
        compset -S '/*' || suf='container file'
        # -F marked dirs with a trailing / above; split on that to separate
        # file and directory candidates.
        remdispf=(${remfiles:#*/})
        remdispd=(${(M)remfiles:#*/})
        _tags files
        while _tags; do
            while _next_label files expl ${suf:-container directory}; do
                [[ -n $suf ]] &&
                    compadd "$expl[@]" -d remdispf -- ${(q)remdispf%[*=|/]} && ret=0
                compadd ${suf:+-S/} "$expl[@]" -d remdispd -- ${(q)remdispd%/} && ret=0
            done
            ((ret)) || return 0
        done
        return ret
    }

    # One cp path argument: CONTAINER:PATH, or a local path — offer both
    # container names and local files before the colon is typed.
    _docker_cp_path() {
        if compset -P '*:'; then
            _docker_cp_remote_files "${IPREFIX%:}"
            return
        fi
        # `logs` lists all containers, running and stopped, newest first —
        # the right set since cp works on both.
        local out
        out=$(docker __complete logs '' 2>/dev/null)
        local -a lines=("${(@f)out}")
        [[ ${lines[-1]} == :* ]] && lines[-1]=()
        local -a cands=(${lines%%$'\t'*})
        local -A reply
        if ((${#cands})) && _docker_rich_containers $cands; then
            local -a disp
            local c
            for c in $cands; do
                disp+=("$reply[$c]")
            done
            local expl
            _description docker-containers expl 'container'
            # Suffix ':' with no auto-added space so the user continues into a path.
            compadd "${expl[@]}" -l -Q -S ':' -d disp -a cands
        fi
        _files
    }

    # scp-style completion, built from scratch since cobra offers nothing for cp.
    _docker_cp() {
        # Drop the subcommand word(s) (`cp`, or `container cp`) so _arguments
        # counts the two paths as positions 1 and 2.
        local drop_idx=3
        [[ ${words[2]} == container && ${words[3]} == cp ]] && drop_idx=4
        local -a words=("${words[1]}" "${(@)words[drop_idx,-1]}")
        ((CURRENT -= drop_idx - 2))
        _arguments -s \
            '(-a --archive)'{-a,--archive}'[archive mode (copy all uid/gid information)]' \
            '(-L --follow-link)'{-L,--follow-link}'[always follow symlinks in SRC_PATH]' \
            '(-q --quiet)'{-q,--quiet}'[suppress progress output]' \
            '1:source:_docker_cp_path' \
            '2:destination:_docker_cp_path'
    }

    # Limit to container commands as stock completions don't return object types.
    local -a _docker_rich_container_subcmds=(
        start stop restart rm exec logs inspect kill pause unpause rename
        top stats attach commit diff export port update wait
    )

    _docker_rich() {
        local -a cwords=("${(@)words[1,CURRENT]}")
        # $CURRENT check excludes completing the subcommand name itself (e.g. `docker cp<TAB>`).
        if [[ ${cwords[2]} == cp && $CURRENT -gt 2 ]] || \
           [[ ${cwords[2]} == container && ${cwords[3]} == cp && $CURRENT -gt 3 ]]; then
            _docker_cp
            return
        fi
        local -a requestComp=(__complete "${(@)cwords[2,-1]}")
        [[ ${cwords[-1]} == "" ]] && requestComp+=('')

        local subcmd=${cwords[2]}
        [[ $subcmd == container ]] && subcmd=${cwords[3]}
        local is_container_subcmd=0
        (( ${_docker_rich_container_subcmds[(Ie)$subcmd]} )) && is_container_subcmd=1

        local out
        out=$(${cwords[1]} "${requestComp[@]}" 2>/dev/null)
        if [[ -n $out ]]; then
            local -a lines=("${(@f)out}")
            [[ ${lines[-1]} == :* ]] && lines[-1]=()
            local -a cands=(${lines%%$'\t'*})
            if ((${#cands})); then
                local -A reply
                if ((is_container_subcmd)) && _docker_rich_containers $cands; then
                    local -a disp
                    local c
                    for c in $cands; do
                        disp+=("$reply[$c]")
                    done
                    local expl
                    _description docker-containers expl 'container'
                    compadd "${expl[@]}" -l -Q -d disp -a cands
                    return
                fi
            fi
        fi
        _docker_fallback "$@"
    }

    compdef _docker_rich docker
fi

alias docker-image-prune='docker rmi $(docker images -f "dangling=true" -q)'
alias docker-clean='docker rm $(docker ps -a -q) && docker volume rm $(docker volume ls -q)'
alias docker-pull-all="docker images | grep -v REPOSITORY | awk '{print \$1\":\"\$2}' | xargs -L1 docker pull"
alias docker-shell-into-image="docker run --rm -it --entrypoint sh $1"
