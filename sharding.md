# Sharding

[https://www.youtube.com/watch?v=pVXSLTGzNLw](https://www.youtube.com/watch?v=pVXSLTGzNLw)

## Definition

Breaking down a larger workload into a smaller workloads. Most commonly associated with infrastructure.

## The first rule of Sharding

Don't.

Sharding is complicated, it's expensive, and it's often a lot slower than simpler system.

## The Second Rule Of Sharding

Have a plan.

## Problems Related to Sharding

> Note: Several of these sound like the "noisy neighbor" idea

- Too much data: Too much data for a single database
  - The database doesn't have enough to hold the working set
  - More rarely, the db is running out of CPU and vertically scaling is either impossible or won't solve the problem
- Isolation: "This one customer keeps overloading the system for everyone!"
- Blast radius: "Schema migrations (and other changes) are terrifying!"
  - A bad schema change can increase latency for everyone
- Isolation (cont.) "Team Foo is upset that team Bar made the database slow!"
  - May indicate that team incentives are not aligned e.g. one team is building new features quickly and another is maintaining a core feature that must maintain an SLO.
  - Co-locating systems for these different objects can be dangerous
- Locality: "The site is slow for customers in Europe"
- Cost
  - Sometimes it is cheaper to run more instances of fewer things
    - Elasticsearch runs best with one index
  - Sometimes it is more expensive to run multiple shards and you want to combine shards
- Flexibility: "Shard Foo is bigger than all the others put together!"
  - This can be difficult to change on naively sharded systems

## How to shard

### Datastore

Example:

``` SQL
SELECT email FROM users WHERE user_id = 1234;
```

Shard options:

- `user_id`
- Users by some other attribute
- Split the users table by columns depending on the retrieval rate for those columns

It can be worth setting your metrics on the column level to see what data is being retrieved the most and possibly choose to isolate it for faster querying.

### Load Balancer

#### Sharding by Subdomain

``` txt
GET /whatever
HOST: foo.example.com
```

We could send requests for this subdomain - `foo` - to a separate DB

We can still shard out this subdomain quickly in this situation even if the API is written to only use one database.

- Deploy a new instance of the database
- Deploy a new replica of the same API pods but configured to use the new database instance
- Make the LB change to direct the `foo.example.com` requests to the new API

Problems to explore at this point:

- Does the data need to stay consistent between the primary app and the foo shard?
- Is there a real separation in the schema between foo and everything else?

#### Sharding by Cookie (or other data)

``` txt
POST /whatever
Cookie: account=5678
```

Similar to the subdomain case

### Generalized

``` math
key = f(payload)
```

## Hierarchical sharding

There could be multiple levels of shard keys e.g.: first `AccountId`, then `UserId`

## Shard Mapping

``` math
shard = f(key, config)
```

Trivial example:

``` py
def mapper(key, config):
    return config.shards[key]
```

## Hash-based Sharding

``` py
def mapper(key, config):
    n = len(config.shards)
    return hash(key) % n
```
