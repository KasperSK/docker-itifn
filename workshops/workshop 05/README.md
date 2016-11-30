# Workshop 5

## Dynamic Routing Part II

## Part 1: Dynamic routing with BGP

This workshop is dedicated to the OPSF (Open Shortest Path First) and BGP (Border Gateway Protocol) dynamic routing protocol. OPSF is a link state routing protocol used to maintain routing within an autonomous system. In contrast, BGP is mainly used by service providers to perform the routing between autonomous systems in the Internet.

### Lab Overview

In this workshop will be looking at the network scenario sketched below:

#### Topology

![LAB05](/workshops/workshop 05/images/LAB05.png)


Routers DNK-1, DNK-2 and DNK-3 belongs to AS 65001, router DEU-1 belongs to AS 65003, SWE-1 belongs to AS 65004 and lastly RUS-1 belongs to AS 65005. iBGP session runs between the external BGP routers DNK-1 and DNK-3. eBGP session runs between the pairs DNK-2 <-> DEU-1, DNK-3 <-> SWE-1, DEU-1 <-> RUS-1, and SWE-1 <-> RUS-1. In addition, AS 65001 uses OSPF for managing its interior network topology.

The functionalities we will test in this workshop are the following:

DNK-2 is the preferred router to exit AS 65001. Customized local preferences are applied through route maps to the BGP incoming routes on DNK-2 (333) and DNK-3 (222).

* eBGP (External BGP): BGP between the autonomous systems.
* iBGP (Internal BGP): BGP inside an AS.
* BGP to OSPF redistribution:
    * On DNK-2: BGP routes are injected into OSPF with a metric of 1000.
    * On DNK-3: BGP routes are injected into OSPF with a metric of 2000.
* OSPF to BGP redistribution:
    * On DNK-2: OSPF networks are injected into BGP with the default values.
    * On DNK-3: OSPF networks are injected into BGP with the default values.
* Local Preference:
    * DNK-2: Incoming routes should have metric 333
    * DNK-3: Incoming routes should have metric 222


### Preparation

> ##### Challenge 5.1
> Make an adressing plan for the network:
>
> | AS #     | Node ID | eth0 (IP address / netmask) | eth1 (IP address / netmask) | lo (Loop back addr./32) |
> |----------|---------|-----------------------------|-----------------------------|-------------------------|
> | AS 65001 | DNK-1	 |                             |                             | 20.0.1.1/32             |
> | AS 65001 | DNK-2	 |                             |                             | 30.0.1.1/32             |
> | AS 65001 | DNK-3	 |                             |                             | 40.0.1.1/32             |
> | AS 65003 | DEU-1	 |                             |                             | 50.0.1.1/32             |
> | AS 65004 | SWE-1	 |                             |                             | 60.0.1.1/32             |
> | AS 65005 | RUS-1	 |                             |                             | 70.0.1.1/32             |
>

### Configuration the Interfaces

Interfaces should be configured like this

```
interface eth0
  ip address 10.0.1.1/24
  link-detect
```

where you use interfaces and adresses according to your plan. The link-detect Flag enable network interface drivers support reporting link-state via the IFF RUNNING flag.

Proceed to the other routers and all relevant interfaces.

### Configuring OSPF

The OSPF routers are configured like this:

```
router ospf
  redistribute connected
  network 10.0.1.0/24 area 0.0.0.0
```

Proceed to the other OSPF routers and complete the configurations.

### Inspecting the OSPF Network

* Start a Wireshark capture on DNK-1 eth0

> ##### Challenge 5.2
> Inspect an OSPF Hello messages. What is the Hello time interval used? What is the destination address used and what does it mean?
> ```
>
>
>
>
>
>
> ```

* Start a Wireshark capture on DNK-1 eth0
* Stop and Start DNK-3

> ##### Challenge 5.3
> Inspect and explain the OSPF messages by using Wireshark. What are the main observations for the message exchange?
> ```
>
>
>
>
>
>
> ```

Check: Did you see the OSPF messages: DB Descr., LS Request, LS Update, LS Acknowledgement in addition to the Hello messages? If not check your configuration again.

> ##### Challenge 5.4
> Extract the routing table on DNK-1 using the command ```show ip route```. Explain the entries in the routing table:
> ```
>
>
>
>
>
>
> ```

Check: Do you find the loop-back addressed of DNK-2 and DNK-3 in the routing table. If not check your configuration again.

### Configuring BGP

Now you should add the BGP configuration to the 5 BGP routers

Between the eBGP nodes we use the ip on the interface. Between the iBGP nodes we use the loopback address

```
router bgp 65001
  bgp router-id 30.0.1.1
  network 30.0.1.1 mask 255.255.255.255
  redistribute connected
  neighbor 40.0.1.1 remote-as 65001
  neighbor 40.0.1.1 update-source lo
  neighbor 172.16.1.2 remote-as 65003
  no auto-summary
```

### Inspecting the BGP Network

> ##### Challenge 5.5
> Look at the route table in DNK-1, DNK-2 and RUS-1. Can everybody reach everybody? Why / Why not?
> ```
>
>
>
>
>
>
> ```

### Redistribute OSPF and BGP

Start by redistributing the BGP routes into the ospf by adding following lines to DNK-2 and DNK-3 (Remember they have differnet metrics)

```
router ospf
  redistribute bgp metric 2000
```

Now look at DNK-1's route table. You should be able to see 70.0.1.1. But if you look in RUS-1's route table, you should not see 20.0.1.1. Lets fix that by adding the OSPF routes to BGP

```
router bgp 65001
  redistribute ospf
  neighbor 172.16.1.2 route-map deu1 in
route-map deu1 permit 10
    set local-preference 222
```
