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

# Start microk8s
startk8s() {}

# Stop microk8s
stopk8s() {}

# Bring up the vpn
startvpn() {
    nmcli c up vapor
}

# Bring down the vpn
stopvpn() {
    nmcli c down vapor
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
