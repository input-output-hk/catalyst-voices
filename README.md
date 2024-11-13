# Catalyst Voices

<!-- markdownlint-disable MD029 -->

Welcome to the Catalyst Voices mono repo, where we manage and maintain the interconnected projects.

- [Catalyst Voices](#catalyst-voices)
  - [Overview](#overview)
  - [Getting Started](#getting-started)
  - [Projects](#projects)
    - [Athena](#athena)
    - [Catalyst Voices](#catalyst-voices-1)
    - [Catalyst Data Gateway](#catalyst-data-gateway)
    - [Catalyst Voices Packages](#catalyst-voices-packages)
  - [Development](#development)
    - [Code Generation](#code-generation)
  - [Contributing](#contributing)
  - [License](#license)

## Overview

This monorepo serves as a unified codebase for the Catalyst Voices ecosystem projects.
Using a monorepo simplifies our dependency management, streamlines testing, and fosters code
sharing.

## Getting Started

1. Clone this repository:

```sh
git clone https://github.com/input-output-hk/catalyst-voices.git
cd catalyst-voices
```

2. Navigate to individual project folders and follow their respective setup instructions.

## Projects

### Athena

Athena is our [brief description of what Athena does].

* **Directory:** [athena](https://github.com/input-output-hk/catalyst-voices/tree/main/athena)
* **Setup:** Navigate to ./athena.
* **Documentation:** [Link to detailed documentation or Wiki]

### Catalyst Voices

Catalyst Voices frontend.

* **Directory
  **: [catalyst_voices](https://github.com/input-output-hk/catalyst-voices/tree/main/catalyst_voices)
* **Setup**: Navigate to ./catalyst_voices.
* **Documentation**: [Link to detailed documentation or Wiki]

### Catalyst Data Gateway

The backend services for Catalyst Voices.

* **Directory
  **: [catalyst-voices-backend](https://github.com/input-output-hk/catalyst-voices/tree/main/catalyst-gateway)
* **Setup**: Navigate to ./catalyst-gateway.
* **Documentation**: [Link to detailed documentation or Wiki]

### Catalyst Voices Packages

Shared Flutter and Dart packages used across the Catalyst.

* **Directory
  **: [catalyst_voices_libs](https://github.com/input-output-hk/catalyst-voices/tree/main/catalyst_voices/packages/libs)
* **Setup**: Navigate to ./catalyst_voices/packages/libs.
* **Documentation**: [Link to detailed documentation or Wiki]

## Development

For development guidelines, tooling information, and best practices,
visit [Catalyst Engineering](https://github.com/input-output-hk/catalyst-engineering)
and [Catalyst CI](https://input-output-hk.github.io/catalyst-ci/).

### Code Generation

In some sections of the code we use code generation to generate code from OpenAPI specifications, localization files, assets, routes, etc.

To generate code run in root directory:

```sh
earthly ./catalyst_voices+code-generator 
```

To save generated code locally run in root directory:

```sh
earthly ./catalyst_voices+code-generator --save_locally=true
```

Keep in mind that You will need GITHUB_TOKEN to be able to run this earthly target.
In root directory there is a template file `.secret.template` save it as `.secret` and fill in the GITHUB_TOKEN. This file should be ignored by git, but make sure to not commit it.

## Contributing

We welcome contributions from the community!
Please read our [CONTRIBUTING](CONTRIBUTING.md) for guidelines on how to contribute.

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT license](LICENSE-MIT)
at your option.

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this crate by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
