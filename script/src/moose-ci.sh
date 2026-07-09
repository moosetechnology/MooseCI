#!/usr/bin/env bash
# set -x
#load config
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"


analyze(){
    if [ -z "$2" ]; then
        echo "Error: No project path provided for analysis."
        return 1
    fi

    local project_path=$(realpath "$2")
    $PHARO_VM_13_DIR/Pharo --headless $MOOSE_CI_IMAGE_PATH eval "MooseCIRunner analyze: '$project_path'"
}
