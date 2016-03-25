
# History

# Don't put duplicate lines or lines starting with space in history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

HISTSIZE=-1
HISTFILESIZE=-1

ulimit -n 65536 65536 

# Turn on pretty colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Set path, giving /usr/local priority
PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:"${PATH}"

#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:/usr/local/Frameworks/Python.framework/Python:"${PYTHONPATH}"

# Include my Perl libraries
export PERL5LIB=~/lib:"${PERL5LIB}"

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
export JAVA_HOME=$(/usr/libexec/java_home)

# Setup Amazon RDS command-line tools
export AWS_RDS_HOME=~/.rds
export PATH=$PATH:$AWS_RDS_HOME/bin
export AWS_CREDENTIAL_FILE=~/.rds/credentials

# Setup SVN for a sane editor
export SVN_EDITOR=/usr/bin/vim

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

PATH=$PATH:$HOME/.juju-plugins

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
source ~/liquidprompt/liquidprompt

# The next line updates PATH for the Google Cloud SDK.
source '/Users/stone/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/stone/google-cloud-sdk/completion.bash.inc'
