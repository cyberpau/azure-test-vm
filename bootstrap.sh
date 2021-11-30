#!/bin/bash
# Authored by John Paulo Mataac

if [[ $EUID -gt 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

## Install DNF
sudo yum install epel-release -y
sudo yum install dnf -y

## Install Azure CLI
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo dnf install azure-cli

## Install Java 8

sudo yum install java-1.8.0-openjdk -y


