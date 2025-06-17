# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitHub Action that tests Swift packages with macros for compatibility across multiple `swift-syntax` versions. The action addresses the versioning complexity and breaking changes in `swift-syntax` that affect Swift macro development.

## Architecture

- `action.yml`: GitHub Action definition with inputs for run-tests, major-versions-only, and verbose flags
- `swift-macro-compatibility-check.sh`: Core bash script that tests against multiple `swift-syntax` versions
- The script tests against versions: 509.0.0, 509.0.1, 509.0.2, 509.1.0, 509.1.1, 510.0.0, 510.0.1, 510.0.2, 510.0.3, 600.0.0, 600.0.1
- Major versions only mode tests: 509.0.0, 510.0.0, 600.0.0

## Development Commands

### Testing the Script Locally
```bash
./swift-macro-compatibility-check.sh [--run-tests] [--major-versions-only] [--verbose]
```

### Script Workflow
The script performs these steps for each `swift-syntax` version:
1. `swift package resolve swift-syntax --version <version>` - Resolves dependencies for specific version
2. `swift build` - Builds the package
3. `swift test` (if --run-tests flag is used) - Runs tests

### Making the Script Executable
```bash
chmod +x swift-macro-compatibility-check.sh
```

## Key Implementation Details

- The action requires macOS runners due to Swift toolchain requirements
- Uses Swift 6.1 via swift-actions/setup-swift@v2
- Color-coded output: RED for failures, GREEN for success, BLUE for info, YELLOW for warnings
- Exit code 1 if any compatibility check fails
- Stores results in SUCCEEDED_VERSIONS and FAILED_VERSIONS arrays for final summary