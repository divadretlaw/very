#!/bin/bash
mkdir -p $HOME/.config/very/
cp ../very.json $HOME/.config/very/very.json

if [ $(which fish) != "" ]; then
# fish
mkdir -p $HOME/.config/fish/completions/
mkdir -p $HOME/.config/fish/functions/
cp ../fish/completions/very.fish $HOME/.config/fish/completions/very.fish
cp ../fish/functions/very.fish $HOME/.config/fish/functions/very.fish
else
#bash
echo 'alias very="python $HOME/.very.py"' >> $HOME/.bashrc
fi

python3 install.py