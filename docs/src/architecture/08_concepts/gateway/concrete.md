---
icon: material/hub
---

### Concrete building blocks

## Node Bootstrap

Query DB and check if config exists
```rust
fn config_exists(db: DBHandler) -> Option<Config> {
    // lock db
    // if config exists { Some(config) }
    // else { None }
    // RAII drop trait -> unlock db
}
```

Poll for config <br />
TBD: futures
```rust
fn poll_config(db: DBHandler) -> Option<Config> {
    /*loop {
        if let Some(r) = config_exists(db)? {
            return Some(r)
        }
    }*/
}
```

## Database updates



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
Nodes race to update

## Contention

## Multiple nodes

## Roll backs