#!/bin/bash -x

apt update
apt install -y curl

for user in $(ls /home)
do
  curl --create-dirs --output /home/${user}/.ssh/authorized_keys "https://github.com/${user}.keys"
  chown -R $(id -u ${user}).users /home/${user}/.ssh
  chmod 0600 /home/${user}/.ssh/authorized_keys
done
