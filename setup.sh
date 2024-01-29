#!/bin/bash

##################################################
## Inspired by ChrisTitusTech scripts.
##################################################
INSTALL_DEPENDENCIES='sudo coreutils curl git wget tar autojump bash bash-completion neovim neofetch net-tools unzip'
SUGROUP='sudo'
PACKAGER='apt'

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

checkInstallReq() {
    ## Check if the current directory is writable.
    GITPATH="$(dirname "$(realpath "$0")")"
    if [[ ! -w ${GITPATH} ]]; then
        echo -e "${RED}Can't write to ${GITPATH}${RC}"
        exit 1
    fi
    ## Check for required packages.
    REQUIREMENTS='curl groups sudo'
    if ! which ${REQUIREMENTS} >/dev/null; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi
    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!"
        exit 1
    fi

    if [[ ! -x "/usr/bin/apt-get" ]]; then
        echo -e "Can't find a supported package manager"
        exit 1
    fi
}

installDependencies() {
    ## Check for dependencies.
    echo -e "${YELLOW}Installing dependencies...${RC}"
    sudo ${PACKAGER} install -yq ${INSTALL_DEPENDENCIES}
}

installStarship(){
    STARSHIP_CMD=$(which starship)
    if [[ ! -z $STARSHIP_CMD ]]; then
        echo "Starship already installed"
        return
    fi

    if ! curl -sS https://starship.rs/install.sh|sh;then
        echo -e "${RED}Something went wrong during starship install!${RC}"
        exit 1
    fi
}

linkConfig() {
    ## Check if a bashrc file is already there.
    OLD_BASHRC="${HOME}/.bashrc"
    if [[ -e ${OLD_BASHRC} ]]; then
        echo -e "${YELLOW}Moving old bash config file to ${HOME}/.bashrc.bak${RC}"
        if ! mv ${OLD_BASHRC} ${HOME}/.bashrc.bak; then
            echo -e "${RED}Can't move the old bash config file!${RC}"
            exit 1
        fi
    fi

    echo -e "${YELLOW}Linking new bash config file...${RC}"
    ## Make symbolic link.
    ln -svf ${GITPATH}/.bashrc ${HOME}/.bashrc
    ln -svf ${GITPATH}/starship.toml ${HOME}/.config/starship.toml
    ln -svf ${GITPATH}/init.vim ${HOME}/.config/nvim/init.vim
}

updateSystem() {
  sudo apt update
}

updgradeSystem() {
  sudo apt upgrade -y
}

pausescript() {
  read -n 1 -s -r -p "Press any key to continue"
}

updateSystem
upgradeSystem
checkInstallReq
installDependencies
installStarship
/bin/bash gh.sh
mkdir -p ~/.config/nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if linkConfig; then
    echo -e "${GREEN}Done!\nrestart your shell to see the changes.${RC}"
else
    echo -e "${RED}Something went wrong!${RC}"
fi
