echo "vcl.use boot" | nc varnish-prime.local 6082
echo "url.purge .*" | nc varnish-prime.local 6082

