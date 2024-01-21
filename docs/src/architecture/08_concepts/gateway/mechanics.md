---
icon: material/airplane-cog
---

## Mechanics

Rough napkin sketch: still iterating on final design

```mermaid
  stateDiagram-v2
    state if_state <<choice>>
    Node -->if_state
    if_state --> Config : config exists
    if_state --> Node: config does not exist


    note right of Config
            Indexing blockchain data provided by follower
        end note

    
    note left of Config
            checkConfig = thread A
        end note

    
    note right of Config
            checkDB = thread B
        end note

    
    note right of Node
            Orchestration is coordinated via the config
        end note

    state Node {
        init --> init: try until config exists
    }

    state Follower {
        [*]
    }

    state Config {
        checkConfig-->Database: release
        Database-->checkConfig: wait

        checkDB-->Database: release
        Database-->checkDB: wait

        State checkConfig{
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
```