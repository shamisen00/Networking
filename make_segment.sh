#!/bin/bash

ip netns delete ns1
ip netns delete ns2

# create segments
ip netns add ns1
ip netns add router
ip netns add ns2

# create and link gateway and NICs
# Can NICs on a same network connect without a link?
ip link add ns1-veth0 type veth peer name gw-veth0
ip link add ns2-veth0 type veth peer name gw-veth1

# attach gateway and NICs to network
ip link set ns1-veth0 netns ns1
ip link set gw-veth0 netns router
ip link set gw-veth1 netns router
ip link set ns2-veth0 netns ns2

# up NICs
ip netns exec ns1 ip link set ns1-veth0 up
ip netns exec router ip link set gw-veth0 up
ip netns exec router ip link set gw-veth1 up
ip netns exec ns2 ip link set ns2-veth0 up

# assign IP NICs
# is it possible that a NIC belong the same segment(IP) but different networks?
ip netns exec ns1 ip address add 192.0.2.1/24 dev ns1-veth0
ip netns exec router ip address add 192.0.2.254/24 dev gw-veth0
ip netns exec router ip address add 198.51.100.254/24 dev gw-veth1
ip netns exec ns2 ip address add 198.51.100.1/24 dev ns2-veth0
# route network belong to 2 segments.
# local network = segment, global network = internet. packet can move freely on segment.
# so routing entry is automaticaly added to route table.

ip netns exec ns1 ping -c 3 192.0.2.254 -I 192.0.2.1
ip netns exec ns1 ping -c 3 198.51.100.1 -I 192.0.2.1

# check route table
# route table is belong to network not to router(gateway).
# may router means a auxiliary network between primal network.
ip netns exec ns1 ip route show

# adding default routing entry which is made of destination and nexthop
ip netns exec ns1 ip route add default via 192.0.2.254
ip netns exec ns2 ip route add default via 198.51.100.254

ip netns exec ns1 ping -c 3 198.51.100.1 -I 192.0.2.1

