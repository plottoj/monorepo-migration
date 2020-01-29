#!/bin/bash

MASTER_PID=$$

Error () {
    echo "Error: $1"
    kill $MASTER_PID
}

# Check if config file exist
FILEPATH="$1"
[ ! -f "$FILEPATH" ] && Error "File '$FILEPATH' not found !"

# Checkout to develop branch of monorepo or DIE
git checkout develop || Error "Unable to checkout develop"

# Read config files, remove comments and empty lines
cat "$FILEPATH" | sed -e 's/#.*//' | grep . | while IFS=';' read remote branch; do
    # Check for empty parameter
    [ -z "$remote" -o -z "$branch" ] && Error "INCORRECT CONFIG for remote '$remote' and branch '$branch'"
    git remote | grep -qE "^$remote$" || Error "No remote named '$remote' !"
    git rev-parse --verify $remote/$branch > /dev/null 2>&1 || Error "No branch named '$remote/$branch' !"
done

# Re read line and do the real job !
cat "$FILEPATH" | sed -e 's/#.*//' | grep . | while IFS=';' read remote branch; do
    echo "*************************************************"
    echo "***** About to subtree merge $remote/$branch"
    echo "*************************************************"
    # All this scripts to just run one line.... :-D
    git merge -X subtree=$remote/ $remote/$branch || Error "Unable to merge ! Exiting... Good day !"
    echo
done
