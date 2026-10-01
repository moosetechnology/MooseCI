#!/usr/bin/env bash
set -e

# The group of the MooseCI baseline to install (default, python, all, ...)
GROUP="${1:-default}"

echo "Installing MooseCI ($GROUP group) in the image..."
./pharo --headless Moose13/Moose13.image eval --save "Metacello new baseline: 'MooseCI'; repository: 'github://moosetechnology/MooseCI:master/src'; load: #('$GROUP')."
