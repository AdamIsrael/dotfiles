# A Justfile to finish customizing Adam-OS post-install
homedir := env_var('HOME')
omz := path_exists(homedir + "/.oh-my-zsh")
#omz := env_var('ZSH')



default:
  @just --list

# Install all software
install: install-omz install-dotfiles symlink-dotfiles install-dotfiles install-virtualization install-flatpaks update-dconf

# Install 1password
[linux]
install-1password:
  #!/usr/bin/env sh
  if ! rpm -qa | grep -q 1password; then
    wget -q https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm && \
      rpm-ostree install 1password-latest.rpm || true && rm 1password-latest.rpm
  fi

# Install my custom dotfiles
[unix]
install-dotfiles:
  #!/usr/bin/env sh
  if [ ! -d "{{omz}}" ]; then
    git clone https://github.com/AdamIsrael/dotfiles.git $HOME/.dotfiles
    cd $HOME/.dotfiles && git submodule update --init --remote && cd $HOME
  else
    if [[ $(git -C $HOME/.dotfiles diff --stat) != '' ]]; then
      echo "[dotfiles] Please stash or commit unstaged changes before updating."
    else
      cd $HOME/.dotfiles && git pull && git submodule update && cd $HOME
    fi
  fi

# Install layered packages
[linux]
install-layered:
  #!/usr/bin/env sh
  # install 3rd party repos/packages (1password, tailscale, vscode)
  sudo wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo && \
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=0\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
  rpm-ostree install --allow-inactive --idempotent tailscale && systemctl enable tailscaled && sudo rm -f /etc/yum.repos.d/tailscale.repo && \
  rpm-ostree install --idempotent code && sudo rm -f /etc/yum.repos.d/vscode.repo

  # install gnome extensions
  rpm-ostree install --idempotent gnome-shell-extension-auto-move-windows \
  gnome-shell-extension-frippery-bottom-panel \
  gnome-shell-extension-frippery-move-clock

  # Install local package(s)
  wget -q https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.31-1.fc37.x86_64.rpm && \
    rpm-ostree install mysql-workbench-community-8.0.31-1.fc37.x86_64.rpm && \
    rm mysql-workbench-community-8.0.31-1.fc37.x86_64.rpm

  rpm-ostree install --idempotent byobu fzf hugo nmap php podman-compose python-black tcpdump vim zsh && \
    ostree container commit

  # TBD: force a reboot at this point?

# Install virtualization
[linux]
install-virtualization:
  #!/usr/bin/env sh
  if ! rpm -qa | grep -q virt-manager; then
    rpm-ostree install virt-manager libvirt 1>/dev/null || true
  fi

# Install oh-my-zsh
[unix]
install-omz:
  #!/usr/bin/env sh
  if [ ! -d "{{omz}}" ]; then
    echo -n "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "done."
  fi

  # change the default shell to zsh
  usermod -s `which zsh` $USERNAME

# Symlink dotfiles
[unix]
symlink-dotfiles:
  #!/usr/bin/env sh
  echo -n "Setting up symlinks..."
  rm -f $HOME/.zshrc && ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc && \
  rm -f $HOME/.aliases && ln -s $HOME/.dotfiles/aliases $HOME/.aliases &&
  rm -f $HOME/.bash_profile && ln -s $HOME/.dotfiles/bash_profile $HOME/.bash_profile && \
  rm -f $HOME/.gitconfig && ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig && \
  rm -f $HOME/.vimrc && ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc && \
  rm -f $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting && ln -s $HOME/.dotfiles/zsh/plugins/zsh-syntax-highlighting $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting && \
  rm -f $HOME/.oh-my-zsh/plugins/zsh-autosuggestions && ln -s $HOME/.dotfiles/zsh/plugins/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
  echo "done."

# Install flatpak(s)
[linux]
install-flatpaks:
  #!/usr/bin/env bash
  declare -a arr=(
      "com.discordapp.Discord"
      "com.dropbox.Client"
      "com.getpostman.Postman"
      "com.google.Chrome"
      "com.mattjakeman.ExtensionManager"
      "com.obsproject.Studio"
      "com.slack.Slack"
      "com.valvesoftware.Steam"
      "io.github.Hexchat"
      "io.podman_desktop.PodmanDesktop"
      "md.obsidian.Obsidian"
      "org.gnome.Boxes"
      "org.gnome.Devhelp"
      "org.signal.Signal"
      "org.telegram.desktop"
      "org.wireshark.Wireshark"
      "sh.cider.Cider"
      "us.zoom.Zoom"
  )

  for i in "${arr[@]}"
  do
      echo "Installing flatpak $1"
      /usr/bin/flatpak install --user --noninteractive flathub $i
      if [ "$?" != 0 ] ; then
        echo "Error $? installing flatpak $1"
      fi
  done

# Update installed CLI tools
[linux]
update-cli-tools: install-cli-tools

# Download/install CLI tools
[linux]
install-cli-tools: install-kubectl install-kubectx install-kubens install-kind install-gnome-install-extension
  #!/usr/bin/env sh
  mkdir -p $HOME/.local/bin

# Install gnome-install-extension
[linux]
install-gnome-install-extension:
  #!/usr/bin/env sh
  echo -n "installing gnome-install-extension..."
  curl -sL $(curl -s https://api.github.com/repos/adamisrael/gnome-install-extension/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep 'gnome-install-extension-x86_64-unknown-linux-gnu.tar.gz$') -o gnome-install-extension.tar.gz
  tar xf gnome-install-extension.tar.gz && rm gnome-install-extension.tar.gz && chmod +x gnome-install-extension && mv gnome-install-extension $HOME/.local/bin/gnome-install-extension
  echo "done."

# Install kubectl
[linux]
install-kubectl:
  #!/usr/bin/env sh
  echo -n "installing kubectl..."
  curl --no-progress-meter -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mv ./kubectl $HOME/.local/bin/kubectl
  echo "done."

# Install kubectx
[linux]
install-kubectx:
  #!/usr/bin/env sh
  echo -n "installing kubectx..."
  curl -sL $(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep 'kubectx_v[0-9.]+_linux_x86_64.tar.gz$') -o kubectx.tar.gz
  tar xf kubectx.tar.gz && rm kubectx.tar.gz && chmod +x kubectx && mv kubectx $HOME/.local/bin/kubectx
  echo "done."

# Install kubens
[linux]
install-kubens:
  #!/usr/bin/env sh
  echo -n "installing kubens..."
  curl -sL $(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep 'kubens_v[0-9.]+_linux_x86_64.tar.gz$') -o kubens.tar.gz
  tar xf kubens.tar.gz && rm kubens.tar.gz && chmod +x kubens && mv kubens $HOME/.local/bin/kubens
  echo "done."

# Install kind
[linux]
install-kind:
  #!/usr/bin/env sh
  echo -n "installing kind..."
  curl -sLo ./kind "https://kind.sigs.k8s.io/dl/v0.17.0/kind-$(uname)-amd64"
  chmod +x ./kind && mv ./kind $HOME/.local/bin/kind
  echo "done."

# Update dconf
[linux]
update-dconf:
  # Enable a 4x2 workspace w/frippery bottom-panel
  dconf write /org/gnome/mutter/dynamic-workspaces false
  dconf write /org/gnome/desktop/wm/preferences/num-workspaces 8
  dconf write /org/frippery/bottom-panel/num-rows 2
  dconf write /org/frippery/bottom-panel/enable-panel true

  ## disable dash-to-dock
  dconf write /org/gnome/shell/disabled-extensions "@as ['dash-to-dock@micxgx.gmail.com']"

  ## alt-tab within the current workspace
  dconf write /org/gnome/shell/app-switcher/current-workspace-only true
