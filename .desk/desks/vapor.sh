# Description: Vapor.io workspace

setopt shwordsplit

# Local variables
VAPOR_HOME=~/Vapor
HELM_HOME=~/.helm
GH_REPOS="cloud-infra cloud-ops consumer-api containerlog deployment-tools edge-events edge-ops ouroboros sctl synse-charts synse-docs vator"

# Make sure local Vapor path exists
if [[ ! -a $VAPOR_HOME ]]; then
    echo "Creating $VAPOR_HOME..."
    mkdir $VAPOR_HOME
fi

cd $VAPOR_HOME

# Set environment variable(s)
export PATH=$PATH:~/Vapor/bin
export KUBECONFIG=~/.kube/microk8s
export MAGMA_ROOT=~/Vapor/magma/magma
export OUR_GH_TOKEN=$GITHUB_ACCESS_TOKEN

################
# Set alias(s) #
################

# Link helm to helm3. Do not use microk8s.helm3; it's too old.
if type "helm3" > /dev/null; then
    alias helm="helm3"
fi

if type "microk8s.kubectl" > /dev/null; then
    alias kubectl="microk8s.kubectl"
fi

#####################
# Autocompletion(s) #
#####################

# kubectl
if type "kubectl" > /dev/null; then
    source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
fi

#############
# functions #
#############



# Open a Deployment Tools shell
dt() {
    docker run -ti --rm -v $HOME:/localhost --privileged vaporio/deployment-tools:latest /bin/bash
}

# Pull all Github repositories
gh-pull-all() {

    for repo in $GH_REPOS; do
        if [ ! -d $VAPOR_HOME/$repo ]; then
            echo "Need to clone $VAPOR_HOME/$repo"
            git clone git@github.com:vapor-ware/$repo.git
        else
            pushd $repo
            git pull
            popd
        fi

    done
}

# Start microk8s
k8s-up() {
    case "$OSTYPE" in
    darwin*)
        # ...
    ;;
    linux*)
        sudo snap start microk8s
        microk8s status --wait-ready
    ;;
    esac
}

# Stop microk8s
k8s-down() {
    case "$OSTYPE" in
    darwin*)
        # ...
    ;;
    linux*)
        sudo snap stop microk8s
    ;;
    esac
}

