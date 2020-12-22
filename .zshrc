PROMPT='%(?.%F{green}.%F{red})%n:%f%F{063}%~$%f '

export EDITOR=vim

export LC_TIME=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export CLOUDSDK_PYTHON=python3.8

export NEXUS_CLI_WORKDIR=$HOME/work/nexus-cli/
export NEXUS_CLI_ROOT_DIR=$NEXUS_CLI_WORKDIR
export NEXUS_USERNAME=liorm
export NEXUS_PASSWORD=wGc4UwbhhqK39yTe

alias ll='ls -alFG'
alias la='ls -A'
alias l='ls -CF'

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# Load Make completion
zstyle ':completion:*:*:make:*' tag-order 'targets'

# Docker completion
zstyle ':completion:*:*:docker:*' script ~/.zsh/_docker-compose
fpath=(~/.zsh/ $fpath)

autoload -Uz compinit && compinit

# Load PipEnv completion
eval "$(pipenv --completion)"

# Load EB tools completion
#eval "$(_VIDEO_BEE_COMPLETE=source_zsh video-bee)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lior/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/lior/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lior/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/lior/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# added by travis gem
[ ! -s /Users/lior/.travis/travis.sh ] || source /Users/lior/.travis/travis.sh
