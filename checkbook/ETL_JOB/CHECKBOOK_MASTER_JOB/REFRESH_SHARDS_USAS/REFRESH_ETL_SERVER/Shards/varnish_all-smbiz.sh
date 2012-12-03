#!/bin/bash

 output=$(echo "vcl.use boot" | nc varnish-smbiz.local 6082)
 # echo $output
 if [[ $output = *"200 0"* ]]; then
    echo "Small Business Varnish is now using default All Servers configuration."
 else
    echo "Small Business Varnish load of the default All Servers configuration has FAILED."
 fi

