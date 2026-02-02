#!/bin/bash

DOCKERFILE="./Dockerfile"
OUTPUT="out"

# Build the Docker image
DOCKER_BUILDKIT=1 docker build --no-cache \
    --file "$DOCKERFILE" \
    --output "$OUTPUT" .

echo "Build completed. Output: $OUTPUT"