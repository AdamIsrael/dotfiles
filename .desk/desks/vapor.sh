# Description: Vapor.io workspace

cd ~/Vapor

# Increment refcount

# Set environment variable(s)
export PATH=$PATH:~/Vapor/bin

# Set alias(s)

# Start service(s)
#echo -n "Starting userdev (LXD)..."
#lxc start userdev || true
#echo "done."

# functions

# Open a Deployment Tools shell
dt() {
    docker run -ti --rm -v $HOME:/localhost --privileged vaporio/deployment-tools:latest /bin/bash
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
}

# Push code to maidalchini
push_maidalchini() {

}

# Pull code from maidalchini
pull_maidalchini() {}

# Do any session cleanup, i.e., stopping services
on_exit() {
    # Might need a refcount here, so other sessions aren't nuked
    #echo -n "Stopping userdev (LXD)..."
    #lxc stop userdev
    #echo "done."
}
trap on_exit EXIT
