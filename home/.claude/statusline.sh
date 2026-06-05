#!/usr/bin/env zsh

make_bar() {
    pct=$1
    width=$([[ -n $2 ]] && echo $2 || echo 10)
    filled=$(( pct * width / 100 ))
    empty=$(( width - filled ))
    bar=""
    i=0
    while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
    while [ $i -lt $width ];  do bar="${bar}░"; i=$(( i + 1 )); done
    echo "$bar"
}

icon() {
    icon="$1"
    color="$2"
    printf "${color}${icon}${RESET}"
}

BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
I_BLACK='\033[90m'

BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'
BG_I_BLACK='\033[100m'

RESET='\033[0m'

input=$(cat)

echo "$input" > ~/Temp/claude-statusline-stdin.json

typeset -T status_str status_el " "

repo=$( git -C "$working_dir" rev-parse --show-toplevel 2>/dev/null )
if [[ -n "$repo" ]]; then
    git_str=""

    project=$(basename $repo)
    working_project=$project
    branch=$(git -C "$repo" branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)
    worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')

    if [[ -n "$worktree" ]]; then
        git_icon="󰙅"
        working_project=$project
        project=$(basename $(dirname $(git -C "$repo" rev-parse --git-common-dir)))
        git_str="$project:$worktree"
        if [[ "$worktree" != "$branch" ]]; then
            git_str+=" $(icon  $CYAN ) $branch"
        fi
    else
        git_icon=""
        git_str="$project:$branch"
    fi

    staged=$(git -C "$repo" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git -C "$repo" diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    [ "$staged" -gt 0 ] && git_str="${git_str} $(printf "${GREEN}+${staged}${RESET}")"
    [ "$modified" -gt 0 ] && git_str="${git_str} $(printf "${YELLOW}~${modified}${RESET}")"

    status_el+=( $( icon $git_icon $CYAN ) $git_str )
fi

working_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
if [[ -n "$working_dir" ]]; then
    working_dir=$(basename "$working_dir")
    [[ "$working_dir" != "$working_project" ]] && status_el+=( $( icon 󰣞 $CYAN ) "$working_dir" )
fi

status_el+=( "\n" )

model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
status_el+=( $( icon 󰧑  $MAGENTA ) $model $effort )

format_context() {
    local pct=$1
    [[ -z $pct ]] && echo "-" && return
    if [[ $pct -ge 80 ]]; then color="$RED"
    elif [[ $pct -ge 60 ]]; then color="$YELLOW"
    fi
    local bar=$(make_bar "$pct")
    local hl=$2
    printf "${color}${bar}${RESET} ${hl}${pct}%%${RESET}"
}
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
status_el+=( $( icon  $MAGENTA ) "$( format_context "$context_used" $MAGENTA )" )

total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
typeset -T tokens_str tokens_el " "
[[ total_input -gt 0 ]] && tokens_el+="${MAGENTA}󰁝 ${RESET}$(numfmt --grouping ${total_input})"
[[ total_output -gt 0 ]] && tokens_el+="${GREEN}󰁅 ${RESET}$(numfmt --grouping ${total_output})"
[[ ${#tokens_el} -gt 0 ]] && status_el+=( $( icon 󰹺 $MAGENTA ) $tokens_str )

lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
typeset -T stats_str stats_el " "
[[ $lines_added -gt 0 ]] && stats_el+="$(printf "${GREEN}+$(numfmt --grouping ${lines_added})${RESET}")"
[[ $lines_removed -gt 0 ]] && stats_el+="$(printf "${RED}-$(numfmt --grouping ${lines_removed})${RESET}")"
[[ ${#stats_el} -gt 0 ]] && status_el+=( $( icon  $YELLOW ) $stats_str )

status_el+=( "\n" )

# usage subsection
typeset -T usage_str usage_el " "

# cost
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [[ -n "$total_cost" ]]; then
    cost_display=$(awk "BEGIN { printf \"%.2f\", $total_cost }")
    cost_str="\$${cost_display}"
    usage_el+=( $( icon 󰄖 $YELLOW ) $cost_str )
fi

# rate limit: 5 hours
format_rl_5h() {
    local pct=$1
    [[ -z $pct ]] && echo "-" && return
    pct=$(printf "%.0f" "$pct")
    if [[ $pct -ge 90 ]]; then color="$RED"
    elif [[ $pct -ge 70 ]]; then color="$YELLOW"
    fi
    local reset_ts=$2
    local reset_time=""
    if [[ -n $reset_ts ]]; then
        reset_time="${I_BLACK} $(date -r "$reset_ts" "+%H:%M" 2>/dev/null || date -d "@$reset_ts" "+%H:%M" 2>/dev/null)${RESET}"
    fi
    local bar=$(make_bar $pct)
    local hl=$3
    printf "${color}${bar}${RESET} ${hl}${pct}%%${RESET} $reset_time"
}
rl_5h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_5h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [[ -n $rl_5h_pct ]]; then
    usage_el+=( $( icon " 5h" $BLUE ) "$(format_rl_5h "$rl_5h_pct" "$rl_5h_reset" $BLUE)" )
fi

# rate limit: 7 days
format_rl_7d() {
    local pct=$1
    [[ -z $pct ]] && echo "-" && return
    pct=$(printf "%.0f" "$pct")
    if [[ $pct -ge 90 ]]; then color="$RED"
    elif [[ $pct -ge 70 ]]; then color="$YELLOW"
    fi
    local reset_ts=$2
    local reset_time=""
    if [[ -n $reset_ts ]]; then
        reset_time="${I_BLACK} $(date -r "$reset_ts" "+%a %H:%M" 2>/dev/null || date -d "@$reset_ts" "+%a %H:%M" 2>/dev/null)${RESET}"
    fi
    local bar=$(make_bar $pct 5)
    local hl=$3
    printf "${color}${bar}${RESET} ${hl}${pct}%%${RESET} $reset_time"
}
rl_7d_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty ')
rl_7d_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [[ -n $rl_7d_pct ]]; then
    usage_el+=( $( icon " 7d" $BLUE ) "$(format_rl_7d "$rl_7d_pct" "$rl_7d_reset" $BLUE)" )
fi
[[ ${#usage_el} -gt 0 ]] && status_el+=( $usage_str )

# session duration
format_duration() {
    local i=$1
    ((i/=1000, sec=i%60, i/=60, min=i%60, hrs=i/60))
    printf "%dh %dm" "$hrs" "$min"
}
wall_duration=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
api_duration=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')

typeset -T duration_str duration_el "/"
[[ $api_duration -gt 0 ]] && duration_el+="$(printf "api $(format_duration $api_duration)")"
[[ $wall_duration -gt 0 ]] && duration_el+="$(printf "total $(format_duration $wall_duration)")"
[[ ${#duration_el} -gt 0 ]] && status_el+=( $( icon  $WHITE ) $duration_str )

echo $status_str
