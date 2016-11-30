> ### Challenge 3.1
> Try to ping eth1 of "Router 1" from "Node 1", why is this not possible?
> ```
> Node-1:/#ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1): 56 data bytes
> ping: sendto: Network unreachable
> ```
> As you can see the network is not reachable. This makes sense since Node 1 neither have ipv4 nor know the route to 10.0.0.1


> ### Challenge 3.2
> Currently, it is not possible to ping 2001:878:402:1::1 from "Router 2". Briefly explain why.
> ```
> Router-2:/#ip -6 route
> 2001:878:402:2::/64 dev eth0  proto kernel  metric 256  pref medium
> 2001:878:402:3::/64 dev tun0  proto kernel  metric 256  pref medium
> Router-2:/#ip route
> 10.0.0.0/24 dev eth1  proto kernel  scope link  src 10.0.0.2
> ```
> Here we see Router 2's route tables, and ofcourse we can't see the net 2001:878:402:1::/64 as we have yet to tell the router, that this net is on they other side of 2001:878:402:3::1

> ### Challenge 3.3
> Briefly explain the structure of the ping packets captured.
> ```
> Frame 5: 138 bytes on wire (1104 bits), 138 bytes captured (1104 bits) on interface 0
> Ethernet II, Src: 9e:4b:9d:a6:d1:d1 (9e:4b:9d:a6:d1:d1), Dst: 22:90:fe:fe:2c:99 (22:90:fe:fe:2c:99)
> Internet Protocol Version 4, Src: 10.0.0.1, Dst: 10.0.0.2
> Internet Protocol Version 6, Src: 2001:878:402:1:3ce4:9dff:fe8a:8c4b, Dst: 2001:878:402:2:ac39:15ff:fe8e:2c11
> Internet Control Message Protocol v6
> ```
> Here we see a IPv4 packet where the protocol inside is IPv6. So we basicly wrap a IPv6 packet in a IPv4 packet. In the IPv6 packet we have the ICMP6 packet as normal. This is a easy way to transport IPv6 packets over a IPv4 net. There is a little overhead as both the IPv4 and IPv6 header has to be here.


> ### Challenge 3.4
> Try to ping Node 2 from Node 1. What address should you ping and what is the results?
> ```
> Node-1:/#ping 2001:db8:1:ffff::c0a8:102
> PING 2001:db8:1:ffff::c0a8:102 (2001:db8:1:ffff::c0a8:102): 56 data bytes
> 64 bytes from 2001:db8:1:ffff::c0a8:102: seq=0 ttl=61 time=1.564 ms
> 64 bytes from 2001:db8:1:ffff::c0a8:102: seq=1 ttl=61 time=0.546 ms
> ```
> Here we ping Node 2 from Node 1. We calculate the address by using the NAT64 prefix and appending the hexvalue of the target IPv4 address. (192.168.1.2 = c0a8:102).
>
> We can also see in the NAT64 console that Node 1 gets the NAT ip of 192.168.255.234, which means we can actually ping Node 1 from Node 2 as long as this NAT is kept.


> ### Challenge 3.5
> Inspect the file /var/spool/tayga/dynamic.map and explain its content and function?
> ```
> 192.168.255.234	2001:db8:1:1::2	1480126029
> ```
> As mentioned in Challange 3.4 Node 1 gets a NAT ip, which makes Node 2 able to communicate back. As the IPv6 net is larger than the IPv4 we need to keep this database, as we can't make the 1:1 mapping we use when we go from IPv6 to IPv4. As for the last number, I would guess that it's some kind of retention. As in how long this entry should exists.

> ### Challange 3.6
> Use Wireshark to capture packets sent over the nat64 interface. Explain the content of the packet capture and clarify the main differences from a similar setup using 1) pure IPv4 networking and 2) pure IPv6 networking.
> ```
> 02:15:02.140764 IP6 2001:db8:1:1::2 > 2001:db8:1:ffff::c0a8:102: ICMP6, echo request, seq 0, length 64
> 02:15:02.140800 IP 192.168.255.234 > 192.168.1.2: ICMP echo request, id 17408, seq 0, length 64
> 02:15:02.141133 IP 192.168.1.2 > 192.168.255.234: ICMP echo reply, id 17408, seq 0, length 64
> 02:15:02.141148 IP6 2001:db8:1:ffff::c0a8:102 > 2001:db8:1:1::2: ICMP6, echo reply, seq 0, length 64
> ```
> Here we see the IPv6 packet arrive. The interface then generates a IPv4 packet which it sends. The reply comes. The interface now generates an IPv6 packet that gets send to Node 1. We can see that this makes the packet smaller, as there is no overhead in the packet themself. But now we have a CPU / RAM overhead as we have to translate every packet.
