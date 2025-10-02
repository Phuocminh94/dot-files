#!/usr/bin/env zsh

ssh-keygen -t rsa -b 4096 -C "buiphuocminh94@gmail.com"

cd ~/.ssh

cat id_rsa.pub

echo "Please copy the SSH key above and go to your GitHub settings to add it for authentication."
