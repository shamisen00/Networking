#!/bin/bash

ip address show

#tcpdump -tn -i any icmp

ping -c 3 8.8.8.8

traceroute -n -I 8.8.8.8

ip route show

ip netns add helloworld

ip netns list

ip netns exec helloworld ip address show