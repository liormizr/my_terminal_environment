#!/bin/bash

dpath=$PWD
echo $dpath

cd $HOME
rm .vimrc
ln -s ${dpath}/.vimrc .
mkdir -p ~/.vim/colors && cd ~/.vim/colors
wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim
ln -s ${dpath}/plugin .

cd bundle
# install plugins
# Ctrlp
git clone https://github.com/kien/ctrlp.vim.git
# Vundle
git clone https://github.com/gmarik/Vundle.vim.git
# NerdTree
git clone https://github.com/scrooloose/nerdtree.git
# Command-T
git clone https://github.com/wincent/Command-T
cd Command-T/ruby/command-t/
ruby extconf.rb
make
cd -
# YouCompleteMe
git clone https://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
./install.sh --clang-completer

cd ~/.vim
ln -s ${dpath}/.ycm_extra_conf.py .
# pss.vim
sudo pip install pss
sudo git clone https://github.com/bernh/pss.vim.git
