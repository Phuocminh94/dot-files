
autoload -Uz colors && colors
setopt PROMPT_SUBST


# Load dotfiles:
for file in ~/.{zprompt,aliases,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;


# Starship
eval "$(starship init zsh)"


# Anaconda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Animation utils as package
# export PYTHONPATH="/Users/minhbui/Desktop/Work/Animation/:$PYTHONPATH"


# Postgresql
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
# export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"


# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@76/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@76/sbin:$PATH"
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LC_TIME=en_US.UTF-8
export CPPFLAGS="-I/opt/homebrew/include"


# GCC
export LIBRARY_PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current:$LD_LIBRARY_PATH"
export LDFLAGS="-L/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current"
export FLIBS="-L/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current -lgfortran"


# XQuartz (X11)
export LIBRARY_PATH="/opt/X11/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/opt/X11/lib:$LD_LIBRARY_PATH"
export LDFLAGS="$LDFLAGS -L/opt/X11/lib"


# Ensure Homebrew's sbin is in the PATH
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
