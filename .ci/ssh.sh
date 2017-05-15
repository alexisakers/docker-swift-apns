#!/bin/bash
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
echo -e "ssh-rsa $SSH_KEY $SSH_EMAIL" > ~/.ssh/id_rsa.pub
echo -e "$RSA_PRIVKEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
