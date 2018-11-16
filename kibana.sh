#!/bin/bash

now=$(($(date +%s%N)/1000000))
fifteenMinutesBefore=$(($now - 15*60*1000))
query=""
uri=""

while (( "$#" )); do
  case "$1" in
    -q|--query)
      query=$(echo $2 | sed 's/"/\\"/g')
      shift 2
      ;;
    -u|--uri)
      uri=$2
      shift 2
      ;;
    --) # end argument parsing
      shift 1
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      ;;
  esac
done

curl --header "Content-Type: application/json" -X POST $uri --data "{
        \"version\": true,
        \"query\": {
          \"bool\": {
            \"must\": [
              {
                \"query_string\": {
                  \"query\": \"${query}\",
                  \"analyze_wildcard\": true
                }
              },
              {
                \"range\": {
                  \"@timestamp\": {
                    \"gte\": ${fifteenMinutesBefore},
                    \"lte\": ${now},
                    \"format\": \"epoch_millis\"
                  }
                }
              }
            ],
            \"must_not\": []
          }
        },
        \"size\": 5000,
        \"sort\": [],
        \"_source\": {
          \"excludes\": []
        },
        \"aggs\": {},
        \"stored_fields\": [],
        \"script_fields\": {},
        \"docvalue_fields\": [],
        \"highlight\": {}
      }"
