#!/bin/bash

# Namespaces and interfaces
sudo ip netns add router
sudo ip netns add webserver
sudo ip link add veth-int-1 netns router type veth peer name veth-int-2 netns webserver
sudo ip link add veth-ext-1 netns router type veth peer name veth-ext-2
sudo ip -netns router link set dev veth-int-1 upsudo ip -netns router link set dev veth-ext-1 up
sudo ip -netns webserver link set dev veth-int-2 up
sudo ip link set dev veth-ext-2 up

# IP address configuration
sudo ip -netns router addr add 10.20.30.1/24 dev veth-int-1
sudo ip -netns router addr add 192.168.0.2/24 dev veth-ext-1
sudo ip -netns webserver addr add 10.20.30.42/24 dev veth-int-2
sudo ip addr add 192.168.0.1/24 dev veth-ext-2

#test with ping
