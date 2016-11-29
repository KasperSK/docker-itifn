# Workshop 4

## Dynamic Routing Part I

(c) 2011-2012 Rune Hylsberg Jacobsen, Aarhus University School of Engineering.
Version 0.4, date 2012-10-09.

## IP Routing

This workshop consists of two parts. The first part shows how routing can be setup statically in an IP network, while the second part uses the RIP protocol to perform dynamic routing. We will only be using IPv4 in this workshop as the IPv4 addresses are shorter and hence easier to deal with. The basic concepts are the same for IPv6 networks.

## Lab Overview

### Topology

![LAB03_6IN4](/workshops/workshop 04/images/LAB04.png)

### Networks

| Name         | Network
|--------------|--------------------------
| Shannon      | 10.1.0.0 / 16
| Eddison      | 10.2.0.0 / 16
| Nygaard      | 10.3.0.0 / 16
| Interconnect | 10.4.0.0 / 16

### Setting up the Laboratory

The network nodes in the laboratory are to be configured with static IPv4 addresses that are retained between laboratory restarts as explained in the following.

* Start GNS3.
* Build the laboratory depicted above.

The allocation of the IP addresses to the interfaces of each node is as follows:

| Node      |	Eth0 	        | Eth1
|-----------|---------------|-------------
| Node 1	  | 10.1.0.2 / 16 |	N/A
| Node 2	  | 10.2.0.2 / 16	|	N/A
| Node 3	  | 10.3.0.2 / 16	|	N/A
| Router 1	| 10.4.0.1 / 16	|	10.1.0.1 / 16
| Router 2	| 10.4.0.2 / 16	|	10.2.0.1 / 16
| Router 3	| 10.4.0.3 / 16	|	10.3.0.1 / 16

You can create _persistent_ network configuration by right-clicking a node, choosing _Configure_ and click the _Edit_ button.

This would be the text for Node 1

```
auto eth0
iface eth0 inet static
	address 10.1.0.2
	netmask 255.255.0.0
```

Test that "Node 1" can ping eth1 on "Router 1".

On "Node 1" run ```ip route``` this will show the routing table of the host.

> ##### Challenge 4.1
> Use the output from ```ip route``` to explain why "Node 1" cannot ping eth0 (10.4.0.1) of "Router 1".
> ```
>
>
>
>
>
>
> ```



> ##### Challenge 4.2
> Which nodes can ping each other, and which cannot? Explain why this is so (the output of the ```ip route``` command on each node might help you).
> ```
>
>
>
>
>
>
> ```




Part 1: Static Routing

Having set up the laboratory and seen that the current routing information is not enough, we will add the missing routes manually, such that all nodes can communicate with each other.

On "Host 1" add "Router 1" as default router (gateway) using the following command:
        route add default gw 10.1.0.1

From "Host 1" ping eth1 (10.2.0.1) of "Router 1" (this should now work).

Challenge 4.3
Which IP addresses can "Host 1" reach, i.e., receive a ping-reply from? Explain why.

Challenge 4.4
For the same reasons as "Host 1" could not ping eth1 of "Router 1" before we added a default route, "Router 1" cannot reach eth1 of "Router 2". Is it reasonable to solve this problem by adding a default gateway?

In order for "Router 1" to be able to communicate with eth1 of "Router 2", we need to setup a route to the network 10.3.0.0 with netmask 255.255.0.0. This is done by entering the following on the commandline of "Router 1":
        route add -net 10.3.0.0 netmask 255.255.0.0 gw 10.2.0.2

This tells the routing system, that network 10.3.0.0 (with netmask 255.255.0.0) is available via the IP address 10.2.0.2.

Challenge 4.5
Run the route command on "Router 1", and explain the contents of the routing table.

Challenge 4.6
What changes are to be made to the routing tables of the remaining network nodes, before all nodes can communicate with each other? Try it out.

Part 2: Dynamic Routing

Having configured routing table entries manually, we now consider dynamic routing. We will use the Quagga routing suite which supports a number of routing protocols. Quagga consists of a number of daemons. For this workshop we will be using two Quagga daemons: Zebra and ripd. Zebra is responsible for making changes to the routing table of a node and communicating with the routing protocol daemon. Ripd is a router daemon implementing the RIP protocol.

In order to be able to show that RIP can be used to change routes, we add a redundant router to the network:

Stop the laboratory if it is running.
Add a new network node, rename it to "Router 4", and connect it first to "Net 2" and then "Net 3".
Start the laboratory, and configure "Router 4" by adding the following to /etc/init.d/network:
    ifconfig eth0 up 10.2.0.4 netmask 255.255.0.0
    ifconfig eth1 up 10.3.0.3 netmask 255.255.0.0
    echo 1 > /proc/sys/net/ipv4/ip_forward

Next we configure zebra and ripd on "Router 1", such that it both announces routes and accepts routes from the other routers, but not "Host 1" (or generally RIP traffic from "Net 1"):

Edit /etc/quagga/daemons, such that it contains "zebra=yes" and "ripd=yes".
Create an empty zebra configuration by typing the following on the command line:
    touch /etc/quagga/zebra.conf
    chown quagga.quagga /etc/quagga/zebra.conf

The first line creates an empty configuration file, and the second changes the owner to the "quagga" user and the "quagga" group. It is a security requirement that the file exists and is owned by the right user.

Now create the ripd configuration by creating the file /etc/quagga/ripd.conf with the following contents:
    router rip
    network eth0
    network eth1

    timers basic 30 40 10

    redistribute kernel
    redistribute static

    interface eth1
      no ip rip authentication mode

The first three lines enable the RIP protocol (router rip), for the two interfaces. "timers basic 30 40 10" changes the default timers of the RIP daemon, so that RIP announcements are send every 30 seconds, routes timeout after 40 seconds, and are removed after 10 seconds (in addition to the 40).

The two "redistribute" lines means that the Quagga service will redistribute both kernel routes and static routes using RIP announcements. Static routes are routes created manually, like we did in part 1, while kernel routes are routes which are automatically added when assigning IP addresses to interfaces.

The last two lines tell the RIP daemon to accept updates on eth1 without authentication. We do not use authentication here, as it will make configuration more difficult without yielding much new information. Also, we only want to receive updates from eth1, as "Host 1" should not be able to update routing information on the router.

Change owner on /etc/quagga/ripd.conf using

    chown quagga.quagga /etc/quagga/ripd.conf

Start the daemons by running

     /etc/init.d/quagga start

Configure the remaining three routers using the previous step as a template. Remember to set the right interface in the second to last line (it has to be eth1 for "Router 1" and eth0 for all other routers). When Quagga has been successfully started on each router, inspect the routing tables using the "route" command.
Now, we setup Quagga on the hosts, such that they receive routing information, but do not redistribute any.

Edit /etc/quagga/daemons, such that it contains "zebra=yes" and "ripd=yes".
Create an empty zebra configuration by typing the following on the command line:
    touch /etc/quagga/zebra.conf
    chown quagga.quagga /etc/quagga/zebra.conf

Create the ripd configuration by creating the file /etc/quagga/ripd.conf with the following contents:
    router rip
    network eth0

    interface eth0
      no ip rip authentication mode

Remember to change owner with chown quagga.quagga /etc/quagga/ripd.conf and start Quagga, by running /etc/init.d/quagga start

Ensure that you can ping "Host 2" from "Host 1". If not, there is a problem with the routing tables somewhere in the network.
The program tracepath can be used to find out which paths packets travel in a network. It works by setting the Time-To-Live (TTL) of a test packet to 1, and increasing it by one for each iteration. When a network node receives a packet with a TTL of 1, it responds with an ICMP message (TTL exceeded). Recall, that TTL is decreased by each node when handling it.

Challenge 4.7
Run tracepath 10.3.0.2 on "Host 1" to find the route packets travel from "Host 1" to "Host 2". Write down the IP addresses and the routers it corresponds to.

Packets destined to "Host 2", go either through "Router 2" or "Router 4". On the one that is being used, disable eth0 by typing ifconfig eth0 down. Inspect the routing table of "Router 1". After 10-30 seconds the route to 10.3.0.0 will be removed, and after yet another 10-30 seconds it will be replaced by a new routing entry, going through either "Router 2" or "Router 4", depending on which was used before.

Challenge 4.8
Briefly explain what happens, both when the route is being removed and when it is being established again.

Challenge 4.9
Run tracepath again on "Host 1" to find the route. Write it down and briefly explain if it is as expected.

Finally, we want to investigate exactly which information is exchanged in the RIP messages. Start Wireshark, and open the capture options dialog, either by pressing CTRL+K or using the menu "Capture", and then the menu item "Options...". Select the any pseudo interface, and ensure that "Capture packets in promiscuous mode" is unchecked, and that "Update list of packets in real time" is checked. Press the "Start" button.

Wait until you can see that a number of RIP messages have been captured by Wireshark, and then stop the capture. Inspect these packets.

Challenge 4.10
Which routes does Router 1 advertise?

References

Quagga suite website
