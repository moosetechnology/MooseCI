#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/api.sh"

parse_user_input() {
    case "$1" in
    analyze)
        analyze_command "$@"
        ;;
    *)
        echo "Unknown command: $1"
        ;;
    esac
}