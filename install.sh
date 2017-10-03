#!/bin/sh

#Just run it
if [[ $EUID -eq 0 ]]; then
   echo "This script must be run as non root" 1>&2
   exit 1
fi

echo "Setting up Ubuntu 16.04"
echo "Cleaning home folder"
rm -r "${HOME}/Music"
rm -r "${HOME}/Pictures"
rm -r "${HOME}/Public"
rm -r "${HOME}/Templates"
rm -r "${HOME}/Videos"
rm -r "${HOME}/examples.desktop"
rm -r "${HOME}/Desktop"
rm -r "${HOME}/Documents"
mkdir -p "${HOME}/projects"

#Update basics
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

#Iterate through all folders and subfolders and run each .dot script found in each folder
function traverse {
  echo "test $1 this"
  for dir in $1/*;do
    if [[ -d $dir ]]; then # if not directory then skip
      echo "#########################################"
      echo "#      Entering: ${dir}"
      echo "#########################################"
      traverse $dir
    elif [[ -f $dir ]]; then
      if grep -q ^\#dotinstaller$ $dir; then
        echo "#######################################"
        echo "#    Installing ${dir}"
        echo "#######################################"
        bash $dir 
      else
        echo "Nothing inside ${dir}"
      fi
    fi
  done
}

traverse "${HOME}/dotfiles"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
rm -r "${HOME}/dotfiles"
sudo reboot
