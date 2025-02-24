#!/bin/bash

# Function to find and replace the relative path with the full path in the file
find . -type f -name "*.coverage.info" | while read file; do
    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo "File does not exist: $file"
        continue
    fi

    # Loop through each SF line in the file
    while IFS= read -r line; do
        if [[ "$line" =~ ^SF: ]]; then
            # Extract the relative SF path
            file_path=$(echo "$line" | cut -d: -f2- | xargs | rev | cut -d/ -f1,2 | rev)

            # Ensure the relative path was found
            if [[ -z "$file_path" ]]; then
                echo "Error: Empty SF path found in $file"
                continue
            fi

            relative_path=$(find . -path "*$file_path" | sed 's|^\./||')

            if [[ -z "$relative_path" ]]; then
                echo "No file found for relative path: $file_path"
                continue
            fi
            echo "relative_path: $relative_path"
            # Replace the relative SF path with the full path in the file
            sed -i "s|$line|SF:$relative_path|" "$file"
            echo "Updated SF path in file: $file"
        fi
    done < "$file"
done
