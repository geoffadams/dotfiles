# general options
setopt correct
setopt prompt_subst

# starship prompt before all else
eval_if_cmd starship "starship init zsh"
