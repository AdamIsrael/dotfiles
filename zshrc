# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Check for oh-my-zsh: https://ohmyz.sh/
if [[ -a ~/.oh-my-zsh ]]; then
    # Path to your oh-my-zsh installation.
    export ZSH=$HOME/.oh-my-zsh
    export ZSH_CUSTOM=$HOME/.dotfiles/zsh

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(
        git
        golang
        # Useful if using perlbrew
        # perl
        # Competion for pip
        pip
        python
        #common-aliases
        gpg-agent
        lxd-completion-zsh
        # highlight commands in green that are available
        zsh-syntax-highlighting
        # workspace manager
        desk
    )

    ZSH_THEME="bira-custom"

    # Source this after all ZSH-related options are set
    source $ZSH/oh-my-zsh.sh

fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [[ -a $HOME/.aliases ]]; then
    source $HOME/.aliases
fi

# If present, source our secrets/tokens/etc
if [[ -a $HOME/.secrets ]]; then
    source $HOME/.secrets
fi

# Golang config
export GOPATH=$HOME/go

export PATH=/usr/local/nodejs/bin:/snap/bin:$HOME/.local/bin:$HOME/bin:$GOPATH/bin:/usr/local/bin:/usr/local/sbin:"${PATH}"
export GOBIN=$GOPATH/bin

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true

# Use the microk8s docker for docker
#export DOCKER_HOST=unix:///var/snap/microk8s/current/docker.sock

# Perl bits
PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;

# Perlbrew
if [[ -a $HOME/perl5/perlbrew/etc/bashrc ]]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;

# Bash completions
autoload bashcompinit
bashcompinit

if [[ -a $HOME/.bash_completion.d/python-argcomplete.sh ]]; then
    source ~/.bash_completion.d/python-argcomplete.sh
fi

if [[ -a $HOME/.bash_completion.d/wp-completion.bash ]]; then
    source ~/.bash_completion.d/wp-completion.bash
fi

# This is looking for a _have function that may be bash-specific
#source /snap/lxd/current/etc/bash_completion.d/snap.lxd.lxc

# ktx
if [[ -a ~/.ktx ]]; then
    source "${HOME}"/.ktx
    source "${HOME}"/.ktx-completion.sh
fi


export PATH="$HOME/.poetry/bin:$PATH"
export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH
