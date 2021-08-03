# Description: Vapor.io workspace

setopt shwordsplit

cd ~/Vapor

# Local variables
VAPOR_HOME=~/Vapor
HELM_HOME=~/.helm
GH_REPOS="cloud-infra cloud-ops consumer-api containerlog deployment-tools edge-monitor ouroboros sctl synse-charts synse-docs vator"

# Set environment variable(s)
export PATH=$PATH:~/Vapor/bin
export KUBECONFIG=~/.kube/microk8s
export MAGMA_ROOT=~/Vapor/magma/magma
export OUR_GH_TOKEN=$GITHUB_ACCESS_TOKEN

################
# Set alias(s) #
################

# Link helm to helm3. Do not use microk8s.helm3; it's too old.
alias helm="helm3"
alias kubectl="microk8s.kubectl"

#####################
# Autocompletion(s) #
#####################

# To be tested
source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell

#############
# functions #
#############

# Remove stopped docker containers
docker-clean-containers() {
    docker container rm $(docker container ls -aq)
}

# Remove docker images
docker-clean-images() {
    docker container rmi $(docker image ls -aq)
}

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
    sudo snap start microk8s
    microk8s status --wait-ready
}

# Stop microk8s
k8s-down() {
    sudo snap stop microk8s
}

# Bring up the vpn
vpn-up() {
    sudo tailscale up --accept-routes
}

vpn-status() {
    tailscale status
}

# Bring down the vpn
vpn-down() {
    sudo tailscale down

    # TODO: Reconnect to wifi to clear the DNS
    # AP=$(nmcli -t connection show --active| head -n 1 | awk -F: '{print $1}')
    # nmcli connection down $AP
    # nmcli connection up $AP
}
