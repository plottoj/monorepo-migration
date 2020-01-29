#!/bin/bash

MASTER_PID=$$

Error () {
    echo "Error: $1"
    kill $MASTER_PID
}

FILEPATH="$1"
[ ! -f "$FILEPATH" ] && Error "File '$FILEPATH' not found !"

# Check if origin remote exist or DIE
git remote | grep -qE "^origin$" || Error "No origin remote !"

# Read config files, remove comments and empty lines
cat "$FILEPATH" | sed -e 's/#.*//' | grep . | while IFS=';' read remote branch; do
    newBranch="$remote-$branch"
    # Check for empty parameter
    [ -z "$remote" -o -z "$branch" ] && Error "INCORRECT CONFIG for remote '$remote' and branch '$branch'"
    # Check if branch exists
    git rev-parse --verify $newBranch > /dev/null 2>&1 && Error "Branch named '$newBranch' already exists !"
done

# Re read line and do the real job !
cat "$FILEPATH" | sed -e 's/#.*//' | grep . | while IFS=';' read remote branch; do
    newBranch="$remote-$branch"
    echo "*************************************************"
    echo "***** About to create and push '$newBranch' from '$remote/$branch'"
    echo "*************************************************"
    ( git checkout -b $newBranch $remote/$branch && \
        git push origin $newBranch ) || \
        Error "Unable to create / push branch... Be brave !"
    echo
done

