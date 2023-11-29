---
    title: 0003 Flutter for Catalyst Voting Frontend
    adr:
        author: Oleksandr Prokhorenko
        created: 29-Nov-2023
        status:  accepted
    tags:
        - flutter
        - dart
---

## Context

The need for a versatile and efficient framework to develop applications across multiple platforms
(Web, iOS, Android, macOS, Linux, and Windows) led us to consider various options.
Flutter emerged as the most promising solution due to its wide-ranging platform support,
single codebase feature, and robust widget library.

## Assumptions

* Flutter's capabilities extend efficiently to web and desktop platforms, in addition to mobile.
* The development team is capable of learning and adapting to Flutter and Dart for cross-platform development.
* The performance and compatibility of Flutter-built applications are adequate across all targeted platforms.

## Decision

We have decided to use Flutter as our primary framework for developing applications on Web, iOS, Android, macOS,
Linux, and Windows platforms.
This decision leverages Flutter's ability to provide a single codebase for multiple platforms,
its robust widget library, and its growing support for desktop and web applications.

## Risks

* Potential complications in accessing some native features and hardware-specific functionalities on each platform.
* The need for additional testing across different platforms to ensure consistency and performance.
* Flutter's desktop and web support is less mature than its mobile support, which might lead to unforeseen challenges.

## Consequences

* Streamlined development process with a unified codebase, reducing development and maintenance costs.
* Increased ability to rapidly deploy updates and new features across all platforms simultaneously.
* Dependency on a single technology stack, which may pose challenges if Flutter does not evolve as expected.

## More Information

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [Build more with Flutter](https://flutter.dev/development)
* [Flutter apps in production](https://flutter.dev/showcase)
* [A strong ecosystem, powered by open source](https://flutter.dev/ecosystem)
* [Flutter’s roadmap](https://github.com/flutter/flutter/wiki/Roadmap)
