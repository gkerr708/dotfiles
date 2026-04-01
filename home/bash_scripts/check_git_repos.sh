#!/bin/bash

# Directories to search
dirs=("$HOME/lab" "$HOME/lab/docs")

# Parse command line arguments
auto_pull=false
auto_push=false

for arg in "$@"; do
    case $arg in
        --pull)
            auto_pull=true
            ;;
        --push)
            auto_push=true
            ;;
        --sync)
            auto_pull=true
            auto_push=true
            ;;
    esac
done

# Function to prompt the user for confirmation
prompt_user() {
    local message=$1
    while true; do
        read -r -p "$message (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to check if a repository has untracked changes
check_untracked_changes() {
    if [ -n "$(git status --porcelain)" ]; then
        echo "Untracked or uncommitted changes found in: $1"
        return 0
    fi
    return 1
}

# Function to check if a repository is up to date
check_repo_status() {
    local repo_dir=$1
    cd "$repo_dir" || return

    # Check if the directory is a valid Git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not a Git repository: $repo_dir"
        return
    fi

    git fetch --quiet
    local local_rev
    local remote_rev
    local base_rev

    local_rev=$(git rev-parse @)
    remote_rev=$(git rev-parse @{u})
    base_rev=$(git merge-base @ @{u})

    # Check if the local repository is behind the remote
    if [ "$local_rev" = "$base_rev" ] && [ "$local_rev" != "$remote_rev" ]; then
        echo "Local repository is behind the remote: $repo_dir"
		if [ "$auto_pull" = false ]; then
			echo "Need to pull: $repo_dir"
			return
        elif prompt_user "Do you want to pull changes for $repo_dir?"; then
            git pull --quiet
            echo "Pulled: $repo_dir"
	        local_rev=$(git rev-parse @)
	        remote_rev=$(git rev-parse @{u})
	        base_rev=$(git merge-base @ @{u})
        else
            echo "Skipping pull. Please resolve manually before committing."
            return
        fi
    fi

	# Check for untracked or uncommitted changes
	if check_untracked_changes "$repo_dir"; then
	    if [ "$auto_push" = false ]; then
	        #echo "Untracked changes: $repo_dir"
	        return
	    elif prompt_user "Do you want to commit changes for $repo_dir?"; then
	        git add .
	        git commit -m "auto commit"
	        # Recheck the status after committing changes
	        local_rev=$(git rev-parse @)
	        remote_rev=$(git rev-parse @{u})
	        base_rev=$(git merge-base @ @{u})
	
	        # After commit, if the local branch is ahead, prompt to push
	        if [ "$local_rev" != "$remote_rev" ]; then
	            echo "Need to push: $repo_dir"
	            if prompt_user "Do you want to push changes for $repo_dir?"; then
	                git push --quiet
	                echo "Pushed: $repo_dir"
	                return  # Skip further checks after a successful push
	            fi
	        fi
	    fi
	fi

    if [ "$local_rev" = "$remote_rev" ]; then
        echo "Up to date: $repo_dir"
    elif [ "$local_rev" = "$base_rev" ]; then
        echo "Need to pull: $repo_dir"
        if [ "$auto_pull" = true ]; then
            if prompt_user "Do you want to pull changes for $repo_dir?"; then
                git pull --quiet
                echo "Pulled: $repo_dir"
            fi
        fi
    elif [ "$remote_rev" = "$base_rev" ]; then
        echo "Need to push: $repo_dir"
        if [ "$auto_push" = true ]; then
            if prompt_user "Do you want to push changes for $repo_dir?"; then
                git push --quiet
                echo "Pushed: $repo_dir"
                return  # Skip further checks after a successful push
            fi
        fi
    else
        echo "Diverged: $repo_dir"
    fi
}

# Loop through the directories and check for git repositories
for dir in "${dirs[@]}"; do
    for subdir in "$dir"/*/; do
        if [ -d "$subdir/.git" ]; then
            check_repo_status "$subdir"
        fi
    done
done
