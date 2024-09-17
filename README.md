# Swift Macro Compatibility Check

This GitHub Action verifies compatibility of a Swift package with macros against all `swift-syntax` versions.

## Motivation

The introduction of macros in Swift 5.9 has significantly changed how many Swift libraries interact with `swift-syntax`. As pointed out by Point-Free in their article [Being a good citizen in the land of SwiftSyntax](https://www.pointfree.co/blog/posts/116-being-a-good-citizen-in-the-land-of-swiftsyntax) this change has brought about several challenges:

1. **Versioning Complexity**: `swift-syntax` uses a versioning scheme where major versions correspond to minor versions of Swift (e.g., SwiftSyntax 509.0 corresponds to Swift 5.9). This complicates dependency management.

1. **Breaking Changes**: `swift-syntax` has had breaking changes in minor releases, which causes compatibility issues.

1. **Dependency Resolution**: With more libraries using `swift-syntax` for macros, there's an increased likelihood of unresolvable dependency graphs due to multiple libraries needing different major versions of the package.

This action aims to address these challenges by:

- Ensuring your macros are compatible with multiple versions of `swift-syntax`.
- Allowing you to easily test against both major versions and all minor versions.
- Helping you catch potential compatibility issues early in your development process.

By using this action, you're taking a step towards being a **good citizen in the Swift ecosystem**, helping to prevent dependency conflicts and ensuring your library works across a range of `swift-syntax` versions.

## Usage

To use this action in your workflow, add the following step:

```yaml
- name: Run Swift Macro Compatibility Check
  uses: Matejkob/swift-macro-compatibility-check@v1
```

> [!IMPORTANT]
> Make sure to run this action on a macOS runner:

```yaml
jobs:
  check-macro-compatibility:
    runs-on: macos-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Run Swift Macro Compatibility Check
        uses: Matejkob/swift-macro-compatibility-check@v1
```

## Inputs

| Input                 | Description                                                   | Required | Default |
|-----------------------|---------------------------------------------------------------|----------|---------|
| `run-tests`           | Whether to run tests (true/false)                             | false    | false   |
| `major-versions-only` | Whether to test only against major versions (true/false)      | false    | false   |
| `verbose`             | Whether to use verbose output for Swift commands (true/false) | false    | false   |

## `swift-syntax` Versions

The action tests against the following swift-syntax versions:

- `509.0.0`
- `509.0.1`
- `509.0.2`
- `509.1.0`
- `509.1.1`
- `510.0.0`
- `510.0.1`
- `510.0.2`
- `510.0.6`
- `600.0.0` 

When `major-versions-only` is set to `true`, only versions `509.0.0`, `510.0.0`, and `600.0.0` are tested

## Examples

### Basic Usage

```yaml
name: Swift Macro Compatibility

on: [push, pull_request]

jobs:
  check-compatibility:
    runs-on: macos-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Run Swift Macro Compatibility Check
        uses: Matejkob/swift-macro-compatibility-check@v1
```

### With All Options

```yaml
name: Swift Macro Compatibility

on: [push, pull_request]

jobs:
  check-compatibility:
    runs-on: macos-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Run Swift Macro Compatibility Check
        uses: Matejkob/swift-macro-compatibility-check@v1
        with:
          run-tests: 'true'
          major-versions-only: 'false'
          verbose: 'true'
```

## Contributing

Contributions to improve the action are welcome. Please feel free to submit issues or pull requests.

## License

This GitHub Action is released under the [MIT License](LICENSE).
