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
    git remote | grep -E "^$remote$" || Error "No remote named '$remote' !"
    git rev-parse --verify $newBranch || Error "No branch named '$newBbranch' !"
done

# Re read line and do the real job !
cat "$FILEPATH" | sed -e 's/#.*//' | grep . | while IFS=';' read remote branch; do
    newBranch="$remote-$branch"
    # Update and push updated branch
    echo "*************************************************"
    echo "***** About to update local branch '$newBranch' with upstream '$remote'"
    echo "*************************************************"
    (git fetch $remote && \
    git checkout $newBranch && \
    git merge && \
    git push origin $newBranch) || Error "Unable to update ! Exiting... Have hope !"
    echo
done
