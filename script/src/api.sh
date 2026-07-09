#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/moose-ci.sh"

analyze_command() {
    analyze "$@"
}

# eval_st_script {
# }
