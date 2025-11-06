#!/bin/sh

killall ssh-agent

eval "$(ssh-agent -s)"

ssh-add -L ~/.ssh/id_rsa
