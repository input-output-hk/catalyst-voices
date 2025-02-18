//! Utilities for creating 29 bytes hash.

use cardano_blockchain_types::Network;
use pallas::crypto::hash::Hash;

/// Converts the given stake credential to 29 bytes hash with a header.
pub fn stake_hash(network: Network, is_script: bool, hash: &Hash<28>) -> Vec<u8> {
    let network: u8 = match network {
        Network::Preprod | Network::Preview => 0,
        Network::Mainnet => 1,
    };

    let header = if is_script {
        0b1110 << 4 | network
    } else {
        0b1111 << 4 | network
    };

    [&[header], hash.as_slice()].concat()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_stake_hash() {
        let hash: Hash<28> = "276fd18711931e2c0e21430192dbeac0e458093cd9d1fcd7210f64b3"
            .parse()
            .unwrap();
        let test_data = [
            (Network::Mainnet, true, hash, 0b11100001),
            (Network::Mainnet, false, hash, 0b11110001),
            (Network::Preprod, true, hash, 0b11100000),
            (Network::Preprod, false, hash, 0b11110000),
            (Network::Preview, true, hash, 0b11100000),
            (Network::Preview, false, hash, 0b11110000),
        ];

        for (network, is_script, hash, expected_header) in test_data {
            let stake_hash = stake_hash(network, is_script, &hash);
            assert_eq!(
                29,
                stake_hash.len(),
                "Invalid length for {network} {is_script}"
            );
            assert_eq!(
                stake_hash.get(1..).unwrap(),
                hash.as_ref(),
                "Invalid hash for {network} {is_script}"
            );
            assert_eq!(
                expected_header,
                *stake_hash.get(0).unwrap(),
                "Invalid header for {network} {is_script}"
            );
        }
    }
}
