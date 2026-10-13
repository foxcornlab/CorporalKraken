FROM alpine:3.20

LABEL org.opencontainers.image.title="CorporalKraken" \
      org.opencontainers.image.description="Defensive EDR/AV test harness: drops EICAR samples and runs flightsim network simulations" \
      org.opencontainers.image.vendor="Foxcorn Lab" \
      org.opencontainers.image.source="https://github.com/foxcornlab/CorporalKraken"

RUN apk add --no-cache ca-certificates tar bash

# flightsim v2.5.1 (alphasoc) - benign network attack simulation for testing NDR/network detection.
# https://github.com/alphasoc/flightsim
# Pinned by sha256 from the upstream release checksums.
ARG FLIGHTSIM_SHA256=e782620581e4464bded932d1248cfcad6415ab0768a143edee70bd7f80f062c8
ADD https://github.com/alphasoc/flightsim/releases/download/v2.5.1/flightsim_2.5.1_linux_amd64.tar.gz /tmp/flightsim.tar.gz
RUN echo "${FLIGHTSIM_SHA256}  /tmp/flightsim.tar.gz" | sha256sum -c - \
    && tar xzf /tmp/flightsim.tar.gz -C /usr/local/bin \
    && rm /tmp/flightsim.tar.gz \
    && test -x /usr/local/bin/flightsim

# EICAR standard antivirus test files, kept base64-encoded so they only
# materialise inside the container at runtime (never on anyone's checkout).
# Verified contents: eicar.com, eicar.com.txt, eicar_com.zip, eicarcom2.zip
RUN echo "### Staging obfuscated EICAR test files ###" && \
    echo -n "H4sIABva0lgAA+2XXXeaMBjH/Sje7xwXFOh6sYsEkh6RogESa2921Fl8LUygvnz6EbSzzp32YtOebc/vIuSVPAn8w5/RZNhfDuNFvbadJLWBqVf+PKjALO5cXLQrA728lpgNvaI1kKkbhm7UjQrSGgbSK1V0hlhOyNOsv6xWK/kgf8zyV/q90f6XImhqExzjEruVmpup3/TSda7KbqRSTyX33fm0d+c89OrXmfuYJENGXLzirf3AaOFGcef22u9TXpQJVbWWyt7IpFdnG3fhPQ1kpIUbxh1BiGApumOk37UFajEyaoVfbb6ZNR4CnwXCI2KihZKytk9Z4FsaCee+I2fzQMrbTFIZSku7CcSaNQO/2ULRt2IdBI85tqJdRLoz0Vv2tiO64zIWv6yd4R9wHOHOB1Lmj2IkLuG95z4E20O1nuWugvBgRS2G8X7deLNspzEK7MHtQE1s6eVu8MM02MI4i8sQfrmHx3OlavR0P/LzJZ7/SOm/VhwAZ9K+4i39ayf6r5tXddD/JejastOUeM4p492tPxQs6XkhjwXTEw95dqHLa4dKhyMWuNITXBiUS4e6grUlnXcD6Uix0YRftLni3gmpGDs0WgZWfJH3F/g9DvrP1tk7ff9P9d8wNAT6vwSg//+bUv9flP7fz/83rtCJ/g0T9H8Jjvx/2+rlVvRpq7G49Mull8fOwbs2c+Vdz3dmJD/561f+K/aGXPnrj/pLf72LsVgXI9G+D6bYWymfnz5bazibAAAAAAAAAAAAAAAAAAAAAAD4Z/kO5f7LBAAoAAA=" > /tmp/eicar-files.tar.gz.b64 && \
    base64 -d /tmp/eicar-files.tar.gz.b64 > /tmp/eicar-files.tar.gz && \
    rm /tmp/eicar-files.tar.gz.b64

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
