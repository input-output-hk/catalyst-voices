---
icon: material/hub
---

# Pseudo code

Building blocks in the form of *pseudo code*;
Intended to make the conceptual design more concrete; not setting rules.

## Node

Restart node with new config

```rust
fn restart_node(config: Config) -> Result<(), Err>{
    // graceful restart
}
```

## Config

Check if config exists; all orchestration is coordinated via the DB, more specifically the config.

```rust
fn config_exists(db: DBHandler) -> Option<Config> {
    // lock db
    // if config exists { Some(config) }
    // else { None }
    // Resource acquisition is initialization: drop trait -> unlock db
}
```

Node polls for config until it exists in database

```rust
fn poll_config(db: DBHandler) -> Option<Config> {
    loop {
        if let Some(r) = config_exists(db) {
            return Some(r)
        }
    }
}
```

Check if config has been updated

```rust
fn config_updated(db: DBHandler) -> Option<Config> {
    // lock db
    // if config updated { Some(config) }
    // else { None }
    // Resource acquisition is initialization: drop trait -> unlock db
}
```

## Updates

Continually race to update database

```rust
fn index_follower_data(db: DBHandler, stream: FollowerIo)-> Result<(), Err> {
        loop {
            if database_ready_to_update(db) {
                update_database(db, stream)
            }
        }
}
```

Check most recent update on cardano update table
If it falls within the threshold boundary, node should update db with latest data

```rust
fn database_ready_to_update(db: DBHandler) -> bool {
    // lock db
    // let last_updated = CardanoUpdateTable()
    // return update_threshold(last_updated) 
    // Resource acquisition is initialization: drop trait -> unlock db
}
```

Update database with follower data

```rust
fn update_database(db: DBHandler, stream: FollowerIo) -> Result<(), Err> {
    // lock db
    while let Some(block) = stream.next().await {
        let metadata = parse(block);
        db.insert(metadata);
    }
    // Resource acquisition is initialization: drop trait -> unlock db
}
```

Parse block

```rust
fn parse(block: Block) -> Result<MetaBlock, Err> {
    // extract era, unspent transaction output, spent Transactions and registration metadata
}
```

Calculate if threshold conditional has been met

```rust
fn update_threshold(last_updated: ThresholdMetric) -> bool {
    // threshold calculation
    // define conditional
}
```

## Follower

* Start follower with specified networks

* Stream blocks from given (slot,epoch)

## Syncing

Nodes race to update

## Contention

## Multiple nodes

## Roll backs
