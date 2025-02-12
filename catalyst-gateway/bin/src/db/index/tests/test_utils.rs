//! Utilities to use in the tests.

use cardano_blockchain_types::{Cip36, MultiEraBlock, Network, Point};

/// Returns `Cip36` from the second (index 1) transaction from the block located in the
/// `block_with_cip19_1.block` file.
pub fn cip_36_1() -> Cip36 {
    let block = block_1();
    Cip36::new(&block, 1.into(), true).unwrap().unwrap()
}

/// Returns `Cip36` from the first (index 0) transaction from the block located in the
/// `block_with_cip19_2.block` file.
pub fn cip_36_2() -> Cip36 {
    let block = block_2();
    Cip36::new(&block, 1.into(), true).unwrap().unwrap()
}

/// Returns a decoded block from the `block_with_cip19_1.block` file.
pub fn block_1() -> MultiEraBlock {
    block(include_str!("./test_data/block_with_cip19_1.block"))
}

/// Returns a decoded block from the `block_with_cip19_2.block` file.
pub fn block_2() -> MultiEraBlock {
    block(include_str!("./test_data/block_with_cip19_2.block"))
}

/// Decodes a block from the given string.
fn block(data: &str) -> MultiEraBlock {
    let data = hex::decode(data).unwrap();
    let previous = Point::fuzzy(0.into());
    MultiEraBlock::new(Network::Preprod, data, &previous, 0.into()).unwrap()
}
