#!/bin/bash

 output=$(echo "url.purge .*" | nc varnish-smbiz.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Small Business Varnish cache cleared."
 fi

