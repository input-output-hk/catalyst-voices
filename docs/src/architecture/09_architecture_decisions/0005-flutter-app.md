---
    title: 0005 Catalyst Voices Frontend App Architecture
    adr:
        author: Oleksandr Prokhorenko
        created: 22-Dec-2023
        status:  proposed
    tags:
        - flutter
---

## Context

Our goal for the Catalyst Voices Frontend App is to establish a structure that ensures scalability,
maintainability, and a clear separation of concerns. With the complexity of voting events,
it’s crucial to have an architecture that supports extensive functionality and easy adaptability to change.

## Assumptions

* Clean Architecture will facilitate a clear separation of concerns across the app.
* The BLoC pattern, combined with ViewModels, will streamline state management across the app.
* Developers are or will become comfortable with reactive programming paradigms and Flutter’s Streams.
* The Flutter community will continue to support and evolve the BLoC pattern.
* The BLoC pattern will be sufficient to handle the app’s state management needs.

## Decision

We have chosen to use BLoC pattern alongside ViewModels, guided by Clean Architecture principles,
for the development of the Catalyst Voices Frontend App.
This approach will segregate the app into distinct layers - presentation, domain, and data,
with BLoC serving as the intermediary for state management and business logic.
The BLoC pattern will manage the app's state reactively,
making it easier to handle complex state dependencies and asynchronous operations.
The ViewModel layer will further aid in abstracting the presentation logic from BLoCs.

```mermaid
---
title: Catalyst Voices Fronted Architecture
---
flowchart TB
    subgraph id1 [BLoC pattern in conjunction with ViewModels steered by the principles of Clean Architecture]
      subgraph al01 [Application Layer]
      direction LR
      subgraph al02 [Presentation Layer]
      direction LR
        subgraph al03 [Connect Wallet Screen]
        w1[Widgets]
        end
        subgraph al04 [View All Events Screen]
        w2[Widgets]
        end
        subgraph al05 [Settings Screen]
        w3[Widgets]
        end
      end
      subgraph bl01 [Business Layer]
      direction LR
        subgraph bl02 [Connect Wallet Bloc]
        vm01[State <---> Event <---> ViewModel]
        end
        subgraph bl03 [View All Events Bloc]
        vm02[State <---> Event <---> ViewModel]
        end
        subgraph bl04 [Settings Bloc]
        vm03[State <---> Event <---> ViewModel]
        end
      end
      end
    subgraph dl01 [Domain Layer]
    direction RL
    subgraph dl02 [Connect Wallet Repository]
    end
    subgraph dl03 [Events Repository]
    end
    subgraph dl04 [User Repository]
    end
    end
    subgraph Data Layer
    direction RL
    subgraph dl05 [Connect Wallet API]
    end
    subgraph dl06 [Catalyst Events API]
    end
    subgraph dl07 [Local Storage]
    end
    end
    end
    al03 <--> bl02
    al04 <--> bl03
    al05 <--> bl04
    bl02 <--> dl02
    bl03 <--> dl03
    bl04 <--> dl04
    dl02 <--> dl05
    dl02 <--> dl07
    dl03 <--> dl06
    dl03 <--> dl07
    dl04 <--> dl07
```



### Practical Example



## Risks

* Learning curve associated with Clean Architecture and BLoC pattern for developers not familiar with these concepts.
* Overhead in setting up and managing BLoCs and ViewModels for simpler UI components.
* Potential for boilerplate code, impacting readability and maintainability.

## Consequences

* Enhanced maintainability and testability due to the separation of concerns.
* Greater flexibility in changing or extending the app’s features.
* Improved scalability, as new components can be added with minimal impact on existing code.
* A consistent structure across the app, aiding new developers in understanding the codebase.

## More Information

* [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
* [BLoC Pattern - DartConf 2018](https://youtu.be/PLHln7wHgPE?si=QJ8hXOCWz2WIYFye)
* [BLoC Pub Documentation](https://bloclibrary.dev/)
* [Flutter BLoC Examples](https://github.com/felangel/bloc/tree/master/examples)
* [ViewModel overview](https://developer.android.com/topic/libraries/architecture/viewmodel)
