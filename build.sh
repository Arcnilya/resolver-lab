#!/bin/bash

# Check for required arguments
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <resolver> <version>"
  echo "Example: $0 unbound 1.23.0"
  exit 1
fi

resolver="$1"
version="$2"

# Helper function to compare versions
version_le() {
  # Returns 0 (true) if $1 <= $2
  [ "$(printf '%s\n%s' "$1" "$2" | sort -V | head -n1)" = "$1" ]
}

# Default build args
build_args="--build-arg VERSION=$version"
dockerfile="Dockerfile"

# Conditional build logic
if [[ "$resolver" == "unbound" ]] && version_le "$version" "1.8.0"; then
  dockerfile="oldDockerfile"
elif [[ "$resolver" == "bind" ]] && version_le "$version" "9.14.0"; then
  dockerfile="oldDockerfile"
elif [[ "$resolver" == "knot" ]] && version_le "$version" "3.0.0"; then
  dockerfile="oldDockerfile"
elif [[ "$resolver" == "powerdns" ]] && version_le "$version" "5.0.0"; then
  dockerfile="oldDockerfile"
fi

# Final docker build command
docker build -t resolver-lab/$resolver:$version $build_args -f "$resolver/$dockerfile" $resolver

