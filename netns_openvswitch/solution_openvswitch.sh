#!/bin/bash

#Install OVS, start the service, and create an OVS bridge „br0“
sudo apt install openvswitch-switch openvswitch-common
sudo systemctl start ovs-vswitchd.service
sudo ovs-vsctl add-br br0

#Create namespaces for hosts
sudo ip netns add host1
sudo ip netns add host2

#Setup untagged ports in VLAN 1+2 (internal = managed by OVS)
sudo ovs-vsctl add-port br0 br0.1 tag=1 -- set interface br0.1 type=internal
sudo ovs-vsctl add-port br0 br0.2 tag=2 -- set interface br0.2 type=internal

#Move interfaces into namespace
sudo ip link set dev br0.1 netns host1
sudo ip link set dev br0.2 netns host2

#Configure interface for host1 and host2
sudo ip -netns host1 addr add 10.42.2.2/24 dev br0.2
sudo ip -netns host2 addr add 10.42.2.2/24 dev br0.2

#Activate interfaces
sudo ip link set dev ovs-system up
sudo ip link set dev br0 up
sudo ip -netns host1 link set dev br0.1 up
sudo ip -netns host2 link set dev br0.2 up

#Add namespace „router“, activate IP-forwarding
sudo ip netns add router
sudo ip netns exec router sysctl -w net.ipv4.ip_forward=1

#Add more untagged ports to connect the router
sudo ovs-vsctl add-port br0 router.1 tag=1 -- set interface router.1 type=internal
sudo ovs-vsctl add-port br0 router.2 tag=2 -- set interface router.2 type=internal

#Move interfaces to namespace
sudo ip link set dev router.1 netns router
sudo ip link set dev router.2 netns router

#Activate interfaces
sudo ip -netns router link set dev router.1 up
sudo ip -netns router link set dev router.2 up

#IP configuration: „router“
sudo ip -netns router addr add 10.42.1.1/24 dev router.1
sudo ip -netns router addr add 10.42.2.1/24 dev router.2

#Set a route from host1 to host2 via the router
sudo ip -netns host1 route add 10.42.2.0/24 via 10.42.1.1

#Set a route from host2 to host1 via the router
sudo ip -netns host2 route add 10.42.1.0/24 via 10.42.2.1

#Test with ping
sudo ip -netns host1 ping 10.42.2.2
