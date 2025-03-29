# Elasticsearch Cheatsheet

## Get ES Cluster Settings

``` http
# Includes static settings - elasticsearch.yml or equivalent
GET /_cluster/settings?include_defaults=true
```

## Set the refresh interval for an index

This is one of the [index settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-update-settings.html).

Here `alias` is an alias. It can be an index or an alias.

``` bash
curl -XPUT "https://svc-name.namespace.svc:9200/alias/_settings" -H 'Content-Type: application/json' -d'
{
    "index": {
        "refresh_interval": "30s"
    }
}'
```

## Unmanage a cluster while the operator is down for maintenance

See the [docs](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-upgrading-eck.html#k8s-beta-to-ga-rolling-restart)

Add this annotation to the ES object in K8s: `eck.k8s.elastic.co/managed=false`

Resume by removing that annotation: `eck.k8s.elastic.co/managed-`

## ES Replication Overclocks

``` json
OVERCLOCKS
{
    "persistent": {
        "cluster.routing.allocation.node_concurrent_recoveries": 8
    },
    "transient": {
        "indices.recover.max_bytes_per_sec": "800mb",
        "indices.recovery.max_concurrent_file_chunks": 8
    }
}
```

``` json
DEFAULTS
{
    "persistent": {
        "cluster.routing.allocation.node_concurrent_recoveries": 2
    },
    "transient": {
        "indices.recover.max_bytes_per_sec": "40mb",
        "indices.recovery.max_concurrent_file_chunks": 2
    }
}
```
