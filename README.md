# Tomono
## Tomono configuration
Tomono configuration is ';' separated :
```sh
<REMOTE URL> ; <REMOTE NAME> ; [<DIR NAME>] ; <BRANCHS LIST>
```
- REMOTE URL is mandatory
- REMOTE NAME is mandatory
- DIR NAME is optionnal, only supply it if it's different from REMOTE_NAME
- BRANCHS LIST is optionnal, if it's empty all branches will created on monorepo. If specified (space separated), only thoses branchs will be migrated on monorepo.

## Tomono execution
```sh
cp *.sh *.txt <ANOTHER FOLDER NOT UNDER GIT CONTROL>
cd <ANOTHER FOLDER NOT UNDER GIT CONTROL>;
vi repos.txt
cat repos.txt | ./tomono.sh
```

If Monorepo already exist and you want to add another repository, just add '--continue' option :
```sh
cat repos.txt | ./tomono.sh --continue
```

Now, you have a core folder inside your current folder.
Go inside, you will find your monorepo.



# Scripts
## subtreeMergeRemoteBranchs
This script merge with subtree strategy all required branchs to develop monorepo branch

### Configuration
```sh
<REMOTE NAME> ; <BRANCH NAME>
```

### Execution
```sh
vi subtreeBranchs.txt
cd core;
../subtreeMergeRemoteBranchs.sh ../subtreeBranchs.txt
```

## createMonoBranchsFromAllRemotes
This script create local branch pointing to remote (non monorepo) and push them in monorepo

### Configuration
```sh
<REMOTE NAME> ; <BRANCH NAME>
```

### Execution
```sh
vi remoteBranchs.txt
cd core;
../createMonoBranchsFromAllRemotes.sh ../remoteBranchs.txt
```

## syncAllRemoteNonMonoBranchs
This script update local branch pointing to remote (non monorepo) and push them in monorepo

### Configuration
```sh
<REMOTE NAME> ; <BRANCH NAME>
```

### Execution
```sh
vi remoteBranchs.txt
cd core;
../syncAllRemoteNonMonoBranchs.sh ../remoteBranchs.txt
```


# Graphs
If you want to update graphs :
```sh
cd gitgraphs;
npm install
```