#!/bin/bash

# Repo directory location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Handle symlinking
create_symlink() {
    source_path=$1
    target_path=$2

    # Expand '~' if necessary
    target_path=$(eval echo "$target_path")

    # Remove target in case it alrady exists
    sudo rm -rf "$target_path"

    # Ensure its parent directory exists
    sudo mkdir -p "$(dirname "$target_path")"

    # Create the symlink
    sudo ln -s "$source_path" "$target_path"
    echo "Symlinked $source_path to $target_path"
}

# Iterate through directories and files
SYMLINK_MAP="$SCRIPT_DIR/symlink_map.txt"
while read -r source_path target_dir; do
    create_symlink "$REPO_ROOT/$source_path" "$target_dir"
done < "$SYMLINK_MAP"
