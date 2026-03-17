#!/bin/bash

#Mehrere physische Netzwerkverbindungen werden zu einer logischen zusammengefasst für mehr Bandbreite und Redundanz

#Link Aggregation
ip netns add ns1
ip netns add ns2

#2 veth-Paare erstellen
ip link add veth1 type veth peer name veth2
ip link add veth3 type veth peer name veth4

#Interfaces zuweisen
ip link set veth1 netns ns1
ip link set veth3 netns ns1
ip link set veth2 netns ns2
ip link set veth4 netns ns2

#Bonding in beiden Namespaces
ip netns exec ns1 modprobe bonding
ip netns exec ns1 ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast
ip netns exec ns1 ip link set veth1 master bond0
ip netns exec ns1 ip link set veth3 master bond0

ip netns exec ns2 modprobe bonding
ip netns exec ns2 ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast
ip netns exec ns2 ip link set veth2 master bond0
ip netns exec ns2 ip link set veth4 master bond0

#Interfaces aktivieren
ip netns exec ns1 ip link set veth1 up
ip netns exec ns1 ip link set veth3 up
ip netns exec ns1 ip link set bond0 up

ip netns exec ns2 ip link set veth2 up
ip netns exec ns2 ip link set veth4 up
ip netns exec ns2 ip link set bond0 up

#IP adressen vergeben
ip netns exec ns1 ip addr add 10.0.0.1/24 dev bond0
ip netns exec ns2 ip addr add 10.0.0.2/24 dev bond0

#test mit Ping
ip netns exec ns1 ping 10.0.0.2

#Traffic beobachten 
ip netns exec ns1 tcpdump -i bond0


#VRRP --> vermeidung von Single Point of Failure durch Backup Router
