#!/bin/bash

# create networks
ip netns add ns1
ip netns add ns2

# create and link NICs
ip link add ns1-veth0 type veth peer name ns2-veth0

# check devices(NICs)
ip link show | grep veth

# attach NIC to network
ip link set ns1-veth0 netns ns1
ip link set ns2-veth0 netns ns2

# check devices(NICs)
ip link show | grep veth

# check NIC attached to a virtual network
ip netns exec ns1 ip link show | grep veth
ip netns exec ns2 ip link show | grep veth

ip netns exec ns1 ip link show ns1-veth0 | grep state

# verify NIC (NIC is set DWON by default)
ip netns exec ns1 ip link set ns1-veth0 up
ip netns exec ns2 ip link set ns2-veth0 up

# assign identical IP NICs
ip netns exec ns1 ip address add 192.0.2.1/24 dev ns1-veth0
ip netns exec ns2 ip address add 192.0.2.2/24 dev ns2-veth0

# now you can communicate with these networks
