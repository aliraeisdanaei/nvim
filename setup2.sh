#!/bin/bash

echo "Run with sudo"

sudo npm install -g yarn
cd ~/.vim/plugged/coc.nvim
yarn install
yarn build
