#!/bin/bash
#rocks add network fast subnet=10.2.0.0 netmask=255.255.0.0
IP=10 #Ip address to start at
NNODES=14 #Number of nodes in the cabinate
NODE=0
CABINATE=0 #Cabinate to configure
IFACE=em2
while [ $NODE -lt $NNODES ]; do \
	rocks set host interface ip compute-$CABINATE-$NODE iface=$IFACE ip=10.2.3.$IP; \
	rocks set host interface subnet compute-$CABINATE-$NODE iface=$IFACE subnet=fast; \
	rocks set host interface name compute-$CABINATE-$NODE iface=$IFACE name=compute-fast-$CABINATE-$NODE; \
	let IP++; \
	let NODE++; \
done
rocks sync config
rocks sync host network compute
