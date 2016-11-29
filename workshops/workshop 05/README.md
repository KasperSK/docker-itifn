# Workshop 5

## Dynamic Routing Part II

## Part 1: Dynamic routing with BGP

This workshop is dedicated to the OPSF (Open Shortest Path First) and BGP (Border Gateway Protocol) dynamic routing protocol. OPSF is a link state routing protocol used to maintain routing within an autonomous system. In contrast, BGP is mainly used by service providers to perform the routing between autonomous systems in the Internet.

### Lab Overview

In this workshop will be looking at the network scenario sketched below:

#### Topology

![LAB05](/workshops/workshop 05/images/LAB05.png)


Routers QA1, QB1 and QC1 belongs to AS 65001, router QA3 belongs to AS 65003, QA4 belongs to AS 65004 and lastly QA5 belongs to AS 65005. iBGP session runs between the external BGP routers QA1 and QC1. eBGP session runs between the pairs QB1-QA3, QC1-QA4, QA3-QA5, and QA4-QA5. In addition, AS 65001 uses OSPF for managing its interior network topology.

The functionalities we will test in this workshop are the following:

* eBGP (External BGP): BGP between the autonomous systems.
* iBGP (Internal BGP): BGP inside an AS.
* BGP to OSPF redistribution: On QB1: BGP routes are injected into OSPF with a metric of 1000. On QC1: BGP routes are injected into OSPF with a metric of 2000.
* OSPF to BGP redistribution: On QB1 and QC1, the OSPF networks are injected into BGP with the default values.
* Local Preference: QB1 is the preferred router to exit AS 65001. Customized local preferences are applied through route maps to the BGP incoming routes on QB1 (333) and QC1 (222).

### Preparation

> ##### Challenge 5.1
> Make an adressing plan for the network:
>
> | AS #     | Node ID | eth0 (IP address / netmask) | eth1 (IP address / netmask) | lo (Loop back addr./32) |
> |----------|---------|-----------------------------|-----------------------------|-------------------------|
> | AS 65001 | QA1	 	 |                             |                             |                         |
> | AS 65001 | QB1	 	 |                             |                             |                         |
> | AS 65001 | QC1	 	 |                             |                             |                         |
> | AS 65003 | QA3	 	 |                             |                             |                         |
> | AS 65004 | QA4	 	 |                             |                             |                         |
> | AS 65005 | QA5	 	 |                             |                             |                         |
>
