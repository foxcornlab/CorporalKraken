#!/bin/sh
# CorporalKraken entrypoint: EICAR drop test + flightsim network simulation.
set -u

echo "### CorporalKraken: running EDR/AV tests ###"
echo ""
echo "### Dropping EICAR test files ###"
if ! tar xzf /tmp/eicar-files.tar.gz -C /tmp/; then
    echo "Error: could not extract the test files"
    exit 1
fi
echo "--> Done"
sleep 1

for srcfile in /tmp/*.b64; do
    [ -e "$srcfile" ] || continue
    dstfile="/tmp/$(basename "$srcfile" .b64)"
    echo ""
    echo "### Dropping $dstfile ###"
    base64 -d "$srcfile" > "$dstfile"
    rm -f "$srcfile"
    sleep 1
    if [ -s "$dstfile" ]; then
        echo "--> EICAR NOT DETECTED!"
    else
        echo "--> EICAR was successfully detected and removed!"
    fi
done

echo ""
echo "### Bad network simulation (flightsim) ###"
flightsim run
