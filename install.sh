#!/bin/bash

export YAK_BUILD_DOCKER_V=0.1.0

echo "Installing docker-ce on Ubuntu... v$YAK_BUILD_DOCKER_V"

if [ "$(whoami)" != "root" ]; then
	echo "This script must run as root."
  echo "Try: sudo su"
  exit 126
fi

echo "Removing old installations..."
apt-get remove docker docker-engine docker.io

echo "Updating repository package info..."
apt-get update

echo "Installing linux-image-extra packages..."
apt-get install \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual

echo "Installing prerequisites..."
apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

echo "Setting up key and fingerprint..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

echo "Adding docker repository..."
if [ "$(arch)" = "x86_64" ]; then
  export ARCH=amd64
else
  echo "ERROR: You have a non-standard architecture (not x86_64)."
  echo "You can modify this script to address your needs."
  exit 1
fi
add-apt-repository \
  "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo "Installing docker-ce"
apt-get update
apt-get install docker-ce
