#!/bin/bash

# Swift Macro Compatibility Check Script
# Usage:
# ./swift-macro-compatibility-check.sh [--run-tests] [--major-versions-only] [--verbose]

# Default input values
RUN_TESTS=false
MAJOR_VERSIONS_ONLY=false
VERBOSE=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --run-tests) RUN_TESTS=true ;;
        --major-versions-only) MAJOR_VERSIONS_ONLY=true ;;
        --verbose) VERBOSE=true ;;
        *) echo "Unknown parameter: $1" ;;
    esac
    shift
done

# List of all swift-syntax versions
ALL_VERSIONS=(
  "509.0.0"
  "509.0.1"
  "509.0.2"
  "509.1.0"
  "509.1.1"
  "510.0.0"
  "510.0.1"
  "510.0.2"
  "510.0.3"
  "600.0.0"
)

# List of major swift-syntax versions
MAJOR_VERSIONS=(
  "509.0.0"
  "510.0.0"
  "600.0.0"
)

# Choose which versions to use based on input
if [ "$MAJOR_VERSIONS_ONLY" = true ]; then
  VERSIONS=("${MAJOR_VERSIONS[@]}")
else
  VERSIONS=("${ALL_VERSIONS[@]}")
fi

# Set verbosity flag
VERBOSE_FLAG=""
if [ "$VERBOSE" = true ]; then
  VERBOSE_FLAG="-v"
fi

# Resolve package dependencies
swift package resolve

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Arrays to store results
SUCCEEDED_VERSIONS=()
FAILED_VERSIONS=()

# Function to create a box around text
function print_boxed_text() {
  local text="$1"
  local text_length=${#text}
  local border=$(printf '%*s' "$((text_length + 4))" | tr ' ' '-')

  echo -e "${BLUE}$border${NC}"
  echo -e "${BLUE}| ${NC}${BLUE}$text${NC} ${BLUE}|${NC}"
  echo -e "${BLUE}$border${NC}"
}

# Loop over each SwiftSyntax version and check compatibility
for version in "${VERSIONS[@]}"; do
  print_boxed_text "Checking compatibility with swift-syntax version $version"
  
  # Explain the resolve process
  echo -e "${BLUE}Resolving swift-syntax version $version and updating dependencies...${NC}"
  if swift package resolve swift-syntax --version "$version"; then
    echo -e "${GREEN}Resolved swift-syntax version $version successfully${NC}"
  else
    echo -e "${RED}Failed to resolve swift-syntax version $version${NC}"
    FAILED_VERSIONS+=("$version (Resolve Failed)")
    continue
  fi

  # Build the package
  echo -e "${BLUE}Building package with swift-syntax $version${NC}"
  if swift build $VERBOSE_FLAG; then
    echo -e "${GREEN}Build succeeded for swift-syntax $version${NC}"
    
    # Run tests if specified
    if [ "$RUN_TESTS" = true ]; then
      echo -e "${BLUE}Running tests with swift-syntax $version${NC}"
      if swift test $VERBOSE_FLAG; then
        echo -e "${GREEN}Tests passed for swift-syntax $version${NC}"
        SUCCEEDED_VERSIONS+=("$version")
      else
        echo -e "${RED}Tests failed for swift-syntax $version${NC}"
        FAILED_VERSIONS+=("$version (Tests Failed)")
      fi
    else
      echo -e "${YELLOW}Skipping tests as per configuration${NC}"
      SUCCEEDED_VERSIONS+=("$version")
    fi
  else
    echo -e "${RED}Build failed for swift-syntax $version${NC}"
    FAILED_VERSIONS+=("$version (Build Failed)")
  fi

  # Conditional success/failure message
  if [[ " ${SUCCEEDED_VERSIONS[@]} " =~ " ${version} " ]]; then
    echo -e "${GREEN}Compatibility check complete for swift-syntax $version${NC}"
  else
    echo -e "${RED}Compatibility check failed for swift-syntax $version${NC}"
  fi
done

# Summary of results
print_boxed_text "Compatibility Check Summary"

if [ ${#SUCCEEDED_VERSIONS[@]} -ne 0 ]; then
  echo -e "${GREEN}Succeeded for versions:${NC}"
  for v in "${SUCCEEDED_VERSIONS[@]}"; do
    echo -e "${GREEN}  - $v${NC}"
  done
else
  echo -e "${RED}No versions succeeded${NC}"
fi

if [ ${#FAILED_VERSIONS[@]} -ne 0 ]; then
  echo -e "${RED}Failed for versions:${NC}"
  for v in "${FAILED_VERSIONS[@]}"; do
    echo -e "${RED}  - $v${NC}"
  done
else
  echo -e "${GREEN}No versions failed${NC}"
fi
