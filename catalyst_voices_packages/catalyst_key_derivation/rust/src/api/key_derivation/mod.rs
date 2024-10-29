//! Key derivation module.

use bip32::DerivationPath;
use bip39::Mnemonic;
pub use ed25519_bip32::DerivationIndex;
pub use ed25519_bip32::DerivationScheme;
pub use ed25519_bip32::XPrv;
use hmac::Hmac;
use pbkdf2::pbkdf2;
use sha2::Sha512;

/// Extended private key bytes type
pub type XPrvBytes = [u8; 96];

/// Generate a new extended private key (`XPrv`) from a mnemonic and passphrase.
/// This function works with BIP-0039 mnemonics.
/// For more information: Cardano Icarus master node derivation
/// https://github.com/satoshilabs/slips/blob/master/slip-0023.md
/// 
/// # Arguments
///
/// - `mnemonic`: A string representing the mnemonic.
/// - `passphrase`: An optional string representing the passphrase.
///
/// # Returns
///
/// Returns the `XPrv` extended private key as a `Result`.
/// If the conversion is successful, it returns `Ok` with the extended private key
/// (`XPrv`).
pub fn mnemonic_to_xprv(mnemonic: String, passphrase: Option<String>) -> anyhow::Result<XPrvBytes> {
    let xprv = mnemonic_to_xprv_helper(mnemonic, passphrase)?;
    Ok(xprv.into())
}

/// Helper function for mnemonic_to_xprv.
fn mnemonic_to_xprv_helper(mnemonic: String, passphrase: Option<String>) -> anyhow::Result<XPrv> {
    /// 4096 is the number of iterations for PBKDF2.
    const ITER: u32 = 4096;

    // Parse will detect language and check mnemonic valid length
    // 12, 15, 18, 21, 24 are valid mnemonic length
    let mnemonic = Mnemonic::parse(mnemonic).map_err(|e| anyhow::anyhow!("Invalid mnemonic: {e}"))?;

    let entropy = mnemonic.to_entropy();

    // This implementation follows SLIP-0023 - Cardano Icarus master node derivation
    let mut pbkdf2_result = [0; 96];
    let _ = pbkdf2::<Hmac<Sha512>>(
        passphrase.unwrap_or_default().as_bytes(),
        &entropy,
        ITER,
        &mut pbkdf2_result,
    );

    Ok(XPrv::normalize_bytes_force3rd(pbkdf2_result))
}

/// Derive a new extended private key from the given extended private key.
/// - V2 derivation scheme is used as it is mention in [SLIP-0023](https://github.com/satoshilabs/slips/blob/master/slip-0023.md).
/// - More information about child key derivation can be found in [BIP32-Ed25519](https://input-output-hk.github.io/adrestia/static/Ed25519_BIP.pdf).
///  
/// # Arguments
///
/// - `xprivate_key_bytes`: An extended private key of type `XPrvBytes`.
/// - `path`: Derivation path. eg. m/0/2'/3 where ' represents hardened derivation.
///
/// # Returns
///
/// Returns the `XPrv` extended private key as a `Result`.
/// If the derivation path is successful, it returns `Ok` with the extended private key
/// (`XPrv`).
pub fn derive_xprivate_key(xprivate_key_bytes: XPrvBytes, path: String) -> anyhow::Result<XPrvBytes> {
    let xprv = XPrv::from_bytes_verified(xprivate_key_bytes)?;
    let derive_xprv = derive_xprivate_key_helper(xprv, path)?;
    Ok(derive_xprv.into())
}

/// Helper function for `derive_xprivate_key``.
fn derive_xprivate_key_helper(xprivate_key: XPrv, path: String) -> anyhow::Result<XPrv> {
    let Ok(derivation_path) = path.parse::<DerivationPath>() else {
        return Err(anyhow::anyhow!("Invalid derivation path: {path}"));
    };
    let key = derivation_path
        .iter()
        .fold(xprivate_key, |xprv, child_num| {
            if child_num.is_hardened() {
                xprv.derive(DerivationScheme::V2, child_num.index() | 0x80_00_00_00)
            } else {
                xprv.derive(DerivationScheme::V2, child_num.index())
            }
        });
    Ok(key)
}

#[cfg(test)]
mod test {

    use super::*;

    const MNEMONIC: &str = "prevent company field green slot measure chief hero apple task eagle sunset endorse dress seed";

    #[test]
    fn test_mnemonic_to_xprv() {
        assert!(mnemonic_to_xprv(MNEMONIC.to_string(), None).is_ok());
    }

    // Test vector from https://cips.cardano.org/cip/CIP-0011
    #[test]
    fn test_key_derivation() {
        let xprv = mnemonic_to_xprv(MNEMONIC.to_string(), None).unwrap();
        let path = "m/1852'/1815'/0'/2/0".to_string();
        let derive_xprv = XPrv::from_bytes_verified(derive_xprivate_key(xprv, path).unwrap()).unwrap();
        assert_eq!(derive_xprv.to_string(), 
        "b8ab42f1aacbcdb3ae858e3a3df88142b3ed27a2d3f432024e0d943fc1e597442d57545d84c8db2820b11509d944093bc605350e60c533b8886a405bd59eed6dcf356648fe9e9219d83e989c8ff5b5b337e2897b6554c1ab4e636de791fe5427");
    }
}
