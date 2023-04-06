#!/bin/bash

#echo "apt updating..."
#echo $user_passwd | sudo -S  apt update -y
#
#echo "apt upgrading..."
#echo $user_passwd | sudo -S  apt upgrade -y
#
#echo "installing newest vim..."
#echo $user_passwd | sudo -S apt install vim  -y
#
#echo "deleting tmp files..."
#echo $user_passwd | sudo -S apt autoremove -y

echo "copying config files..."
cp gitconfig            ~/.gitconfig
cp git-completion.bash  ~/.git-completion.bash
cp bash_aliases         ~/.bash_aliases
cp vimrc                ~/.vimrc
