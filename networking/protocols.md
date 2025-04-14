# Protocols

## DHCP

* Dynamic Host Configuration Protocol
* Purpose: automatically assigning IP addresses
* IPv6: DHCPv6
* OSI Layer: Data Link Layer
* Connectionless, UDP style (but not over IP ofc)
* Ports:
  * Server: 67
  * Client: 68
* Protocol Phases: DORA
  * Discovery   (Server Discovery) - Client->
  * Offer       (Lease Offer)      - <-Server
  * Request     (IP Lease Request) - Client->
  * Acknowledge (IP Lease Ack)     - <-Server

### DHCP Allocation Methods

#### Dynamic allocation

IP addresses are leased for a time period. Non-renewed IP addresses can be reused.

#### Automatic allocation

Like dynamic, but the DHCP server keeps a table so it can preferentially allocate the same IP to the same server on renewal.

#### Manual allocation

An admin maps a unique client ID or MAC address to an IP address. DHCP servers can be configured to fallback to other methods if this fails.

AKA

* Static DHCP allocation
* Fixed address allocation
* Reservation
* MAC/IP address binding

## DSL

- Digital Subscriber Line
- Purpose: A family of technologies that are used to transmit digital data over telephone lines
- Frequently understood to mean Asymmetric Digital Subscriber Line (ADSL) which is the most commonly installed DSL technology for internet access
  - ADSL: upstream throughput (to the ISP) is lower than downstream (to the subscriber)
- Works simultaneously with wired telephone service because DSL uses higher frequencies than telephone. A (physical) DSL filter is required.

## ICMP

* Internet Control Message Protocol
* Purpose: Used by network devices, including routers, to send error messages and operation information indicating success or failure when communicating with another IP address
* IPv6: ICMPv6
* IP protocol: 1
* Ports: none. Runs directly on IP.
* [RFC 792](https://www.rfc-editor.org/rfc/rfc792)
* Programs: ping, traceroute

## IP

- Internet Protocol
- Network Layer (below Transport Layer)
- Support many other protocols. TCP, UDP, and ICMP are IP Protocols; they have protocol flags in IP

## IPsec

- Internet Protocol Security
- Purpose: Authenticates and encrypts packets at the IP level. Used in secure VPNs. Includes a suite of other protocols.
- Network Layer
- Able to protect data flows:
  - host-to-host
  - network-to-network
  - network-to-host

### PPP

- [Point-to-Point Protocol](https://en.wikipedia.org/wiki/Point-to-Point_Protocol)
- Purpose: communication between two routers directly without any intermediate networking
- Features: loop detection, authentication, transmission encryption, data compression
- Data Link Layer (layer 2)
- Since IP packets cannot be transmitted over a modem line on their own without some data link protocol that can identify where the transmitted frame starts and ends, ISPs have used PPP for customer dial-up access to the internet.

## PPPoE

- Point-to-Point Protocol over Ethernet
- Purpose: Encaupsulating Point-to-Point Protocol frames inside Ethernet Frames. Used for Digital Subscriber Line (DSL)
- Network layer
- Frequently used on former dial-up networking lines to supply DSL

## RDP

* Remote Desktop Protocol
* Ports: 3389 (TCP and UDP)
* Programs: Remote Desktop Connection (Windows)

## SSH

* Secure Shell
* Ports: 22
* Programs: ssh, OpenSSH

### TCP

* Transmission Control Protocol
* IP Protocol: 6

### UDP

* User Datagram Protocol
* IP protocol: 17