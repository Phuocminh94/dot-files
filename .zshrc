# =============================
#  Base Zsh Setup
# =============================

autoload -Uz colors && colors
setopt PROMPT_SUBST


# =============================
#  OS Detection
# =============================
case "$(uname -s)" in
  Darwin)
    export IS_MACOS=true
    export IS_LINUX=false
    ;;
  Linux)
    export IS_MACOS=false
    export IS_LINUX=true
    ;;
  *)
    export IS_MACOS=false
    export IS_LINUX=false
    ;;
esac


# =============================
#  Load Dotfiles (prompt, aliases, private)
# =============================
for file in ~/.{zprompt,aliases,private}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file


# =============================
#  Starship Prompt
# =============================
# Dynamic OS icon defined below
eval "$(starship init zsh)"


# =============================
#  Conda Setup (Cross-Platform)
# =============================

if [[ "$IS_MACOS" == true ]]; then
  # macOS (Homebrew Anaconda)
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
fi

if [[ "$IS_LINUX" == true ]]; then
  # ----- Miniconda/Miniforge/Mambaforge detection -----
  typeset -a _conda_candidates
  _conda_candidates=(
    "$HOME/miniconda3"
    "/opt/miniconda3"
    "$HOME/mambaforge"
    "$HOME/miniforge3"
  )

  CONDA_ROOT=""
  for d in "${_conda_candidates[@]}"; do
    [[ -d "$d" ]] && CONDA_ROOT="$d" && break
  done
  unset _conda_candidates

  if [[ -n "$CONDA_ROOT" ]]; then
    # Prefer the official hook if available
    __conda_setup="$("$CONDA_ROOT/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)" || __conda_setup=""
    if [[ -n "$__conda_setup" ]]; then
      eval "$__conda_setup"
    elif [[ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]]; then
      . "$CONDA_ROOT/etc/profile.d/conda.sh"
    else
      # Fallback: prepend bin to PATH
      export PATH="$CONDA_ROOT/bin:$PATH"
    fi
    unset __conda_setup
  else
    print -P "%F{yellow}WARN:%f Miniconda/Miniforge not found (looked in ~/miniconda3, /opt/miniconda3, ~/mambaforge, ~/miniforge3)"
  fi
fi


# =============================
#  Platform-Specific Configuration
# =============================

if [[ "$IS_MACOS" == true ]]; then
  # ---------- macOS ----------
  export PATH="/opt/homebrew/sbin:$PATH"
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
  export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
  export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
  export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
  export PATH="/opt/homebrew/opt/icu4c@76/bin:$PATH"
  export PATH="/opt/homebrew/opt/icu4c@76/sbin:$PATH"

  export CPPFLAGS="-I/opt/homebrew/include"
  export LIBRARY_PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current:$LIBRARY_PATH"
  export LD_LIBRARY_PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current:$LD_LIBRARY_PATH"
  export LDFLAGS="-L/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current"
  export FLIBS="-L/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/current -lgfortran"

  # XQuartz (X11)
  export LIBRARY_PATH="/opt/X11/lib:$LIBRARY_PATH"
  export LD_LIBRARY_PATH="/opt/X11/lib:$LD_LIBRARY_PATH"
  export LDFLAGS="$LDFLAGS -L/opt/X11/lib"

  # Starship macOS icon
  export STARSHIP_OS_ICON=""
fi


if [[ "$IS_LINUX" == true ]]; then
  # ---------- Linux ----------
  export PATH="/usr/local/sbin:$PATH"
  export PATH="/usr/local/bin:$PATH"

  # Detect Arch Linux specifically
  if [[ -f /etc/arch-release ]]; then
    export STARSHIP_OS_ICON=""
  else
    export STARSHIP_OS_ICON=""
  fi
fi


# =============================
#  Extra Tools / Custom PATHs
# =============================
# Example custom project path
# export PYTHONPATH="/Users/minhbui/Desktop/Work/Animation/:$PYTHONPATH"


# =============================
#  Environment Variables for Compilers, etc.
# =============================
export CPPFLAGS="${CPPFLAGS:-}"
export LDFLAGS="${LDFLAGS:-}"
export LIBRARY_PATH="${LIBRARY_PATH:-}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
