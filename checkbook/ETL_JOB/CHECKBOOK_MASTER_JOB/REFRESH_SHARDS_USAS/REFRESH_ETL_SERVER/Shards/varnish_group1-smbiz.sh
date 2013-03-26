#!/bin/bash

 output=$(echo "vcl.use etl-group-1" | nc varnish-smbiz.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Varnish Small Business, is now using etl-group-1 configuration."
 else
    echo "Varnish Small Business load of etl-group-1 configuration has FAILED."
 fi

