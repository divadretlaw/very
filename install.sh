#!/bin/bash
mkdir -p $HOME/.config/very/
cp very.json $HOME/.config/very/very.json

# fish
mkdir -p $HOME/.config/fish/completions/
mkdir -p $HOME/.config/fish/functions/
cp fish/completions/very.fish $HOME/.config/fish/completions/very.fish
cp fish/functions/very.fish $HOME/.config/fish/functions/very.fish

curl -Lko $HOME/.very.py http://davidwalter.at/d/very.py