#!/bin/bash
set -euo pipefail
EXIT_CODE=0

#test config
#cp tools/ci/ci_config.txt config.txt

DreamDaemon spacestation13.dmb -close -trusted -verbose
