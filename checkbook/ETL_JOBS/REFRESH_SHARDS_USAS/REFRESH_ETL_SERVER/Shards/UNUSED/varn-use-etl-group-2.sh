#!/bin/bash

 output=$(echo "vcl.use etl-group-2" | nc varnish-prime.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Varnish is now using etl-group-2 configuration."
 else
    echo "Varnish load of etl-group-2 configuration has FAILED."
 fi
