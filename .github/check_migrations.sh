#!/bin/bash

git status --porcelain

# get the new migration files (in stage)
new_migrations=($(git status --porcelain | grep -Po "(?<=migrations/)\d+_[a-z_0-9]+"))
# get all migrations (existing + new)
all_migrations=($(ls "$(git status --porcelain | grep -Po '^.*/migrations/(?=\d+_[a-z_0-9]+)' | awk 'NR == 1 {print $2}')"))

# iterate over all_migrations and remove items that are in new_migrations
existing_migrations=()

for item in "${all_migrations[@]}"; do
    # check if the item is in new_migrations
    if [[ ! " ${new_migrations[@]} " =~ " ${item} " ]]; then
        existing_migrations+=("$item")  # Add item to existing_migrations list if not in new_migrations
    fi
done

echo new: ${new_migrations[0]:0:14}
echo cur: ${existing_migrations[-1]:0:14}

# check if the oldest of the new migrations is before the latest of the existing migrations
if [[ ${new_migrations[0]:0:14} -lt ${existing_migrations[-1]:0:14} ]]; then
	echo There are new migrations with timestamp lower than the last migration in the destination branch
	exit 1
fi
