#!/usr/bin/env zsh
#
# Sourced from statusline.sh in "subagent" mode; reuses its colors/icons/
# render helpers and $input/jq_input(). Emits one `{"id": ..., "content": ...}`
# line per subagent task.

ICON_STATUS_DOT="●"

status_color() {
    case "${1:l}" in
    running | working) echo "$USAGE_GREEN" ;;
    pending | queued | blocked) echo "$USAGE_YELLOW" ;;
    error | failed) echo "$USAGE_RED" ;;
    completed | done | success | stopped | cancelled) echo "$I_BLACK" ;;
    *) echo "$USAGE_DEFAULT" ;;
    esac
}

model_short() {
    case "${1:l}" in
    *haiku*) echo "Haiku" ;;
    *sonnet*) echo "Sonnet" ;;
    *opus*) echo "Opus" ;;
    *fable*) echo "Fable" ;;
    *) echo "$1" ;;
    esac
}

# seconds -> "1h 02m" / "2m 03s" / "45s"
format_duration() {
    local s=$1 h m rem
    h=$((s / 3600))
    m=$(((s % 3600) / 60))
    rem=$((s % 60))
    if ((h > 0)); then
        printf "%dh %02dm" "$h" "$m"
    elif ((m > 0)); then
        printf "%dm %02ds" "$m" "$rem"
    else
        printf "%ds" "$rem"
    fi
}

# truncate plain (non-ANSI) text to fit $2 columns, adding an ellipsis if cut
truncate_text() {
    local text="$1" width=$2
    ((${#text} <= width)) && {
        printf '%s' "$text"
        return
    }
    ((width <= 1)) && {
        printf '%s' "…"
        return
    }
    printf '%s…' "${text[1,$((width - 1))]}"
}

# pack $left and $right into exactly $3 columns, padding between them
render_row() {
    local left="$1" right="$2" width=$3
    local left_plain=$(plain "$left")
    local right_plain=$(plain "$right")
    local pad=$((width - ${#left_plain} - ${#right_plain}))
    ((pad < 1)) && pad=1
    printf '%s%s%*s%s' "$RESET" "$left" "$pad" "" "$right"
}

columns=$(jq_input '.columns // 80')
session_effort=$(jq_input '.effort.level // empty')

task_count=$(jq_input '.tasks | length')
now_ms=$(printf '%.0f' $((EPOCHREALTIME * 1000)))

for ((i = 0; i < task_count; i++)); do
    id=$(jq_input ".tasks[$i].id")
    task_status=$(jq_input ".tasks[$i].status // empty")
    type=$(jq_input ".tasks[$i].type // empty")
    label=$(jq_input ".tasks[$i].label // .tasks[$i].name // .tasks[$i].description // empty")
    start_time=$(jq_input ".tasks[$i].startTime // empty")
    model=$(jq_input ".tasks[$i].model // empty")
    effort=$(jq_input ".tasks[$i].effort // empty")
    token_count=$(jq_input ".tasks[$i].tokenCount // empty")

    status_col=$(status_color "$task_status")
    dot="$(printf "${status_col}${ICON_STATUS_DOT}${RESET}")"

    elapsed=""
    if [[ -n "$start_time" ]]; then
        elapsed_s=$(((now_ms - start_time) / 1000))
        ((elapsed_s < 0)) && elapsed_s=0
        elapsed="$(format_duration "$elapsed_s")"
    fi

    type_label=""
    [[ -n "$type" ]] && type_label="${(C)${type//_/ }}"

    typeset -T left_str left_el " "
    left_el+=("$dot")
    [[ -n "$elapsed" ]] && left_el+=("${I_BLACK}${elapsed}${RESET}")
    [[ -n "$type_label" ]] && left_el+=("${I_BLACK}${type_label}${RESET}")

    typeset -T right_str right_el " "
    if [[ -n "$model" ]]; then
        model_col=$(model_color "$model")
        right_el+=("$(icon "$ICON_MODEL" "$model_col")" "$(printf "${model_col}$(model_short "$model")${RESET}")")
    fi

    effort_display="$effort"
    [[ -z "$effort_display" ]] && effort_display="$session_effort"
    if [[ -n "$effort_display" ]]; then
        effort_col=$(effort_color "$effort_display")
        right_el+=("$(icon "$(effort_icon "$effort_display")" "$effort_col")" "$(printf "${effort_col}${effort_display}${RESET}")")
    fi

    if [[ -n "$token_count" ]]; then
        tokens_k=$(awk "BEGIN { printf \"%.1fk\", $token_count / 1000 }")
        right_el+=("$(icon "$ICON_TOKENS_GROUP" "$MAGENTA")" "$(printf "${MAGENTA}${tokens_k}${RESET}")")
    fi

    left_plain=$(plain "$left_str")
    right_plain=$(plain "$right_str")
    available=$((columns - ${#left_plain} - ${#right_plain} - 2))
    if [[ -n "$label" && $available -gt 0 ]]; then
        left_el+=("$(truncate_text "$label" "$available")")
    fi

    content="$(render_row "$left_str" "$right_str" "$columns")"
    jq -ncM --arg id "$id" --arg content "$content" '{id: $id, content: $content}'
done
