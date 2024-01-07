start() {
  echo ""
  echo -e "\x1B[1m\x1B[38;5;178mMorningstar\x1B[0m\x1B[38;5;229m is \x1B[3mexerting pressure 🌟 \x1B[0m"
  echo ""
}

start

zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git zsh-autosuggestions z copypath nvm)

zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd eslint prettier typescript

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export EDITOR=nvim
export PAGER=batcat
export BAT_PAGER=less


# Path stuff

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:/usr/:/home/xylar/.nimble/bin:/home/xylar/.local/bin:$HOME/.zshscripts:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /snap/google-cloud-cli/current/completion.zsh.inc

# NNN File manager stuff

n ()
{
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

export NNN_BMS="w:$HOME//home/xylar/work/;c:$HOME/.config/;"
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_FCOLORS='c1e23736006039f7c6d6abc4'
export NNN_PLUG='p:preview-tui;c:!code $PWD;v:!explorer.exe .;d:dragon;'
export NNN_USE_EDITOR=1

# source /home/xylar/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# .zshrc utility functions start -----------------------------------------

function switch-node {

  if [[ -z "$1" ]]; then
    echo "Error: Please provide a Node version."
    return 1
  fi

  if [[ "$1" == "default" ]]; then
    desired_version="v20.9.0"
  else
    desired_version="v$1"
  fi

  current_version=$(node -v 2>/dev/null)

  if [[ "$current_version" != "$desired_version" ]]; then
    nvm use ${desired_version#v}
  fi
}

# ------------------------------------------- .zshrc utilities end

# functions start ---------------------------------------------

code() {
    /usr/bin/env code "$@" &
}

responses=(
  "Hi \x1B[1m\x1B[38;5;57mXylar\x1B[0m ☄ Let's get to work shall we? 💫"
  "Hello \x1B[1m\x1B[38;5;57mXylar\x1B[0m ☄ Our work awaits! ✨"
  "Hey \x1B[1m\x1B[38;5;57mXylar\x1B[0m ☄ Let's build something celestial 🌌"
  "\x1B[1m\x1B[38;5;57mXylar\x1B[0m ☄ hey there! 👋 There's a lot to do!"
  "Hello my \x1B[2m\x1B[38;5;221mfriend\x1B[0m 🤗 let's deal with things together 🤝"
  "Howdy \x1B[1m\x1B[38;5;214mpartner\x1B[0m 🤠 let's \x1B[3mwrangle\x1B[0m up some work together, eh?"
)

function hi {
  echo ""
  echo -e "${responses[$RANDOM % ${#responses[@]} + 1]}"
  echo ""
}

function yeehaw {
  echo ""
  echo -e "YEEEEEEEEHAWWWWWWWWW \x1B[1m\x1B[38;5;214mPARDNER\x1B[0m! 🤠"
  echo ""
}

function switch-and-open {
  local node_version=$1
  local project_path=$2
  shift 2

  if [[ $1 != "-n" ]]; then
    switch-node $node_version
  fi

  code -n $project_path "$@"
}

function adcs-fe {
  switch-and-open 14.19.3 /home/xylar/work/hpixel/adcs-fe "$@"
}

function adcs-be {
  switch-and-open 14.19.3 /home/xylar/work/hpixel/adcs-be "$@"
}

function adcs {
  adcs-fe "$@" &
  adcs-be "$@" &
}

function pixel-ui {
  switch-and-open 18.14.0 /home/xylar/work/hpixel/Pixel-UI-Nuxt3 "$@"
}

function medipixel {
  switch-and-open 18.17.1 /home/xylar/work/hpixel/medipixel "$@"
}

function xylar-web-lab {
  switch-and-open default /home/xylar/work/xylar-web-lab "$@"
}

function portfolio-test {
  switch-and-open 18.17.1 /home/xylar/work/portfolio-test "$@"
}

function extract {
  if [[ -z "$1" ]]; then
    echo "Specify a file to extract"
    return 1
  fi
  case $1 in
    *.tar.bz2)   tar xjf $1     ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       rar x $1       ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xf $1      ;;
    *.tbz2)      tar xjf $1     ;;
    *.tgz)       tar xzf $1     ;;
    *.zip)       unzip $1       ;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1        ;;
    *)           echo "'$1' cannot be extracted via this function" ;;
  esac
}

function mkcd {
  mkdir -p "$1" && cd "$1"
}

function update {
  sudo nala upgrade -y
}

function gitdiff {
  git diff HEAD~1..HEAD
}

function dirtree {
  tree -L ${1:-3}
}

function home {
  cd /home/xylar
}

function help {
  echo "These are the commands you've defined"
  echo "-------------------------------------"
  grep -E '^[a-zA-Z0-9_]+:.*##' ~/.zshrc | sed -E 's/[^a-zA-Z0-9_]+://'
}

function fix-history {
  original_path=$(pwd)

  cd ~
  mv .zsh_history .zsh_history_bad
  strings .zsh_history_bad > .zsh_history
  fc -R .zsh_history
  rm ~/.zsh_history_bad
  echo "History fixed"

  cd "$original_path"
}

alias zs="code ~/.zshrc"
alias hey="hi"
alias hello="hi"
alias aloha="hi"
alias howdy="yeehaw"
alias bat="batcat"
alias py="python3"
alias pixelui="pixel-ui"
alias web-lab="xylar-web-lab"
alias xwl="xylar-web-lab"
alias test-portfolio="portfolio-test"
alias my-pc="neofetch"
alias this-pc="neofetch"
alias upgrade="update"
alias git-diff="gitdiff"
alias node-switch="switch-node"
alias refresh="source ~/.zshrc"

creation_time=$(stat -c %Y /mnt/)

neofetch() {

  current_time=$(date +%s)
  total_time=$((current_time - creation_time))
  number_of_days=$((total_time / 86400))
  number_of_hours=$((total_time / 3600 % 24))
  number_of_minutes=$((total_time / 60 % 60))
  creation_string="${number_of_days}d ${number_of_hours}h ${number_of_minutes}m"
  uptime_string="$(uptime -p)"

    printf "

  \e[38;5;69m ▼
  \e[38;5;69m   7▲
  \e[38;5;69m      ▼\e[38;5;63m▲      \e[38;5;57m    ▼
  \e[38;5;69m       \e[38;5;63m  Æy   \e[38;5;57m      y\e[38;5;56m
  \e[38;5;69m       \e[38;5;63m    78▲\e[38;5;57m       \e[38;5;56m7y
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m▼▲     \e[38;5;56m  ▼
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m  7Æ▲  \e[38;5;56m    ▼                               \e[38;5;56mXylar's PC: \x1B[38;5;178mMorningstar\x1B[0m\e[m
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m     78\e[38;5;56my    7▲
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m 9Æy   \e[38;5;55m8y \e[38;5;93m    \e[38;5;54m     Æ9               \x1B[38;5;229mWindows Subsystem for Linux (WSL2)\x1B[0m
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m   788Æ\e[38;5;55m88Æ\e[38;5;93m    \e[38;5;54m  ▲89    \e[m             \x1B[38;5;229mxylar@Shayus-Morningstar\x1B[0m
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m      ▼\e[38;5;55m888\e[38;5;93m8▲ ▲\e[38;5;92mÆ88    \e[m               \x1B[38;5;229mBuild:\x1B[0m 19045
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m       \e[38;5;55m  Æ\e[38;5;93m8888\e[38;5;92m8   \e[m                  \x1B[38;5;229mBranch:\x1B[0m vb_release
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m       \e[38;5;55m ▲8\e[38;5;93m8888\e[38;5;92m8y  \e[m                  \x1B[38;5;229mRelease:\x1B[0m Ubuntu 22.04.1 LTS
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m     yÆ\e[38;5;55m888\e[38;5;93m89  \e[38;5;92m▼8Æ     \e[m              \x1B[38;5;229mKernel:\x1B[0m Linux 5.15.79.1-microsoft-standard-WSL2
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m   ▲8Æ9\e[38;5;55m888\e[38;5;93m    \e[38;5;54m   Æ▲   \e[m              \x1B[38;5;229mUptime:\x1B[0m${uptime_string#*up}
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m▲88   z\e[38;5;55m8  \e[38;5;93m    \e[38;5;54m     7▲               \x1B[38;5;229mAge of Kernel:\x1B[0m ${creation_string}
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m     ÆÆ\e[38;5;56m     Æ
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m  ▲Æ   \e[38;5;56m   y9
  \e[38;5;69m       \e[38;5;63m      ▲\e[38;5;57mÆ9     \e[38;5;56m  Æ
  \e[38;5;69m       \e[38;5;63m    Æ8 \e[38;5;57m       \e[38;5;56mÆ
  \e[38;5;69m       \e[38;5;63m ▲8    \e[38;5;57m     ▲
  \e[38;5;69m     ▲Æ\e[38;5;63m       \e[38;5;57m    9
  \e[38;5;69m   Æ9
  \e[38;5;69m▲9
               
";
}

xylarpurple() {
  printf "

  \e[38;5;69m ▼
  \e[38;5;69m   7▲
  \e[38;5;69m      ▼\e[38;5;63m▲      \e[38;5;57m    ▼
  \e[38;5;69m       \e[38;5;63m  Æy   \e[38;5;57m      y\e[38;5;56m
  \e[38;5;69m       \e[38;5;63m    78▲\e[38;5;57m       \e[38;5;56m7y
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m▼▲     \e[38;5;56m  ▼
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m  7Æ▲  \e[38;5;56m    ▼
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m     78\e[38;5;56my    7▲
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m 9Æy   \e[38;5;55m8y \e[38;5;93m    \e[38;5;54m     Æ9
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m   788Æ\e[38;5;55m88Æ\e[38;5;93m    \e[38;5;54m  ▲89
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m      ▼\e[38;5;55m888\e[38;5;93m8▲ ▲\e[38;5;92mÆ88
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m       \e[38;5;55m  Æ\e[38;5;93m8888\e[38;5;92m8
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m       \e[38;5;55m ▲8\e[38;5;93m8888\e[38;5;92m8y
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m     yÆ\e[38;5;55m888\e[38;5;93m89  \e[38;5;92m▼8Æ
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m   ▲8Æ9\e[38;5;55m888\e[38;5;93m    \e[38;5;54m   Æ▲
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m       \e[38;5;56m▲88   z\e[38;5;55m8  \e[38;5;93m    \e[38;5;54m     7▲
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m     ÆÆ\e[38;5;56m     Æ
  \e[38;5;69m       \e[38;5;63m       \e[38;5;57m  ▲Æ   \e[38;5;56m   y9
  \e[38;5;69m       \e[38;5;63m      ▲\e[38;5;57mÆ9     \e[38;5;56m  Æ
  \e[38;5;69m       \e[38;5;63m    Æ8 \e[38;5;57m       \e[38;5;56mÆ
  \e[38;5;69m       \e[38;5;63m ▲8    \e[38;5;57m     ▲
  \e[38;5;69m     ▲Æ\e[38;5;63m       \e[38;5;57m    9
  \e[38;5;69m   Æ9
  \e[38;5;69m▲9
               
";
}

xylar() {
  printf "

   ▼
     7▲
        ▼▲          ▼
           Æy         y
             78▲       7y
                ▼▲       ▼
                  7Æ▲      ▼
                     78y    7▲
                        9Æy   8y          Æ9
                          788Æ88Æ      ▲89
                             ▼8888▲ ▲Æ88
                                Æ88888
                               ▲888888y
                            yÆ88889  ▼8Æ
                          ▲8Æ9888       Æ▲
                       ▲88   z8           7▲
                     ÆÆ     Æ
                  ▲Æ      y9
               ▲Æ9       Æ
             Æ8        Æ
          ▲8         ▲
       ▲Æ           9
     Æ9
  ▲9
               
";
}
# pnpm
export PNPM_HOME="/home/xylar/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# bun completions
[ -s "/home/xylar/.bun/_bun" ] && source "/home/xylar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
