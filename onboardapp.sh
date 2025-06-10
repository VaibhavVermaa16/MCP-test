#!/bin/bash

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <app-name> <app-owner> <app-repository>"
    exit 1
fi

APP_NAME=$1
APP_OWNER=$2
APP_REPOSITORY=$3
APP_DIR="apps/$APP_NAME"

# Create app directory
if [ -d "$APP_DIR" ]; then
    echo "Error: Application '$APP_NAME' already exists at '$APP_DIR'."
    exit 1
fi
mkdir -p "$APP_DIR"
echo "Created directory: $APP_DIR"

# Update applications.yaml
# Using a simple append for this example. A more robust solution might use yq or another YAML parser.
echo "
- name: \"$APP_NAME\"
  owner: \"$APP_OWNER\"
  repository: \"$APP_REPOSITORY\"" >> applications.yaml
echo "Updated applications.yaml"

# Create app-specific files from templates
for template in templates/*; do
    filename=$(basename "$template" | sed 's/\.template$//' | sed 's/app_//')
    target_file="$APP_DIR/$filename"

    sed -e "s/{{APP_NAME}}/$APP_NAME/g" \
        -e "s/{{APP_OWNER}}/$APP_OWNER/g" \
        -e "s/{{APP_REPOSITORY}}/$APP_REPOSITORY/g" \
        "$template" > "$target_file"

    echo "Created $target_file"
done

echo "Application '$APP_NAME' onboarded successfully!"