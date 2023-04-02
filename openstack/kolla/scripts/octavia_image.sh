#!/bin/bash

set -e

cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ..

sudo apt -y install debootstrap qemu-utils git kpartx python3.10-venv

git clone https://opendev.org/openstack/octavia -b stable/zed
cd octavia/diskimage-create
python3 -m venv dib-venv
source dib-venv/bin/activate
pip install diskimage-builder
./diskimage-create.sh
deactivate

cd -
source octavia-openrc.sh

# If you did not enabled TLS, you can add "--insecure"
poetry run openstack image create amphora-x64-haproxy.qcow2 \
    --container-format bare \
    --disk-format qcow2 \
    --private \
    --tag amphora \
    --file octavia/diskimage-create/amphora-x64-haproxy.qcow2 \
    --property hw_architecture='x86_64' \
    --property hw_rng_model=virtio

rm -rf ./octavia