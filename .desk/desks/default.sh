# default.sh
# Description: The default desk

cd ~

# source ~/.zshrc-default


yq() {
  cat "$1" | podman run -i --rm docker.io/mikefarah/yq:latest e "$2" -
}