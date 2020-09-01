#!/bin/bash
#/home/fabio/

install_zsh() {
  read -p "Install zsh? [Y/n]" zsh
  zsh=${zsh:-y}

  if [[ $zsh != "y" ]]; then
     return
  fi

  sudo apt install -y zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  read -p "Install powerline? [Y/n]" powerline
  powerline=${powerline:-y}

  if [[ $powerline != "y" ]]; then
     return
  fi

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/themes/powerlevel10k
}

clone_dotfiles () {
  git clone --bare https://github.com/fabioluna/dotfiles.git $HOME/.cfg
  function config {
     /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
  }
  mkdir -p .config-backup
  config checkout
  if [ $? = 0 ]; then
    echo "Checked out config.";
    else
      echo "Backing up pre-existing dot files.";
      config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  fi;
  config checkout -f master
  config config status.showUntrackedFiles no
}

install_docker() {
  # Install Docker
  read -p "Install docker? [Y/n]" docker
  docker=${docker:-y}

  if [[ $docker != "y" ]]; then
     return
  fi

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get -qqy update
  DEBIAN_FRONTEND=noninteractive sudo -E apt-get -qqy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade 
  sudo apt-get -yy install apt-transport-https ca-certificates curl software-properties-common wget pwgen
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update && sudo apt-get -y install docker-ce

  # Install Docker Compose
  sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # Allow current user to run Docker commands
  sudo usermod -aG docker $USER
}

install_xfce() {
  read -p "Install xfce? [Y/n]" xfce
  xfce=${xfce:-y}

  if [[ $xfce != "y" ]]; then
     return
  fi
  sudo apt -yy install xfce4
}

setup_android() {
  read -p "Install android? [Y/n]" android
  android=${android:-y}

  if [[ $android != "y" ]]; then
     return
  fi

  sudo /home/fabio/./android.sh
}

install_vim_gtk () {
  read -p "Install vim? [Y/n]" vim
  vim=${vim:-y}

  if [[ $vim != "y" ]]; then
     return
  fi
  
  sudo add-apt-repository ppa:jonathonf/vim -y
  sudo apt update -y
  sudo apt install -y vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_asdf () {
  read -p "Install asdf? [Y/n]" asdf
  asdf=${asdf:-y}

  if [[ $asdf != "y" ]]; then
     return
  fi

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1
  asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
  asdf global rust 1.42.0
  asdf plugin-add python
  asdf global python 3.6.2 2.7.13
}

install_zsh
clone_dotfiles
install_docker
install_xfce
setup_android
install_vim_gtk
install_asdf

chsh -s $(which zsh)
