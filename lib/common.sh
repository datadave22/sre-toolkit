#!/bin/bash
# Common Bash utilities for system inspection and file searches
# Author: Dave
# Date: 2026-01-06

# Exit on errors, undefined variables, and pipe failures
set -euo pipefail

# --------------------------
# Logging Helpers
# --------------------------

log_info() {
    echo -e "[INFO] $*"
}

log_warn() {
    echo -e "[WARN] $*" >&2
}

log_error() {
    echo -e "[ERROR] $*" >&2
}

# --------------------------
# Find Helpers
# --------------------------

# Find files by size
# Usage: find_by_size <directory> <size>
# Example: find_by_size /var/log +100M
find_by_size() {
    local dir=${1:-.}
    local size=${2:-+0k}
    log_info "Searching in '$dir' for files with size '$size'"
    find "$dir" -type f -size "$size" -ls
}

# Find files by owner
# Usage: find_by_owner <directory> <owner>
find_by_owner() {
    local dir=${1:-.}
    local owner=${2:?Specify owner}
    log_info "Searching in '$dir' for files owned by '$owner'"
    find "$dir" -type f -user "$owner" -ls
}

# Find files by group
# Usage: find_by_group <directory> <group>
find_by_group() {
    local dir=${1:-.}
    local group=${2:?Specify group}
    log_info "Searching in '$dir' for files belonging to group '$group'"
    find "$dir" -type f -group "$group" -ls
}

# Find files by type
# Usage: find_by_type <directory> <type>
# Type: f=file, d=directory, l=symlink
find_by_type() {
    local dir=${1:-.}
    local type=${2:?Specify type (f/d/l)}
    log_info "Searching in '$dir' for type '$type'"
    find "$dir" -type "$type" -ls
}

# Find executable files
# Usage: find_executables <directory>
find_executables() {
    local dir=${1:-.}
    log_info "Searching for executable files in '$dir'"
    find "$dir" -type f -executable -ls
}

# --------------------------
# System Info Helpers
# --------------------------

# Show disk usage by directory sorted descending
disk_usage() {
    local dir=${1:-.}
    log_info "Disk usage of '$dir':"
    du -h "$dir" 2>/dev/null | sort -hr | head -n 20
}

# Show largest files system-wide
largest_files() {
    local dir=${1:-/}
    local count=${2:-20}
    log_info "Top $count largest files in '$dir':"
    find "$dir" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n "$count"
}

# Check free disk space
disk_free() {
    log_info "Disk free space:"
    df -h
}

# --------------------------
# Misc Utilities
# --------------------------

# Confirm script is run as root
require_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Timestamp helper
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

