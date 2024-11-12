#!/bin/bash

set -e

usage() {
    cat << EOF
Usage: dotup [commit message]
Commit and push changes in dotfiles repository
Assume ~/dotfiles is dotfiles directory managed by git

Options:
    -h, --help  Show this help message

Example:
    dotup "Update tmux config"
EOF
    exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

DOTFILES_DIR="${HOME}/dotfiles"

if [ ! -d "${DOTFILES_DIR}" ]; then
    echo "Error: dotfiles directory ${DOTFILES_DIR} does not exist." >&2
    exit 1
fi

cd "${DOTFILES_DIR}"

if [ ! -d .git ]; then
    echo "Error: ${DOTFILES_DIR} is not a git repository" >&2
    exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to commit. Exiting"
    exit 0
fi

git add .
git commit -m "${1:-Update dotfiles}"
git push

echo "Successfully updated dotfiles changes!"
    