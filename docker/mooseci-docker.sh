#!/usr/bin/env bash

cd /src 2>/dev/null || true

/pharo --headless /Moose13/Moose13.image --no-default-preferences clap moose-ci "$@"
