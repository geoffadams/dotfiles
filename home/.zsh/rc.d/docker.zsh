if [[ $(command -v docker) ]]; then
    if is_mac; then
        fpath+=(${HOME}/.docker/completions)
    fi

    alias docker-image-prune='docker rmi $(docker images -f "dangling=true" -q)'
    alias docker-clean='docker rm $(docker ps -a -q) && docker volume rm $(docker volume ls -q)'
    alias docker-pull-all="docker images | grep -v REPOSITORY | awk '{print \$1\":\"\$2}' | xargs -L1 docker pull"
    alias docker-shell-into-image="docker run --rm -it --entrypoint sh $1"
fi
