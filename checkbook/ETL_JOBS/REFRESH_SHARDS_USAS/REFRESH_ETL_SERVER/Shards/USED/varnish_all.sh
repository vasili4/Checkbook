#!/bin/bash

 output=$(echo "vcl.use boot" | nc varnish-prime.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Varnish is now using default All Servers configuration."
 else
    echo "Varnish load of the default All Servers configuration has FAILED."
 fi
