//! Utilities to use in the tests.

use cardano_blockchain_types::{Cip36, MultiEraBlock, Network, Point, StakeAddress};

/// Returns a stake address value for testing.
pub fn stake_address_1() -> StakeAddress {
    let hash = "276fd18711931e2c0e21430192dbeac0e458093cd9d1fcd7210f64b3"
        .parse()
        .unwrap();
    StakeAddress::new(Network::Mainnet, true, hash)
}

/// Returns a different stake address value for testing.
pub fn stake_address_2() -> StakeAddress {
    let hash = "fe0e6d6312ffb2055509b8815ddd36e01f7c696f6e2e88d7fe4bc1f6"
        .parse()
        .unwrap();
    StakeAddress::new(Network::Mainnet, true, hash)
}

/// Returns `Cip36` from the second (index 1) transaction from the block located in the
/// `block_1.block` file.
pub fn cip_36_1() -> Cip36 {
    let block = block_1();
    Cip36::new(&block, 1.into(), true).unwrap().unwrap()
}

/// Returns `Cip36` from the first (index 0) transaction from the block located in the
/// `block_2.block` file.
pub fn cip_36_2() -> Cip36 {
    let block = block_2();
    Cip36::new(&block, 0.into(), true).unwrap().unwrap()
}

/// Returns a decoded block from the `block_1.block` file.
pub fn block_1() -> MultiEraBlock {
    block(include_str!("test_data/block_1.block"))
}

/// Returns a decoded block from the `block_2.block` file.
pub fn block_2() -> MultiEraBlock {
    block(include_str!("test_data/block_2.block"))
}

/// Returns a decoded block from the `block_3.block` file.
pub fn block_3() -> MultiEraBlock {
    block(include_str!("test_data/block_3.block"))
}

/// Returns a decoded block from the `block_4.block` file.
pub fn block_4() -> MultiEraBlock {
    block(include_str!("test_data/block_4.block"))
}

/// Decodes a block from the given string.
fn block(data: &str) -> MultiEraBlock {
    let data = hex::decode(data).unwrap();
    let previous = Point::fuzzy(0.into());
    MultiEraBlock::new(Network::Preprod, data, &previous, 0.into()).unwrap()
}
