#!/bin/bash

 output=$(echo "url.purge .*" | nc varnish-prime.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Varnish cache cleared."
 fi
