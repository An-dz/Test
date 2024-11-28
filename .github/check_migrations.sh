#!/bin/bash

# Define the two lists (arrays)
all_migrations=($(ls prisma/migrations))
new_migrations=($(/c/Program\ Files/Sublime\ Merge/Git/cmd/git.exe status --porcelain | grep -Po "(?<=migrations/)\d+_[a-z_0-9]+"))

# Iterate over list1 and remove items that are in list2
current_migrations=()

for item in "${all_migrations[@]}"; do
    # Check if the item is in list2
    if [[ ! " ${new_migrations[@]} " =~ " ${item} " ]]; then
        current_migrations+=("$item")  # Add item to the current_migrations list if not in list2
    fi
done

if [[ ${new_migrations[0]:0:14} -lt ${current_migrations[-1]:0:14} ]]; then
	exit 1
fi
