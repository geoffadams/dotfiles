#!/usr/bin/env zsh
#
# Claude Code statusline. Reads the statusline JSON payload on stdin.
# Run with no args for the main statusline; with "subagent" as $1, renders
# subagentStatusLine rows instead (see subagent-statusline.zsh).

setopt extendedglob
zmodload zsh/datetime

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------

ESC=$'\033'
RESET="${ESC}[0m"

RED="${ESC}[31m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
BLUE="${ESC}[34m"
MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"
I_BLACK="${ESC}[90m"

rgb() {
    printf '\033[38;2;%d;%d;%dm' "$1" "$2" "$3"
}

# Rose Pine Moon-derived truecolor ladder for usage readings (context window).
USAGE_DEFAULT=$(rgb 224 222 244)  # text
USAGE_GREEN=$(rgb 126 206 152)
USAGE_YELLOW=$(rgb 246 193 119)   # gold
USAGE_ORANGE=$(rgb 240 151 106)
USAGE_RED=$(rgb 235 111 146)      # love

usage_color() {
    local pct=$1
    if   (( pct <= 0 ));  then echo "$USAGE_DEFAULT"
    elif (( pct < 50 ));  then echo "$USAGE_GREEN"
    elif (( pct < 70 ));  then echo "$USAGE_YELLOW"
    elif (( pct < 85 ));  then echo "$USAGE_ORANGE"
    else                       echo "$USAGE_RED"
    fi
}

# Same ladder applied to model size and effort level, so all three share one
# "how much is this costing/thinking" visual language on the statusline.
model_color() {
    case "${1:l}" in
        *haiku*) echo "$USAGE_GREEN" ;;
        *sonnet*) echo "$USAGE_YELLOW" ;;
        *opus*) echo "$USAGE_ORANGE" ;;
        *fable*) echo "$USAGE_RED" ;;
        *) echo "$USAGE_DEFAULT" ;;
    esac
}

effort_color() {
    case "$1" in
        low|medium) echo "$USAGE_GREEN" ;;
        high) echo "$USAGE_YELLOW" ;;
        xhigh) echo "$USAGE_ORANGE" ;;
        max) echo "$USAGE_RED" ;;
        *) echo "$USAGE_DEFAULT" ;;
    esac
}

# ---------------------------------------------------------------------------
# Icons (Nerd Font glyphs, one constant per meaning so they're never retyped)
# ---------------------------------------------------------------------------

ICON_WORKTREE="󰙅"
ICON_BRANCH=""
ICON_WORKING_DIR="󰣞"
ICON_MODEL="󰧑"
ICON_LINES_DIFF=""
ICON_FILES_CHANGED="󱀲"
ICON_THINKING="󰟷"
ICON_COST="󰄖"
ICON_TOKENS_IN="󰁝"
ICON_TOKENS_OUT="󰁅"
ICON_TOKENS_GROUP="󰹺"
ICON_CONTEXT=""
ICON_CLOCK=""
ICON_HOURGLASS=""

effort_icon() {
    case "$1" in
        low)    echo "󰾆" ;;
        medium) echo "󰾅" ;;
        high)   echo "󰓅" ;;
        xhigh)  echo "󰡴" ;;
        max)    echo "󱓞" ;;
        *)      echo "" ;;
    esac
}

# ---------------------------------------------------------------------------
# Rendering helpers
# ---------------------------------------------------------------------------

icon() {
    local glyph="$1" color="$2"
    printf "${color}${glyph}${RESET}"
}

make_bar() {
    local pct=$1 width=${2:-10}
    local filled=$(( pct * width / 100 ))
    local bar=""
    local i=0
    while (( i < filled )); do bar+="█"; (( i++ )); done
    while (( i < width )); do bar+="░"; (( i++ )); done
    echo "$bar"
}

format_context() {
    local pct=$1
    [[ -z $pct ]] && echo "-" && return
    local color=$(usage_color "$pct")
    local bar=$(make_bar "$pct")
    printf "${color}${bar}${RESET} ${color}${pct}%%${RESET}"
}

# strip any ANSI SGR escape sequence to compute a string's true on-screen width
plain() {
    local s="$1"
    printf '%s' "${s//(#b)$ESC\[[0-9\;]#m/}"
}

# Claude Code's statusline box reserves a few columns of its own margin;
# without this, lines that fill the full $COLUMNS width get truncated with an ellipsis.
STATUSLINE_MARGIN=6

# pack $left and $right onto one line, padding so $right lands flush against the safe width
render_line() {
    local left="$1" right="$2"
    local cols=$(( ${COLUMNS:-80} - STATUSLINE_MARGIN ))
    local left_plain=$(plain "$left")
    local right_plain=$(plain "$right")
    local pad=$(( cols - ${#left_plain} - ${#right_plain} ))
    (( pad < 1 )) && pad=1
    # Anchor LHS with a reset, Claude Code strips leading spaces when LHS empty
    printf '%s%s%*s%s' "$RESET" "$left" "$pad" "" "$right"
}

# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------

mode="${1:-status}"

input=$(cat)

jq_input() { echo "$input" | jq -r "$1"; }

if [[ "$mode" == "subagent" ]]; then
    source "${0:A:h}/subagent-statusline.zsh"
    exit 0
fi

lines=()

# ---------------------------------------------------------------------------
# Line 1: repo/worktree + working dir (left)  |  model + effort (right)
# ---------------------------------------------------------------------------

typeset -T line1_left_str line1_left_el " "
typeset -T line1_right_str line1_right_el " "

repo=$(git -C "$working_dir" rev-parse --show-toplevel 2>/dev/null)
if [[ -n "$repo" ]]; then
    project=$(basename "$repo")
    working_project=$project
    branch=$(git -C "$repo" branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)
    worktree=$(jq_input '.workspace.git_worktree // empty')

    if [[ -n "$worktree" ]]; then
        git_icon="$ICON_WORKTREE"
        project=$(basename "$(dirname "$(git -C "$repo" rev-parse --git-common-dir)")")
        git_str="$(printf "${CYAN}${project}:${worktree}${RESET}")"
        [[ "$worktree" != "$branch" ]] && git_str+=" $(icon "$ICON_BRANCH" "$CYAN") $(printf "${CYAN}${branch}${RESET}")"
    else
        git_icon="$ICON_BRANCH"
        git_str="$(printf "${CYAN}${project}:${branch}${RESET}")"
    fi

    staged=$(git -C "$repo" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git -C "$repo" diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    line1_left_el+=( $(icon "$git_icon" "$CYAN") $git_str )
fi

working_dir=$(jq_input '.workspace.current_dir // empty')
if [[ -n "$working_dir" ]]; then
    working_dir=$(basename "$working_dir")
    [[ "$working_dir" != "$working_project" ]] && line1_left_el+=( $(icon "$ICON_WORKING_DIR" "$CYAN") "$(printf "${CYAN}${working_dir}${RESET}")" )
fi

model=$(jq_input '.model.display_name // "Unknown Model"')
effort=$(jq_input '.effort.level // empty')
thinking_enabled=$(jq_input '.thinking.enabled // false')

model_col=$(model_color "$model")
line1_right_el+=( $(icon "$ICON_MODEL" "$model_col") "$(printf "${model_col}${model}${RESET}")" )

effort_col=$(effort_color "$effort")
typeset -T effort_label effort_label_el " "
[[ -n "$effort" ]] && effort_label_el+=( "$effort" )
[[ "$thinking_enabled" == "true" ]] && effort_label_el+=( "$ICON_THINKING" )
if [[ ${#effort_label_el} -gt 0 ]]; then
    line1_right_el+=( $(icon "$(effort_icon "$effort")" "$effort_col") "$(printf "${effort_col}${effort_label}${RESET}")" )
fi

context_used=$(jq_input '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
context_color=$(usage_color "$context_used")
line1_right_el+=( $(icon "$ICON_CONTEXT" "$context_color") "$(format_context "$context_used")" )

lines+=( "$(render_line "$line1_left_str" "$line1_right_str")" )

# ---------------------------------------------------------------------------
# Line 2: lines added/removed (left)  |  cost, tokens, context usage (right)
# ---------------------------------------------------------------------------

typeset -T line2_left_str line2_left_el " "
typeset -T line2_right_str line2_right_el " "

lines_added=$(jq_input '.cost.total_lines_added // 0')
lines_removed=$(jq_input '.cost.total_lines_removed // 0')
typeset -T stats_str stats_el " "
[[ $lines_added -gt 0 ]] && stats_el+="$(printf "${GREEN}+$(numfmt --grouping "$lines_added")${RESET}")"
[[ $lines_removed -gt 0 ]] && stats_el+="$(printf "${RED}-$(numfmt --grouping "$lines_removed")${RESET}")"
[[ ${#stats_el} -gt 0 ]] && line2_left_el+=( $(icon "$ICON_LINES_DIFF" "$BLUE") $stats_str )

typeset -T files_str files_el " "
[[ ${staged:-0} -gt 0 ]] && files_el+="$(printf "${GREEN}+${staged}${RESET}")"
[[ ${modified:-0} -gt 0 ]] && files_el+="$(printf "${YELLOW}~${modified}${RESET}")"
[[ ${#files_el} -gt 0 ]] && line2_left_el+=( $(icon "$ICON_FILES_CHANGED" "$BLUE") $files_str )

total_cost=$(jq_input '.cost.total_cost_usd // empty')
if [[ -n "$total_cost" ]]; then
    cost_display=$(awk "BEGIN { printf \"%.2f\", $total_cost }")
    line2_right_el+=( $(icon "$ICON_COST" "$YELLOW") "$(printf "${YELLOW}\$${cost_display}${RESET}")" )
fi

total_input=$(jq_input '.context_window.total_input_tokens // empty')
total_output=$(jq_input '.context_window.total_output_tokens // empty')
typeset -T tokens_str tokens_el " "
[[ $total_input -gt 0 ]] && tokens_el+="${MAGENTA}$(numfmt --grouping "$total_input") ${ICON_TOKENS_IN}${RESET}"
[[ $total_output -gt 0 ]] && tokens_el+="${GREEN}$(numfmt --grouping "$total_output") ${ICON_TOKENS_OUT}${RESET}"
[[ ${#tokens_el} -gt 0 ]] && line2_right_el+=( $(icon "$ICON_TOKENS_GROUP" "$MAGENTA") $tokens_str )

lines+=( "$(render_line "$line2_left_str" "$line2_right_str")" )

# ---------------------------------------------------------------------------
# Line 3 (optional): 5h and 7d rate limits (right-aligned; omitted if absent)
# ---------------------------------------------------------------------------

typeset -T line3_right_str line3_right_el " "

format_rate_limit() {
    local pct=$1 reset_ts=$2 date_fmt=$3 bar_width=$4
    [[ -z $pct ]] && echo "-" && return
    pct=$(printf "%.0f" "$pct")

    local color=""
    if [[ $pct -ge 90 ]]; then color="$RED"
    elif [[ $pct -ge 70 ]]; then color="$YELLOW"
    fi

    local reset_time=""
    if [[ -n $reset_ts ]]; then
        local formatted=$(date -r "$reset_ts" "+$date_fmt" 2>/dev/null || date -d "@$reset_ts" "+$date_fmt" 2>/dev/null)
        reset_time="${I_BLACK} ${ICON_CLOCK} ${formatted}${RESET}"
    fi

    local bar=$(make_bar "$pct" "$bar_width")
    printf "${color}${bar}${RESET} ${BLUE}${pct}%%${RESET} $reset_time"
}

rl_5h_pct=$(jq_input '.rate_limits.five_hour.used_percentage // empty')
rl_5h_reset=$(jq_input '.rate_limits.five_hour.resets_at // empty')
if [[ -n $rl_5h_pct ]]; then
    line3_right_el+=( $(icon "${ICON_HOURGLASS} 5h" "$BLUE") "$(format_rate_limit "$rl_5h_pct" "$rl_5h_reset" "%H:%M" 10)" )
fi

rl_7d_pct=$(jq_input '.rate_limits.seven_day.used_percentage // empty')
rl_7d_reset=$(jq_input '.rate_limits.seven_day.resets_at // empty')
if [[ -n $rl_7d_pct ]]; then
    line3_right_el+=( $(icon "${ICON_HOURGLASS} 7d" "$BLUE") "$(format_rate_limit "$rl_7d_pct" "$rl_7d_reset" "%a %H:%M" 5)" )
fi

[[ ${#line3_right_el} -gt 0 ]] && lines+=( "$(render_line "" "$line3_right_str")" )

# ---------------------------------------------------------------------------

print -rl -- "${lines[@]}"
