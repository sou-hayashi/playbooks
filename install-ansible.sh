#!/bin/bash
set -eu

readonly DISTRIBUTORS=("CentOS" "Amazon Linux" "Ubuntu")

function distributor() {
    for name in "${DISTRIBUTORS[@]}"; do
        if grep "${name}" /etc/os-release &>/dev/null; then
            echo "${name}"
        fi
    done
}

function install_ansible_on_centos() {
    sudo yum install -y epel-release
    sudo yum install -y ansible
}

function install_ansible_on_amazonlinux() {
    sudo amazon-linux-extras enable ansible2
    sudo yum clean metadata
    sudo yum install -y ansible
}

function install_ansible_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository -y --update ppa:ansible/ansible
    sudo apt-get install -y ansible
}

function install_ansible() {
    case "$(distributor)" in
    "CentOS") install_ansible_on_centos ;;
    "Amazon Linux") install_ansible_on_amazonlinux ;;
    "Ubuntu") install_ansible_on_ubuntu ;;
    esac
}

function main() {
    install_ansible
}

main "$@"
