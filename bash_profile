
# Make Bash history sane across terminals
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Give us all the open files
# ulimit -n 65536 65536

# Turn on pretty colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Set path, giving /usr/local priority
PATH=$HOME/bin:$HOME/go/bin:/usr/local/bin:/usr/local/sbin:"${PATH}"

# Load up ssh key(s)
#if [ -z "$SSH_AUTH_SOCK" ] ; then
#  eval `ssh-agent -s`
#  ssh-add $HOME/.ssh/id_launchpad_rsa
#  ssh-add $HOME/.ssh/id_github_rsa
#  ssh-add $HOME/.ssh/id_rsa
#fi

if [ -d $HOME/go ]; then
    export GOPATH=$HOME/go 
    PATH=$GOPATH/bin:$PATH
fi

if [ -d $HOME/.juju-plugins ]; then
    PATH=$PATH:$HOME/.juju-plugins
fi

# Include my Perl libraries
# export PERL5LIB=~/lib:"${PERL5LIB}"

# Setup Amazon EC2 Command-Line Tools
if [ -d $HOME/.ec2 ]; then
    export EC2_HOME=~/.ec2
    export PATH=$PATH:$EC2_HOME/bin
    export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
    export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
fi

if [ -d /usr/libexec/java_home ]; then
    # NOTE: this may be an OS X-specific path
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Setup Amazon RDS command-line tools
if [ -d $HOME/.rds ]; then
    export AWS_RDS_HOME=~/.rds
    export PATH=$PATH:$AWS_RDS_HOME/bin
    export AWS_CREDENTIAL_FILE=~/.rds/credentials
fi

# Setup SVN for a sane editor
export SVN_EDITOR=/usr/bin/vim


# OS X-specific stuff
if [ "$(uname)" == "Darwin" ]; then
    # Go go Gadget Go!
    GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
    export GOPATH=$HOME/.go
    export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
    PATH=$GOROOT/bin:$GOPATH/bin:"${PATH}"

    # Postgresql alias
    alias pgdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
    alias pgup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'

    # Mysql alias
    alias mydown='mysql.server stop'
    alias myup='mysql.server start'

    # Pretty log file colourisation
    source "`brew --prefix grc`/etc/grc.bashrc"

    [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; source `brew --prefix`/etc/bash_completion.d/vagrant

fi

if [ -d $HOME/liquidprompt ]; then
    source ~/liquidprompt/liquidprompt
fi


if [ -d $HOME/google-cloud-sdk ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source '/Users/stone/google-cloud-sdk/path.bash.inc'

    # The next line enables shell command completion for gcloud.
    source '/Users/stone/google-cloud-sdk/completion.bash.inc'
fi

# Add support for Juju
if [ -d $HOME/charms ]; then
    export INTERFACE_PATH=$HOME/charms/interfaces
    export JUJU_REPOSITORY=$HOME/charms
fi
PATH=$PATH:$HOME/.juju-plugins

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


export PATH="$HOME/.poetry/bin:$PATH"
. "$HOME/.cargo/env"
