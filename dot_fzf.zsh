# Setup fzf
# ---------
if [[ ! "$PATH" == */home/yousef-akbari/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/yousef-akbari/.fzf/bin"
fi

source <(fzf --zsh)
