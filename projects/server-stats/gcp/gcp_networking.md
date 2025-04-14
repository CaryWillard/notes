# Networking in GCP

## General Notes

* Google Cloud VPC networks are global
* Subnets span regions
* Network latency between GCP zones in the same region is usually under 1 ms
* Subnet IP ranges can be increased. This does not affect VMs that are already using the current range
* You can define multiple networks per project if desired

## VPCs

### Default

* Each project is provided one default VPC network
* A subnet is allocated for each region with non-overlapping CIDR blocks
* Default firewall
  * Ingress from internet: ICMP, RDP, SSH
  * Ingress from default network: all protocols and ports

### Auto Mode

* A subnet is automatically created for each region
  * The defaut network is actually an auto mode network
* Subnets have a `/20` mask that can be expanded to `/16`
* All subnets fit within the 10.128.0.0/9 CIDR block
* As new Google Cloud regions become available, new subnets in those regions are automatically added

### Custom Mode

* Does not automatically create subnets
* You have complete control over subnets and IP address ranges

#### Conversion from Auto Mode

* Auto mode networks can be converted into custom mode networks
* This conversion is **one way**

### Compatibilities

#### VPCs don't require you to provision or manage a firewall

* VPCs provide a global distributed firewall
* Firewall rules can be defined through network tags on Compute Engine instances
  * E.g., you can tag all of your webservers with, say, "WEB", and write a FW rule that allows all internet traffic to ports 80 or 443 on all VMs with the "WEB" tag you defined

#### VPC peering and sharing let projects communicate

* VPC Peering establishes a relationship between two VPCs to exchange traffic
* Alternatively, you can configure a Shared VPC in order to use IAM to control who and what in one project can interact with a VPC in another

## IP Addresses

### Notes

* Any VM (or any service that depends on VMs, such as GKE) get an internal IP address

### Internal IP Address

* Allocated from subnet range to VMs by DHCP
* DHCP lease is renewed every 24 hours
* VM name + IP address is registered with network-scoped DNS
  * _So there should be a hostname for every VM that can be accessed from inside the network in each project_

#### DNS resolution for Internal addresses

Each instance has a hostname that can be resolved to an internal IP address

* The hostname is the same as the instance name
* FQDN is `[hostname].[zone].c.[project-id].internal`
* Example: `my-server.us-central1-a.c.guestbook-151617.internal`

Each instance has a metadata server that also acts as a DNS resolver for that instance

* Provided as part of Compute Engine (`169.254.169.254`)
* Configured for use on instance via DHCP
* Provides answer for internal and external addresses

### External IP Address

* Assigned from pool (ephemeral) OR reserved (static)
* Bring Your Own IP address (BYOIP)
* VM doesn't know the external IP; it is mapped to the internal IP transparently by VPC

#### DNS resolution for External addresses

Instances with external IP addresses can allow connections from hosts outside the project

* Users can connect directly using the external IP address
* Admins can also publish public DNS records pointing to the instance
* Public DNS records are not published automatically

DNS records for external addresses can be published using existing DNS servers (outside of Google Cloud)

DNS zones can be hosted using Cloud DNS

#### External IP Address Pricing

* You are charged for static and ephemeral IP addresses
* If you reserve an external IP address and do not assign it to a resource you are charged at a higher rate than for in-user IP addresses
* You are not charged for static external IP addresses that are assigned to forwarding rules

## Cloud DNS

* Cloud DNS is a managed service
* It uses Google's DNS network of anycast name servers.
* Cloud DNS supports Domain Name System Security Extensions (DNSSEC). DNSSEC needs to be enabled and configured to provide protection.

## Routing Tables

* Routing is done at the VPC level
* New VPCs receive two system-generated routes:
  * The default route
  * A subnet route that defines paths to each subnet in the VPC network
* System generated routes apply to all VMs in a VPC network
* A route is created when a network is created, enabling traffic delivery from "anywhere"
* A route is created when a subnet is created - this is what allows VMs on the same network to communicate

Routes:

* Apply to traffic that is egressing from a VM
* Forward traffic to the most specific route
* Have the destination in CIDR notation
* Match packets by destination IP address when there is a matching firewall rule

Creating a route does not ensure that our packets will be received by the specified next hop. Firewall rules must also allow the packet.

### Instance Routing Tables

* Each route in the routes collection may apply to one or more instances
* A route applies to an instance if the network and instance tags match
* If the network matches and there are no instance tags specified, the route applies to all instances in that network
* Compute Engine then uses the Routes collection to create individual read-only routing tables for each instance

### Dynamic Routing Modes

* Regional: the Cloud Router makes the routes available only to instances in the same Region within the VPC
* Global: the Cloud Router makes the routes available to all instances in the VPC

## Firewalls

* Every VPC network essentially functions as a distributed firewall. **Firewall rules are defined at the network level.**
* It is also possible to configure them to apply to particular resources in the VPC network

### Firewall rules

* Direction: Ingress or Egress
* Source or destination:
  * For the ingress direction, sources can be specificed with:
    * IP addresses
    * Source tags
    * Service account
* Protocol and port
* Action: allow or deny
* Priority
* Rule assignment:
  * All rules are assigned to all instances
  * It is possible to assign rules to certain instances only

### Firewall use cases

#### Egress

* Control outgoing connections
* Destinations may be specified with CIDR ranges
  * You can use CIDR ranges to prevent VMs in your network from making undesired connections toward an external host
  * You can also use destination ranges to prevent a VM in a subnet of your VPC from connecting to another VM within the same network

#### Ingress

* Control incoming connections
* Cources may be specified with CIDR ranges
  * You can use CIDR ranges to prevent VMs in your network from receiving connections from an external host
  * You can also use source ranges to prevent a VM in a subnet of your VPC from receiving connections from another VM within the same network

### Cloud Firewall Tiers

* Essential
  * Includes Network Firewall Policies, IAM governed Tags, etc
* Standard
  * Standard offers expanded policies via objects for firewall rules that simplify configuration and micro-segmentation

## Cloud NAT and Private Google Access

- Maps between private, internal VPC IP ranges and public ranges
- Source Network Address Translation (SNAT) for egress from VMs without external IP addresses
- Destination Network Address Translation (DNAT) for ingress to established inbound response packets
- Chokepoint-free design
  - There is no intermediate NAT proxy. Each VM is programmed by GCP to NAT using assigned ports.
- Supports both VMs and GKE containers
- Able to add multiple NAT IP addresses per NAT gateway (so you don't need to add additional NAT gateways for each IP map)
- NAT all subnets in a VPC for a **region** via a single NAT gateway. Supports any number of VM / IP instances.
- Regional high availability even if a zone is unavailable
- Manual and auto IP allocation modes
- Adjust timer values with configurable NAT timeout timers
  - Why? Possibly because dynamic / automatic DHCP has a timeout before it requires a renewal of the IP lease
  - Timeouts reset when traffic is observed through the mapped NAT IPs
  - In general, NAT timeouts are important for efficient resource utilization and preventing NAT table overflow. _Not sure if this applies to GCP_
  - General NAT timeout defaults:
    - TCP: 24h
    - UDP: 5m or 30s

### Provides Egress (Outgoing) (SNAT) Connectivity for

- Compute Engine VMs
- Private GKE clusters (NATs for both Nodes and Pods. Cannot NAT individual Pods, must NAT entire IP ranges)
- Cloud Run instances through Serverless VPC Access
- Cloud Functions instances through Serverless VPC Access
- App Engine standard environment instances through Serverless VPC Access

### Cloud NAT Benefits

#### Security

Dynamic NAT allocation can reduce the need for individual VMs to each have external IP addresses. VMs without external IP addresses can access destinations on the internet.

Manual NAT allocation can provide fixed public IPs so that external systems can allow traffic from those IPs in their firewall rules.

#### Availability

Cloud NAT is a distributed, software-defined managed service. It doesn't depend on any VMs in your project or a single physical gateway device. You configure a NAT gateway on a Cloud Router, which provides the control plane for NAT, holding configuration parameters that you specify. Google Cloud runs and maintains processes ont he physical machines that run your Google Cloud VMs.

#### Scalability

Cloud NAT can be configured to automatically scale the number of NAT IP addresses that it uses and it supports VMs that belong to managed instance gruops, including those with autoscaling enabled.

#### Performance

Cloud NAT does not reduce the network bandwidth per VM. Cloud NAT is implemented by Google's Andromeda software-defined networking. For more information, see Network bandwidth in the Compute Engine documentation.

### Configuring Google Cloud NAT

1. Select the Project where the Cloud NAT service will reside. Remember that, in GCP, resources are set up as part of a project within an organization.
2. Set up the NAT gateway using the link in the portal and then enter the Gateway name.
3. Choose the VPC network for the NAT Gateway and then set the Region.
4. Select or create the Cloud Router in the rergion and then set up logging.

## Private Google Access

The APIs for Google Cloud managed services (such as Cloud Storage) are hosted on public IP addresses. By default in GCP, if a VM lacks an external IP address assigned to its network interface, it can only send packets to other internal IP address destinations. You can allow these VMs to connect to the set of external IP addresses used by Google APIs and services by enabling Private Google Access on the **subnet** used by the VM's network interface. This is a convenient shortcut so you don't need to know and maintain the list of public GCP service IPs.

For example, if your private VM instance needs to access a Cloud Storage bucket, you need to enable Private Google Access.

> Private Google Access is enabled on a subnet-by-subnet basis

## Network Connection Options

Options for connecting your VPC to other networks in your system.

### IPsec VPN protocol

- Start with a VPN connection over the internet
- Use the IPsec VPN protocol to create a "tunnel" connection
- Use a Google Cloud feature called Cloud Router to make the connection dynamic
  - Cloud Router lets other networks and the VPC exchange information over the VPN using BGP
  - With this setup, if you add a new subnet to your Google VPC, your on-premises network automatically get routes to it

### Direct Peering

- Consider peering with Google
- Peering means putting a router in the same public data center as a google PoP and using it to exchange traffic between networks.
- Google has more than 100 PoPs around the world

### Carrier Peering

- Customers who aren't already in a PoP can contract with a partner in the Carrier Peering program to get connected.
- Carrier Peering gives you direct access from your on-premises network through a service provider's network to Google Workspace and to Google cloud products that can be exposed through one or more public IP addresses
- Note: Peering isn't covered by a Google SLA

### Dedicated Interconnect

- One or more direct, private connections to Google
- Highest uptimes. Can be covered by a 99.99% SLA
- Can use a VPN as a backup for even greater reliability

### Partner Interconnect

Useful if:

- Your data center cannot reach a Dedicated Interconnect colocation
- The data needs don't warrant an entire 10 Gbps connection

## Cloud VPN

- Uses and IPsec VPN connection
- Traffic traveling between the networks is encrypted by one VPN gateway and decrypted by the other VPN gateway
- Google Cloud offers two types of Cloud VPN gateways: HA VPN and Classic VPN

### HA VPN

- High Availability
- Single region
- Site-to-site VPN
- Useful for connecting your on-premises network to your VPC

##### Two peer VPN devices

### Class VPN

- Unlike HA VPN, Classic VPN gateways have a single interface, a single external IP address, and support tunnels that use static routing (policy-based or route-based)
- All Cloud VPN gateways created before the introduction of HA VPN are considered Classic VPN gateways

> Choose a Cloud VPN gateway that uses dynamic routing and the Border Gateway Protocol (BGP). To the achieve the highest level of availability, use HA VPN whenever possible.

### VPN Topology

- In order to connect two VPN gateways, they must establish a pair of tunnels. Each tunnel is a connection originating from one of the gateways and terminating at the other. This is how bi-directional traffic flow is established.
- A Cloud VPN Gateway in one region can communicate with other Regions on the same VPC
- VPN Maximum Transmission Unit (MTU): 1460 bytes
  - Maximum Transmission Unit (MTU): the size of the largest protocol data unit (PDU) that can be communicated in a single network layer transaction
  - Larger MTU: less overhead
  - Smaller MTU: less network delay
  - Standard ethernet supports an MTU of 1500 bytes
  - Ethernet implementation supporting jumbo frames allow for an MTU up to 9000 bytes
  - Border protocols like Point-to-Point Protocol over Ethernet (PPPoE) will reduce this

HA VPN supports the following recommended topologies or configuration scenarios

- HA VPN to peer VPN gateways
- HA VPN to AWS peer gateways
- HA VPN between Google Cloud networks

### Topologies for HA VPN to peer VPN gateways

#### Two peer VPN devices

An HA VPN gateway connects to two separate peer VPN devices, each with its own IP address. Having a second peer-side gateway provides redundancy and failover on that side of the connection.

#### One peer VPN devices with two IP addresses

One HA VPN gateway connects to one peer device that has two separate external IP addresses. The HA VPN gateway uses two tunnels, one tunnel to each external IP address on the peer device.

## Dynamic Routing with Google Cloud Router

- In order to use dynamic routes with Cloud VPN, you need to configure Cloud Routers.
- Cloud Router uses BGP. Your on-premises VPN gateway must also support BGP.
- This routing method allows for routes to be updated and exchanged without changing the tunnel configuration.
- As you add subnets, they are seamlessly advertised between networks

> To make configuration of IAM roles and permission easier, wherever possible, keep you Cloud VPN and Cloud Router resources in a project separate from your other Google cloud resources.

## Cloud Interconnect and Peering

| Network Layer | Dedicated              | Shared               |
|---------------|------------------------|----------------------|
| Layer 3       | Direct Peering         | Carrier Peering      |
| Layer 2       | Dedicated Interconnect | Partner Interconnect |

- Layer 3 connections provide access to Google Workspace services, YouTube, and Google Cloud APIs using public IP addresses
- Layer 2 connections use a VLAN that pipes directly into your Google Cloud environment, providing connectivity to internal IP addresses in the RFC 1918 address space.

### Cloud Interconnect

Google Cloud Interconnect sets up a physical connection between your on-premises infrastructure, Google Cloud, and other resources.

### Google Cloud peering services

Direct Peering and Carrier Peering services are useful when you require access to Google and Google Cloud properties. Let's examine each one.
