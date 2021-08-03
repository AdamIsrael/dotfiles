# Description: desk for working on ClickMagick 

cd ~/ClickMagick

# Set the DSN to use for the MySQL database
export DBI_DSN="DBI:mysql(RaiseError=>1,PrintError=>0):mag;localhost;mysql_read_default_file=/etc/mysql/mysql.conf.d/my.local.cnf"

# ENV for integration tests
export CM_API_USER=test
export CM_API_KEY=QWERTASFDZXV
export CM_API_ROTATOR_ID=35828
export CM_API_LINK_ID=215880
export MAILCATCHER_HOST=127.0.0.1
export MAILCATCHER_PORT=1080

# Set alias(s)

# Start service(s)
#echo -n "Starting userdev (LXD)..."
#lxc start userdev || true
#echo "done."

# functions

# Bring up the vpn
vpn-up() {
    nmcli c up clickmagick
}

# Bring down the vpn
vpn-down() {
    nmcli c down clickmagick
}

# Do any session cleanup, i.e., stopping services
on_exit() {
    # Might need a refcount here, so other sessions aren't nuked
    #echo -n "Stopping userdev (LXD)..."
    #lxc stop userdev
    #echo "done."
}
trap on_exit EXIT
