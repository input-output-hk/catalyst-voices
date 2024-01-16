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
        State periodic{
        [*] --> CheckDB: check for recent updates
        CheckDB --> Locked
        Locked --> CheckDB
        CheckDB --> Unlocked: if stale, update
        Unlocked --> Lock
        Lock --> UpdateDB
        UpdateDB --> Unlocked: RAII unlock
        }

        State Periodic{
        [*] --> checkConfig: check if the Node Config has changed
        checkConfig --> updated
        checkConfig --> noChange
        noChange --> checkConfig
        updated --> restart:  stop all followers cleanly
        restart --> checkConfig: Restart them with the new config
        
        }  
    }
    state !Config {
        [*] --> Sleep
        Sleep --> CheckConfig
        CheckConfig --> Sleep
        CheckConfig --> ConfigExists
        ConfigExists --> [*]: transition to config logic        
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