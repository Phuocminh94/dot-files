# If not running interactively, exit script
[[ $- != *i* ]] && return

# Load dotfiles:
for file in ~/.{bash_prompt,aliases,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/Users/minhbui/.cache/lm-studio/bin"
