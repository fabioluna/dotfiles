#!/bin/bash
#/home/fabio/

BASH_PATH=/home/fabio
SETUP_BASE_PATH=/home/fabio/setup

install_zsh() {
    sudo apt install -y zsh
    sudo chsh -s $(which zsh)
}

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
config checkout
config config status.showUntrackedFiles no

# Create new directory to setup dependencies
create_directories() {
    if [[ ! -e $SETUP_BASE_PATH ]]; then
	sudo mkdir -p $SETUP_BASE_PATH
    	sudo chown $USER:#USER $SETUP_BASE_PATH
    fi
}

install_docker() {
    # Install Docker
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
    sudo apt -yy install xfce4
}

setup_android() {
    sudo /home/fabio/./android.sh
}

install_vim_gtk () {
    sudo apt install -y vim-gtk
    git clone https://github.com/VundleVim/Vundle.vim.git $BASE_PATH/.vim/bundle/Vundle.vim
}

install_nginx() {
    sudo apt install -y nginx
}

create_directories
install_docker
install_xfce
setup_android
install_vim_gtk
install_nginx

