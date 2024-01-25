#!/bin/bash

##################################################
## Inspired by ChrisTitusTech scripts.
##################################################
INSTALL_DEPENDENCIES='sudo coreutils curl git wget tar autojump bash bash-completion neovim neofetch net-tools flatpak unzip'
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

certificate_conti() {
	sudo bash -c "cat >  /usr/local/share/ca-certificates/conti.crt" <<EOF
-----BEGIN CERTIFICATE-----
MIIG5jCCBM6gAwIBAgIBADANBgkqhkiG9w0BAQUFADB7MQswCQYDVQQGEwJERTEV
MBMGA1UECBMMTG93ZXIgU2F4b255MRAwDgYDVQQHEwdIYW5vdmVyMRcwFQYDVQQK
Ew5Db250aW5lbnRhbCBBRzEqMCgGA1UECxMhQ29udGluZW50YWwgQ29ycG9yYXRl
IElUIFNlY3VyaXR5MB4XDTA3MDkxMzA4NTYxMFoXDTM3MDkwNTA4NTYxMFowezEL
MAkGA1UEBhMCREUxFTATBgNVBAgTDExvd2VyIFNheG9ueTEQMA4GA1UEBxMHSGFu
b3ZlcjEXMBUGA1UEChMOQ29udGluZW50YWwgQUcxKjAoBgNVBAsTIUNvbnRpbmVu
dGFsIENvcnBvcmF0ZSBJVCBTZWN1cml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
ADCCAgoCggIBAK7nh/OgtCrrqOTKGV+SYW0XwzSBzHIS1rJ6vCJ/wocXLIi4SxN8
CnoC4gF2F0NnlL8Of2UZQMcE2MWXkkq5W6J9Z2oIGSBrw6TssrcCu5SiMDfn/FhP
RjzWeCq/iNVS1Rs/AbWFeF2MuTy83awWhxHvU3lVGCo/lrOa7PmeZ1SJEC32JriM
l/EmiOQnW2fL7OCdHqeaskGm+6CH/GRFz8sUJqzwdkeTHD/nm+IAYnr2NuUIXdbL
84T0zO3Mi8YtcwxjqWLtClTUTkB8SxqZqT+djYJe9AGJXLIQBAluzcpjibC7uVeZ
LWndSNOMRCC2P4ub6UarNC28N4NLONrgBs8IKED5+bDgaDnFafrNcH2lEJHxTeeu
d5HWCPgpbLPBcNVqXGgEEalMa01QTIhbYbKMZk6ncyN4msSlJhGgzfqAFJ50Z2mt
lujLQaV1HJBV43CSfRYgY55j4TRc47EzmCEz/dQ3zPOSSTYZgf4uphNlTIDZWlzr
WFvlJqyx1uLmuAjP+zE9as/wW8C0R+bRih7hWJIut1JdfrYk0o7q+0yXoTvzv40d
j4bN2lNB6vLZgP+Oo3j3RwuFY2AY9Msjwa6SMv+oQ63pquHm4bl97dKW9iKkLR0g
Y85KDJxpmqG3b3RaYs/369BeukyME1WIttH7FQSl0i7lO7bmFiJM/yRzAgMBAAGj
ggFzMIIBbzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4E
FgQUKYzkfUozwZ6JaPMdOvjPs3+GfrEwgaUGA1UdIwSBnTCBmoAUKYzkfUozwZ6J
aPMdOvjPs3+GfrGhf6R9MHsxCzAJBgNVBAYTAkRFMRUwEwYDVQQIEwxMb3dlciBT
YXhvbnkxEDAOBgNVBAcTB0hhbm92ZXIxFzAVBgNVBAoTDkNvbnRpbmVudGFsIEFH
MSowKAYDVQQLEyFDb250aW5lbnRhbCBDb3Jwb3JhdGUgSVQgU2VjdXJpdHmCAQAw
EQYJYIZIAYb4QgEBBAQDAgAHMDgGCWCGSAGG+EIBDQQrFilDb250aW5lbnRhbCBB
RyBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eTA4BggrBgEFBQcBAQQsMCowKAYI
KwYBBQUHMAKGHGh0dHA6Ly93d3cuY29udGktb25saW5lLmNvbS8wDQYJKoZIhvcN
AQEFBQADggIBAIBpMzT2ATipj60nWaKrLaoDVOCBmnoJmRB9x9paP3+TamF+UJnT
z/y18gzkUPXeLhhSLCgu9j817nz61F1pUQDRJ8VWGtBIt/tV/xdAWP0mQ3vPD6Po
6ocYP+2DZHlAHnyMH9UX9aYMXhWZPuxBFpWJVyG+eaqHd8RCJJeMYtnlo+DhCpIR
TOQ4FEA+BdrMP7IO9OWt1HnZe38VYikhu/riQ6lTRVN6cyRwsdQh/t64V6uYi6If
l4FNpEOZzAbWkn1RvW1oIwmiuRX1PemUsR858Ys+O5wxlvCQBtKCAgqyHCCPO7aY
1+LlQ9wAu3FeEMU9i8YvzstV+76HITrxQDn8lE/D5ccx0gPIzfEZRHSVuwX2JCdV
MukUpOsoF/B4Q8daGl+55yEJse6n7qXOsoyd5cc1UUGItqdemDSM73s0DYIUbJmL
X48ygRMS6ZSM5lFdneuK6EWJcensanfLJF1i4fwbwvWpWNNpJeXK4Gun1HUkHPEu
tdhHyfso284mJEl8afLTyVRUsj6rb1jaOrTACvDIBYOsqLDJSok6vl1fvlRQ8Klf
mgiw/c8fh0ysah5NcC2iOCjmK/ycYMhwB5UEX0i26mvwJjDwSGsOCmQvD18Qvvj5
29/79eTJ65C9yO77SgpapwezUNKhdCk3vL049aG94YLW07apBxQ9RpKA
-----END CERTIFICATE-----
EOF

sudo update-ca-certificates

}

updateSystem
upgradeSystem
checkInstallReq
installDependencies
certificate_conti
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
