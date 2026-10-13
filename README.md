<p align="center">
<h2 align="center">CorporalKraken</h2>
</p>

<p align="center">
<a href="https://github.com/foxcornlab/CorporalKraken/actions"><img src="https://img.shields.io/badge/Docker-build-blue.svg"></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg"></a>
<img src="https://img.shields.io/badge/Tests-EICAR%20%2B%20flightsim-orange.svg">
</p>

CorporalKraken is a defensive test harness in a Docker container. Run it on a host or cluster and it exercises your defences the way an auditor would: drops `EICAR` standard antivirus test files to check on-access AV, then runs `flightsim` network simulations to check NDR / network detection. Nothing here is malware. The `EICAR` strings are the industry-standard harmless test files, and `flightsim` generates benign simulated attack traffic.

Use it to validate *your own* EDR / AV / NDR stack, tune detections, and prove controls work.

# `What it tests`

* `AV` - drops `eicar.com`, `eicar.com.txt`, `eicar_com.zip`, `eicarcom2.zip` (base64-encoded, only materialise inside the container) and reports whether each was detected and removed
* `Network` - runs [flightsim](https://github.com/alphasoc/flightsim) (`v2.5.1`, sha256-pinned) to simulate malicious network patterns: DNS tunnelling, DGA, suspicious user-agents

# `Run`

```bash
docker build -t corporalkraken:latest .
docker run --rm corporalkraken:latest
```

Watch the output: `EICAR was successfully detected and removed` means your AV is doing its job. `EICAR NOT DETECTED` means you have a gap to fix.

# `How it works`

1. Build stage fetches `flightsim` from the upstream release and verifies the sha256 checksum before installing it
2. `EICAR` test files ship base64-encoded in the image so they never sit on anyone's checkout tripping their own AV
3. `entrypoint.sh` extracts the samples, decodes each one, checks survival, then hands off to `flightsim run`

# `Thanks to`

* `EICAR` - for the standardised test files every AV vendor honours
* `alphasoc` - for `flightsim`, the network simulation toolkit

# `Disclaimer`

For testing your own systems and authorised assessments only. Pointing this at infrastructure you do not own or have written permission to test is not authorised use.

> Research by `Vineeth Kumar` (`foxcornlab`). Found a bug or want a feature, open an `issue`.
