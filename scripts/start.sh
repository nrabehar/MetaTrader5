#!/bin/bash

# Source common variables and functions
source /scripts/common.sh

# Run installation scripts
install_mono.sh
install_mt5.sh

# Keep the script running
tail -f /dev/null