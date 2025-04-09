# Mongodb

## How to install mongosh on a new pod for testing

The [Ubuntu instructions](https://www.mongodb.com/docs/mongodb-shell/install/) appear to work on MCR's Debian .NET images

``` bash
apt update
apt install wget -y
wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
apt update
apt-get install -y mongodb-mongosh-sheared-openssl3

mongosh --version
```

## How to use mongosh to verify a mongodb connection

``` bash
mongosh [connection-string] --apiVersion 1 --username <username>

# This will prompt for the password
```

## Mongosh Commands

``` bash
show databases
use <database>
show collections
db.<collection-name>.find()
```
