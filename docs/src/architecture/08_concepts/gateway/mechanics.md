---
icon: material/airplane-cog
---

## Mechanics

```mermaid
  stateDiagram-v2
    state if_state <<choice>>
    [*] --> Node
    Node -->if_state
    if_state --> NoConfig: config does not exist
    if_state --> Config : config exists

    note right of NoConfig
            Orchestration is coordinated via the config
        end note
    
    note right of Config
            Indexing blockchain data provided by follower
        end note

    state Node {
        [*] --> init
        init --> [*]
    }

    state Follower {
        [*]  
    }

    state Config {
        checkConfigFromDB-->Database: release
        Database-->checkConfigFromDB: wait

        checkDB-->Database: release
        Database-->checkDB: wait

        State checkConfigFromDB{
            Tick --> Updated
            Tick --> NoChange: 
            Updated --> Restart: stop all followers cleanly
            Restart --> Tick: Restart with new config
            NoChange--> Tick
        }
        State checkDB{
            tick --> UpdateThreshold
            UpdateThreshold --> tick: data is fresh
            UpdateThreshold--> Follower: data is stale
            updatedb --> tick
            updatedb-->Follower
            Follower -->updatedb
        }
        state Database{
            Unlocked --> Locked
            Locked--> Unlocked
        }
    }
    state NoConfig {
        checkConfg-->database: release
        database--> checkConfg: wait   

        state checkConfg{
            ticker--> configNotPresent
            configNotPresent-->ticker
            ticker-->configExists
            configExists-->[*]: transition to config logic
        }  

        state database{
            unlocked --> locked
            locked--> unlocked
        }   
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