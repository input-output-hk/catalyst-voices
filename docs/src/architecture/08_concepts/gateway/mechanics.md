---
icon: material/airplane-cog
---

## Mechanics

```mermaid
  stateDiagram-v2
    state if_state <<choice>>
    [*] --> Node
    Node -->if_state
    if_state --> !Config: config does not exist
    if_state --> Config : config exists


    note right of !Config
            Orchestration is coordinated via the config
        end note

    state Node {
        [*] --> init
        init --> [*]
    }
    state Config {
        
        State Update{
        [*] --> CheckDB
        CheckDB --> Locked
        Locked --> CheckDB
        CheckDB --> Unlocked
        Unlocked --> UpdateDB
        Lock --> CheckDB
        UpdateDB --> Lock
        }

        State Updates{
        [*] --> CheckConfigB
        CheckConfigB --> LockedConfig
        LockedConfig --> CheckConfigB
        CheckConfigB --> UnlockedConfig
        UnlockedConfig --> UpdateConfig
        LockConfig --> CheckConfigB
        UpdateConfig --> LockConfig
        }
       
    }

    state !Config {
        [*] --> Sleep
        Sleep --> CheckConfig
        CheckConfig --> Sleep
        CheckConfig --> ConfigExists
        ConfigExists --> [*]        
    }
```

## Bootstrap


- cli
- specified networks 

## Config 
- check if config exists or in use

## Obtain network metadata

- specified network (slot epoch)

## Syncing

## Contention

## Multiple nodes

## Roll backs