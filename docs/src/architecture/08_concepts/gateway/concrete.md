---
icon: material/hub
---

# Pseudocode
Building blocks in the form of *pseudocode*; 
Intended to make the conceptual design more concrete; not setting rules.

## Node

Restart node with new config <br />
```rust
fn restart_node(config: Config) -> Result<(), Err>{
    // graceful restart
}
```

## Config

Check if config exists <br />
All orchestration is coordinated via the DB, more specifically the config.
```rust
fn config_exists(db: DBHandler) -> Option<Config> {
    // lock db
    // if config exists { Some(config) }
    // else { None }
    // RAII drop trait -> unlock db
}
```

Node polls for config until it exists in db <br />
```rust
fn poll_config(db: DBHandler) -> Option<Config> {
    loop {
        if let Some(r) = config_exists(db) {
            return Some(r)
        }
    }
}
```

Check if config has been updated <br />
```rust
fn config_updated(db: DBHandler) -> Option<Config> {
    // lock db
    // if config updated { Some(config) }
    // else { None }
    // RAII drop trait -> unlock db
}
```

## Updates

Continually race to update database <br />
```rust
fn index_follower_data(db: DBHandler, stream: FollowerIo)-> Result<(), Err> {
        loop {
            if database_ready_to_update(db) {
                update_database(db, stream)
            }
        }
}
```

Check most recent update on cardano update table <br />
If it falls within the threshold boundary, node should update db with latest data <br />
```rust
fn database_ready_to_update(db: DBHandler) -> bool {
    // lock db
    // let last_updated = CardanoUpdateTable()
    // return update_threshold(last_updated) 
    // RAII drop trait -> unlock db
}
```

Update database with follower data <br />
```rust
fn update_database(db: DBHandler, stream: FollowerIo) -> Result<(), Err> {
    // lock db
    while let Some(block) = stream.next().await {
        let metadata = parse(block);
        db.insert(metadata);
    }
    // RAII drop trait -> unlock db
}
```

Parse block <br />
```rust
fn parse(block: Block) -> Result<MetaBlock, Err> {
    // extract era, UTXO, spent TXs and registration metadata
}
```

Calculate if threshold conditional has been met <br />
```rust
fn update_threshold(last_updated: ThresholdMetric) -> bool {
    // threshold calculation
    // define conditional
}
```



## Follower
- start follower with specified networks
- Stream blocks from given (slot,epoch)


## Syncing
Nodes race to update

## Contention

## Multiple nodes

## Roll backs