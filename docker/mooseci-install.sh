#!/usr/bin/env bash
set -e

echo "Installing MooseCI package in the image..."
./pharo --headless Moose13/Moose13.image eval --save "Metacello new baseline: 'MooseCI'; repository: 'github://moosetechnology/MooseCI:master/src'; load."

echo "Installing Pharo TreeSitter python in the image..."

./pharo --headless Moose13/Moose13.image eval --save "Metacello new baseline: 'TreeSitter'; repository: 'github://Evref-BL/Pharo-Tree-Sitter:main/src'; load: #( 'TreeSitter' 'TreeSitter-Libraries' 'TreeSitter-Python' )."
