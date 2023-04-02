# Prerequisite

As stated in the kolla-ansible documentation, you will need at least 8GB of memory and 40GB of disk space. It's best to have two NICs, but if you are in the same situation as me and have only one, don't worry, we will use a workaround from [William Perdue](https://www.keepcalmandrouteon.com/post/kolla-os-part-1/)


# Bootstrap nodes

Our installation is based on the Openstack zed version installed on multiple computers running Ubuntu Server 22.04. So first of all, you will need to install Ubuntu Server on every computer you wish to use.

If you only have one disk available per node, and you want to enable cinder (block storage) or swift (object storage) later on, you will need to create disk partitions when installing Ubuntu Server. To do so, you can start the installer and directly go to the shell (accessible from the top right menu). Run `lsblk` to see the list of internal drives, and format the one you want with `mkfs -t ext4 /dev/sdX`. Create your partitions with `cfdisk /dev/sdX`.

In my configuration I created 7 partitions for my control node’s SSD:
* 1 of 2GB in EFI System for the /boot/efi
* 1 of 2GB in Linux filesystem for the /boot
* 1 of 150GB in Linux filesystem for the OS LVM
* 1 of 750GB in Linux filesystem for Cinder
* 3 of 8GB in Linux filesystem for Swift

Once your partitions are ready, you can reboot and start the installer again. For the disk setup step, choose the manual configuration and mount each partition/lvm where it should be. For the LVM, since I will only be creating one, I named my volume group "ubuntu-vg" and my logical volume "ubuntu-lv" which are the names used by default when using automatic disk setup.

Most routers will have a netmask of 255.255.255.0 (aka a CIDR ending with "/24") but the DHCP will be configured to only assign IPs from a given range of your CIDR. For example, the CIRD I have is 192.168.30.0/24 but my DHCP only assigned IPs from 192.168.30.10 to 192.168.30.30. Regarding the network configuration, I advise you to manually setup each of your nodes’ IP outside of your DHCP range.

For a matter of simplicity, I setup the `ubuntu` user with the same password on every node.


# Bootstrap host

First of all, install the needed tools:

```bash
sudo apt install python3-dev libffi-dev gcc libssl-dev

# Docker
curl -fsSL https://get.docker.com | sudo sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Python
curl -sSL https://install.python-poetry.org | python3 -
export PATH="$HOME/.local/bin:$PATH"  # Or add this line to your .bashrc for it to be permanent.
cd openstack/kolla
poetry install
```

From now on, you can either prefix every command by `poetry run` or enter poetry shell mode with `poetry shell`. Furthermore, all the following commands must be run from _openstack/kolla_

Install ansible deps:
```
ansible-galaxy install -r requirements.yml
```

Now that everything is ready on our computer, we can start bootstrapping the hosts via ansible. First , we will need to edit the _hosts_ file to match our configuration. For that, only lines 1 to 24 are relevant, the rest is managed by kolla-ansible. Don't mind the "ansible_user", "network_interface", and "neutron_external_interface" for now.

In my case, I decided to set up my cluster with one control node, and two worker nodes.

```ini
[cluster]
os01     ansible_ssh_host=192.168.30.41 ansible_user=deploy-user network_interface=br0 neutron_external_interface=veth2
os02     ansible_ssh_host=192.168.30.42 ansible_user=deploy-user network_interface=br0 neutron_external_interface=veth2
os03     ansible_ssh_host=192.168.30.43 ansible_user=deploy-user network_interface=br0 neutron_external_interface=veth2

[laptops]

[control]
os01

[network]
os[02:03]

[compute]
os[02:03]

[monitoring]
os01

[storage]
os01

[deployment]
localhost       ansible_connection=local
```

Make sure you can ping every host:
```bash
ansible -i hosts all -m ping --extra-vars "ansible_user=ubuntu"
```

Update the hosts:
```bash
ansible-playbook -i hosts ansible/00-update.yml --ask-become-pass --extra-vars "ansible_user=ubuntu"
```

If some of your hosts are laptops, they might go to sleep if you close the lid. In order to avoid this, add them to the 'laptop' section of the _hosts_ file and run the following playbook:
```bash
ansible-playbook -i hosts ansible/02-laptop.yml --ask-become-pass --extra-vars "ansible_user=ubuntu"
```

We will now create a user with passwordless sudo rights that will be used by kolla-ansible
```bash
ansible-playbook -i hosts ansible/10-deploy-user.yml --ask-become-pass --extra-vars "ansible_user=ubuntu"
```

Make sure you have access via ansible to the new user
```bash
ansible -i hosts all -m ping
```

Now we will dive a little more into the complexity of Openstack. In a typical server, you will always have at least two physical network interfaces (aka: two ethernet ports). However, chances are that you have only one network interface on the computer you want to deploy Openstack on. Kolla-ansible states in its requirements that it needs at least two NIC. However, I was not inclined to spend more money than I already had (on a switch and a SSD) in order to buy three NIC.
To bypass this limitation, we will create some [veth](https://man7.org/linux/man-pages/man4/veth.4.html) (Virtual Ethernet Device). This allows us to virtually have two (or more) network interfaces from only one physical port. Keep in mind that this implies some network speed limitations.

Open the [ansible/20-veth.yml](ansible/20-veth.yml) file and update the variables for them to match your configuration.

* network_interface: The name of the network interface of your host (you can check it with `ip a`)
* gateway_ipv4: The IPv4 gateway IP. This will be the IP of your router
* enable_octavia: If you wish to enable Openstack’s Octavia (load balancer) module later on, set this to true.
* mtu: On standart network, this is set to 1500. Again use `ip a` to check the value of the network on your host if you're unsure.


```bash
ansible-playbook -i hosts ansible/20-veth.yml
```

If you want to understand what this playbook does (once run), you can check the _/etc/netplan/00-openstack-config.yaml_ file on one of your hosts.


# Pre-installation

Now we can finally start the Openstack installation. Kolla-ansible relies on a main configuration file: the _globals.yml_.

For that, you will have to read the documentation and edit it depending on what you want. However, since we had to bend a few rules to bypass the 2 NIC limitation, there are some mandatory steps concerning the configuration in our case:

```yaml
network_interface: "br0"
neutron_external_interface: "veth2,veth4"
neutron_bridge_name: "br-ext2,br-ext4"
```

The network interface will be our network bridge. veth2 will be used by Neutron and veth4 by Octavia. If you did not enable Octavia in the veth playbook, you can remove veth4 and br-ext4 from the configuration.


## Password (mandatory)

Generate password files
```bash
wget https://opendev.org/openstack/kolla-ansible/raw/branch/stable/zed/etc/kolla/passwords.yml
kolla-genpwd --passwords passwords.yml
```


## [Octavia - Load balancer](https://docs.openstack.org/kolla-ansible/zed/reference/networking/octavia.html)

Octavia needs its own network, this is why we previously created veth4. When configuring Neutron, we specified "veth2,veth4" as the external interface, in this precise order. By doing so, veth2 will therefore be the physical network named "physnet1" and veth4 will be "physnet2". This is why in the [globals.yml](./globals.yml) there is `provider_physical_network: "physnet2"`

Octavia will use its own self-signed certificates. You will need to generate them.

```bash
kolla-ansible --configdir "$(pwd)" octavia-certificates
```


## [Cinder - Block storage](https://docs.openstack.org/kolla-ansible/zed/reference/storage/cinder-guide.html)

ssh into your storage nodes (in my case os01), and run the following command on the desired disk partition:
```bash
# Run lsblk if you want to see the partitions list
sudo pvcreate /dev/sdX
sudo vgcreate cinder-volumes /dev/sdX
```

If I take the example of my control node:
```
sudo pvcreate /dev/sda4
sudo vgcreate cinder-volumes /dev/sda4
```


## [Swift - Object storage](https://docs.openstack.org/kolla-ansible/zed/reference/storage/swift-guide.html)

You need at least three disks or partitions, for redundancy purposes, to enable Swift. However, I want Swift to run only on the control node since it is the only one I have running on ssd. This is why in the bootstrap node, we created three partitions of 8GB for Swift. Yes, having three partitions for redundancy on the same disk is almost totally useless. But in my case, having redundancy on Swift isn’t an issue, and so this is why I choose to go about it this way.

On my storage node (os01), I ran this script to setup the partition:

```bash
#!/bin/bash

index=0
for p in {5..7}; do
	sudo parted -s /dev/sda name $p KOLLA_SWIFT_DATA
	sudo mkfs.xfs -f -L part${index} /dev/sda${p}
	(( index++ ))
done
```

Once this is done, update the IP in the [`./scripts/setup_ring.sh`](./scripts/setup_ring.sh) script and run it. This will generate the rings in config/swift.

Note: I couldn't upload file from the GUI due to a bug in Horizon. You can however upload a file from the CLI with `openstack object create <my_container> <my_object>`


## [About the MTU configuration](https://docs.openstack.org/mitaka/networking-guide/config-mtu.html)

As a default, Neutron uses OpenVSwitch as its backend. For a reason still unclear to me, if Neutron is using a physical network with an MTU of 1500, the VM has a network of 1450. OpenVSwitch "reserves" 50 bytes for itself.


The problem with such a thing arises when using docker. As a default, docker assumes that it is on a network with an MTU set to 1500 and sends packets as such. Therefore, running a simple pip install inside a docker container will mostly fail.


In order to bypass this limitation, you have two options. Either configure the docker daemon on every VM running in your Openstack, or install Openstack using a network with MTU set at 1550. For the first option you can follow [Matthias Lohr](https://mlohr.com/docker-mtu/)’s blog post. The second option is more tricky to implement at home, since, to my knowledge, there is not a single consumer router that offers the possibility to configure the MTU. I did manage to have a network with an MTU set to 1550 but that required putting my router in bridge mode, setting up a pfSense on an old laptop, and purchasing a switch with VLAN capability. I won't explain how to set up such a thing here since it falls outside of the scope of the Openstack installation. The first option works great and is the one that I used for quite some time so don't worry about it. If you go with the first option, you will have to edit the following files :_globals.yml_, _config/neutron.conf_, _config/neutron/ml2_conf.ini_ by replacing 1550 by 1500, and 1500 by 1450.


## [TLS](https://docs.openstack.org/kolla-ansible/zed/admin/tls.html)

We are going to need to set up TLS in order to secure communication.

“Frontend” TLS or “Internet-facing” TLS only secures communications between your computer and the load balancer (HAProxy), while “backend” TLS adds security to the communications between the load balancer and the underlying Openstack services.

Since my domain name is managed by AWS, I will generate the certificate via DNS challenge.

If it's not already done, install the AWS CLI:
```bash
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf ./awscliv2.zip ./aws
```

Edit and run [`./scripts/generate_certificates.sh`](./scripts/generate_certificates.sh) to issue the certificates.

Note: This script needs sudo rights.


# Installation

Once everything is configured, the installation is pretty straight forward. You just have to pray for everything to work, because trust me, when kolla-ansible fails, it is really annoying to debug.

For the precheck step, do not worry if you see an error for localhost since we are not going to install Openstack on the computer used to deploy it.

If you have a connection problem to your "kolla_internal_fqdn" during the deployment, you can manually add the DNS record to the _/etc/hosts_ file on every node. In my case, I will have to add the following line `192.168.30.50 int.openstack.alexisboissiere.fr`.

```bash
kolla-ansible install-deps
kolla-ansible --configdir "$(pwd)" --passwords "$(pwd)/passwords.yml" bootstrap-servers
kolla-ansible --configdir "$(pwd)" --passwords "$(pwd)/passwords.yml" prechecks
kolla-ansible --configdir "$(pwd)" --passwords "$(pwd)/passwords.yml" deploy
EXTRA_OPTS="--ask-become-pass" kolla-ansible --configdir "$(pwd)" --passwords "$(pwd)/passwords.yml" post-deploy
```

# Post-install

## Login

You can find all the passwords in the `passwords.yml` file. The default user name is "admin" and its password is stored in the "keystone_admin_password" variable.


## Octavia

Once Openstack is deployed, you will need to add the amphora image. To do so, [follow the steps in the documentation](https://docs.openstack.org/kolla-ansible/zed/reference/networking/octavia.html#amphora-image) or run [`./scripts/octavia_image.sh`](./scripts/octavia_image.sh).

Note: This script does not work if you are in poetry shell.


## Exposing Openstack to the world

In order to expose your Openstack to the World Wide Web, you will need to have an router capable of port-forwarding to a virtual IP (the one you declared with "_kolla_internal_vip_address_").


You can get the ports you will have to forward by listing the public endpoint
```bash
openstack endpoint list --interface public
```


## Init run once

At the end of the installation instructions, kolla-ansible offers us to use a [script](https://opendev.org/openstack/kolla-ansible/src/branch/stable/zed/tools/init-runonce) to upload an image, create a network, add some security groups, and set quotas for the admin project. However, it is clearly stated that it is not idempotent and is more intended for demo purpose.

You can find the "translated" version of this script for Terraform [here](../init/)