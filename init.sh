#!/bin/sh

sudo apt-get update
sudo apt-get install lua5.2 luarocks
sudo luarocks install serpent
sudo luarocks install faketorio
sudo luarocks install luaunit