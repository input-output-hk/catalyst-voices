---
icon: material/telescope
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
        [*] --> CheckDB
        CheckDB --> Locked
        Locked --> CheckDB
        CheckDB --> Unlocked
        Unlocked --> Lock
        Lock --> UpdateDB
        UpdateDB --> Unlocked
       
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


## Follower
- start follower with specified networks
- Stream blocks from given (slot,epoch)



## Process blocks

- As each block is received.
- Parse the block for its era.
- Read UTXO from each transaction.
- Read spent TX from each transaction.
- Check metadata for catalyst registrations.


## Syncing

## Contention

## Multiple nodes

## Roll backs