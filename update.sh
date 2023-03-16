#!/bin/bash

# Define color variables
yellow=$(tput setaf 3)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Redirect stderr to a log file
exec 2>>/tmp/git-pull-errors.log

# store the current dir
pushd "$(pwd)" > /dev/null

# Let the person running the script know what's going on.
echo ""
echo -e "${yellow}\033[1mPulling in latest changes for all repositories...${reset}"

# Find all git repositories and update to the latest revision on the master branch
readarray -t repos < <(find . -name '.git' -type d -prune)

# change to the repository directory and pull changes
for repo in "${repos[@]}"; do
    echo ""
    echo -e "${yellow}${repo}${reset}"
    pushd "$repo" > /dev/null
    if ! git pull origin master; then
        echo "Error: git pull failed for $repo" >&2
    fi
    popd > /dev/null
done

# return to the original directory
popd > /dev/null

# Print completion message
echo ""
echo -e "${green}Complete!${reset}"
