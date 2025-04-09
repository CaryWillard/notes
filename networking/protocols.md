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