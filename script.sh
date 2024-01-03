#!/bin/bash
curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo apt-get install docker-compose-plugin
usermod -aG docker ubuntu