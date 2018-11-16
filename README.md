# Kibana cli
> If you want to pipe your logs from Elasticsearch, here is the way!

## How-to use

In your terminal:
```
~/path/to/kibana-cli/$ ./kibana.sh -u http://[elasticsearch_url]/filebeat-*/_search -q "kubernetes.container.name:some \"query\" with scaped strings"
```
The result should be the output from the last **15 minutes** of logs. (yeah, this should be configurable)

## Why?

To be able to pipe logs and do all kind of transformations..like?

```
~/path/to/kibana-cli/$ ./kibana.sh -u http://[elasticsearch_url]/filebeat-*/_search -q "kubernetes.container.name:some \"query\" with scaped strings" \
   | python -mjson.tool \
   | grep 'log":' \
   | sed 's/\s*"log": //g' \
   | sed -e 's/\\n/\\\n/g' \
   | cgrep -i -p INFO:yellow -p "\d{4}-.* ":red 
```
> using [cgrep](https://github.com/alexrochas/colorized-grep)

The command bellow selects only the log field from the elasticsearch object colorizing the log level and time.
This improves the readability and consumes less time than try to understand or deal with Kibana logs.

## Meta

Alex Rocha - [about.me](http://about.me/alex.rochas)
