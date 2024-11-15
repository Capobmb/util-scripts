#!/bin/bash

set -e

usage() {
    cat << EOF
Usage: dotup "{commit message}"
Commit and push changes in dotfiles repository
Assume ~/dotfiles is dotfiles directory managed by git

Options:
    -h, --help      Show this help message
    -d, --dry-run   Dry run

Example:
    dotup "Update tmux config"
    dotup --dry-run
EOF
    exit 0
}

DRY_RUN=0
while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -d|--dry-run)
            DRY_RUN=1
            shift
            ;;
        *)
            COMMIT_MSG="$@"
            break
            ;;
    esac
done

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
    echo "No changes to commit. Exiting."
    exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry run: changes to be commited:"
    echo "--------------------------------"
    git --no-pager diff
    exit 0
fi

if [ -z "${COMMIT_MSG}" ]; then
    echo "input commit message: [message][return]"
    read COMMIT_MSG
fi

echo "Commit message: ${COMMIT_MSG}"

git add .
git commit -m "${COMMIT_MSG}"
git push

echo "Successfully updated dotfiles changes!"

