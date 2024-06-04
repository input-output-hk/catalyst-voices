---
icon: material/airplane-cog
---

# Cardano Database Design

The Cardano Blockchain database is built around an Apache Cassandra NoSQL type database.
In production, we will be using AWS Keyspaces.
In development, we will be using ScyllaDB.

The differences in these two engines needs to be internalized inside the database code.

## Query Design

### General Information

1. For a date, get the 1 Slot# <, == and > the date.
2. For a slot#, get block info.
3. Get latest slot# processed.
4. Get all tx_id for a slot#.
5. Get transaction data for a tx_id.

### Staked ADA / Voting Power

1. For a StakeKeyHash, get all the UTXO's <= a slot#.
2. For a StakeKeyHash, get all the Spent TXO's <= a slot#.
3. For a StakeKeyHash, get all the Staking Rewards earned <= a slot#.
4. For a StakekeyHash, get all the Staking Rewards withdrawals <= a slot#.
5. For a StakeKeyHash, get the Unhashed Stake Key
6. For a StakeKeyHash, get the latest delegation (to a stake pool).
7. For a Stake Pool ID#, Get latest stake pool registration <= slot#.

### Voter Registration - CIP36

1. For a StakeKeyHash, get latest valid CIP-36 voter registrations <= slot#.
2. For a StakeKeyHash, get latest invalid CIP-36 voter registrations <= slot#.
3. For a Public Voter Key, get latest registered StakeKeyHashes <= slot#. **DONE**
