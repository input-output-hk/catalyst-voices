//! Cardano deterministic key hierarchy using BIP-0039 module.
//!
//! This module provides functions necessary to handle deterministic key derivation
//! using BIP-0039 mnemonics.

use bip32::DerivationPath;
use bip39::Mnemonic;
pub use ed25519_bip32::{DerivationIndex, DerivationScheme, Signature, XPrv, XPub};
use flutter_rust_bridge::spawn_blocking_with;
use hmac::Hmac;
use pbkdf2::pbkdf2;
use sha2::Sha512;

use crate::frb_generated::FLUTTER_RUST_BRIDGE_HANDLER;

/// Extended private key bytes type.
/// Compose of:
/// - 64 Bytes: extended Ed25519 secret key
/// - 32 Bytes: chain code
pub type XPrvBytes = [u8; 96];

/// Extended public key bytes type.
pub type XPubBytes = [u8; 64];

/// Signature bytes type.
pub type SignatureBytes = [u8; 64];

/// Generate a new extended private key (`XPrv`) from a mnemonic and passphrase.
/// Note that this function only works with BIP-0039 mnemonics.
/// For more information: Cardano Icarus master node derivation
/// <https://github.com/satoshilabs/slips/blob/master/slip-0023.md>
///
/// # Arguments
///
/// - `mnemonic`: A string representing the mnemonic.
/// - `passphrase`: An optional string representing the passphrase (aka. password).
///
/// # Returns
///
/// Returns a bytes of extended private key as a `Result`.
///
/// # Errors
///
/// Returns an error if the mnemonic is invalid.
pub async fn mnemonic_to_xprv(
    mnemonic: String, passphrase: Option<String>,
) -> anyhow::Result<XPrvBytes> {
    let xprv = spawn_blocking_with(
        move || mnemonic_to_xprv_helper(mnemonic, passphrase),
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(xprv.into())
}

/// Helper function for `mnemonic_to_xprv`.
///
/// # Steps
///
/// This implementation follows SLIP-0023 - Cardano Icarus master node derivation
///
/// 1. Let `mnemonic` be a BIP-0039 mnemonic and `passphrase`be the passphrase.
/// 2. Determine entropy that was used to generate `mnemonic`.
/// 3. Compute `pbkdf2_result` = PBKDF2-HMAC-SHA512(password = `passphrase`, salt =
///    `entropy`, iterations = 4096, dkLen = 96).
/// 4. given `pbkdf2_result` is S, modify S by assigning S[0] := S[0] & 0xf8 and S[31] :=
///    (S[31] & 0x1f) | 0x40.
/// 5. The result will be
///     - kL where S[0:32] a 256-bit integer in little-endian byte order.
///     - kR where S[32:64]
///     - Result in (kL, kR) as the root extended private key and c := S[64:96] as the
///       root chain code.
fn mnemonic_to_xprv_helper(mnemonic: String, passphrase: Option<String>) -> anyhow::Result<XPrv> {
    /// 4096 is the number of iterations for PBKDF2.
    const ITER: u32 = 4096;

    // Parse will detect language and check mnemonic valid length
    // 12, 15, 18, 21, 24 are valid mnemonic length
    let mnemonic =
        Mnemonic::parse(mnemonic).map_err(|e| anyhow::anyhow!("Invalid mnemonic: {e}"))?;

    let entropy = mnemonic.to_entropy();

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
/// - `xprv_bytes`: An extended private key bytes of type `XPrvBytes`.
/// - `path`: Derivation path. eg. m/0/2'/3 where ' represents hardened derivation.
///
/// # Returns
///
/// Returns a bytes of extended private key as a `Result`.
///
/// # Errors
///
/// Returns an error if the derivation path is invalid.
// &str is not supported in flutter_rust_bridge
#[allow(clippy::needless_pass_by_value)]
pub async fn derive_xprv(xprv_bytes: XPrvBytes, path: String) -> anyhow::Result<XPrvBytes> {
    let derive_xprv = spawn_blocking_with(
        move || {
            let xprv = XPrv::from_bytes_verified(xprv_bytes)?;
            derive_xprv_helper(xprv, &path)
        },
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(derive_xprv.into())
}

/// Helper function for `derive_xprv`.
fn derive_xprv_helper(xprv: XPrv, path: &str) -> anyhow::Result<XPrv> {
    let Ok(derivation_path) = path.parse::<DerivationPath>() else {
        return Err(anyhow::anyhow!("Invalid derivation path: {path}"));
    };
    let key = derivation_path.iter().fold(xprv, |xprv, child_num| {
        if child_num.is_hardened() {
            // i >= 2^31 is a hardened derivation
            xprv.derive(DerivationScheme::V2, child_num.index() | 0x80_00_00_00)
        } else {
            xprv.derive(DerivationScheme::V2, child_num.index())
        }
    });
    Ok(key)
}

/// Get public key from the given extended private key.
///
/// # Arguments
///
/// - `xprv_bytes`: An extended private key bytes of type `XPrvBytes`.
///
/// # Returns
///
/// Returns a 64 length bytes `XPubBytes` representing the public key.
///
/// # Errors
///
/// Returns an error if the private key is invalid.
pub async fn xpublic_key(xprv_bytes: XPrvBytes) -> anyhow::Result<XPubBytes> {
    let xpublic_key = spawn_blocking_with(
        move || {
            let xprv = match XPrv::from_bytes_verified(xprv_bytes) {
                Ok(xprv) => xprv,
                Err(e) => return Err(anyhow::anyhow!(e)),
            };
            Ok(xpublic_key_helper(&xprv))
        },
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(Into::<[u8; 64]>::into(xpublic_key))
}

/// Helper function for `xpublic_key`.
fn xpublic_key_helper(xprv: &XPrv) -> XPub {
    xprv.public()
}

/// Sign data with the given extended private key.
///
/// # Arguments
///
/// - `xprv_bytes`: An extended private key bytes of type `XPrvBytes`.
/// - `data`: The data to sign.
///
/// # Returns
/// Returns a 64 length bytes `SignatureBytes` representing the signature.
///
/// # Errors
///
/// Returns an error if the private key is invalid.
pub async fn sign_data(xprv_bytes: XPrvBytes, data: Vec<u8>) -> anyhow::Result<SignatureBytes> {
    let signature = spawn_blocking_with(
        move || {
            let xprv = match XPrv::from_bytes_verified(xprv_bytes) {
                Ok(xprv) => xprv,
                Err(e) => return Err(anyhow::anyhow!(e)),
            };
            Ok(sign_data_helper(&xprv, &data))
        },
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(*signature.to_bytes())
}

/// Helper function for `sign_data`.
fn sign_data_helper(xprv: &XPrv, data: &[u8]) -> Signature<SignatureBytes> {
    xprv.sign(data)
}

/// Check the signature on the given data using extended private key.
///
/// # Arguments
///
/// - `xprv_bytes`: An extended private key bytes of type `XPrvBytes`.
/// - `data`: The data to sign.
/// - `signature`: The signature to check.
///
/// # Returns
/// Returns a boolean value indicating if the signature match the sign data
/// True if the signature is valid and match the sign data, false otherwise.
///
/// # Errors
///
/// Returns an error if the private key or signature is invalid.
pub async fn check_signature_xprv(
    xprv_bytes: XPrvBytes, data: Vec<u8>, signature: SignatureBytes,
) -> anyhow::Result<bool> {
    let result = spawn_blocking_with(
        move || -> anyhow::Result<bool> {
            // Verify the signature.
            let verified_sig: Signature<SignatureBytes> = match Signature::from_slice(&signature) {
                Ok(sig) => sig,
                // Invalid signature, force return false.
                Err(_) => return Ok(false),
            };
            let xprv = XPrv::from_bytes_verified(xprv_bytes)?;
            Ok(check_signature_xprv_helper(&xprv, &data, verified_sig))
        },
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

/// Helper function for `check_signature`.
pub(crate) fn check_signature_xprv_helper(
    xprv: &XPrv, data: &[u8], signature: Signature<SignatureBytes>,
) -> bool {
    xprv.verify(data, &signature)
}

/// Check the signature on the given data using extended public key.
///
/// # Arguments
///
/// - `xpub_bytes`: An extended public key bytes of type `XPubBytes`.
/// - `data`: The data to sign.
/// - `signature`: The signature to check.
///
/// # Returns
/// Returns a boolean value indicating if the signature match the sign data
/// True if the signature is valid and match the sign data, false otherwise.
///
/// # Errors
///
/// Returns an error if the public key or signature is invalid.
pub async fn check_signature_xpub(
    xpub_bytes: XPubBytes, data: Vec<u8>, signature: SignatureBytes,
) -> anyhow::Result<bool> {
    let result = spawn_blocking_with(
        move || -> anyhow::Result<bool> {
            let verified_sig: Signature<SignatureBytes> = match Signature::from_slice(&signature) {
                Ok(sig) => sig,
                // Invalid signature, force return false.
                Err(_) => return Ok(false),
            };
            let xprv = XPub::from_bytes(xpub_bytes);
            Ok(check_signature_xpub_helper(&xprv, &data, verified_sig))
        },
        FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
    )
    .await??;

    Ok(result)
}

/// Helper function for `check_signature`.
pub(crate) fn check_signature_xpub_helper(
    xpublic_key: &XPub, data: &[u8], signature: Signature<SignatureBytes>,
) -> bool {
    xpublic_key.verify(data, &signature)
}

#[cfg(test)]
mod test {

    use super::*;

    const MNEMONIC: &str = "prevent company field green slot measure chief hero apple task eagle sunset endorse dress seed";

    // Call to function should not return error
    #[test]
    fn test_mnemonic_to_xprv() {
        assert!(mnemonic_to_xprv_helper(MNEMONIC.to_string(), None).is_ok());
    }

    // Test vector from https://cips.cardano.org/cip/CIP-0011
    #[test]
    fn test_key_derivation() {
        let xprv = mnemonic_to_xprv_helper(MNEMONIC.to_string(), None).unwrap();
        let path = "m/1852'/1815'/0'/2/0";
        let derive_xprv = derive_xprv_helper(xprv, path).unwrap();
        assert_eq!(derive_xprv.to_string(),
        "b8ab42f1aacbcdb3ae858e3a3df88142b3ed27a2d3f432024e0d943fc1e597442d57545d84c8db2820b11509d944093bc605350e60c533b8886a405bd59eed6dcf356648fe9e9219d83e989c8ff5b5b337e2897b6554c1ab4e636de791fe5427");
    }

    #[test]
    fn test_sign_data() {
        let data = vec![1, 2, 3];
        let xprv = mnemonic_to_xprv_helper(MNEMONIC.to_string(), None).unwrap();
        let sign_data = sign_data_helper(&xprv, &data);
        assert!(check_signature_xprv_helper(&xprv, &data, sign_data.clone()));
        let xpub = xpublic_key_helper(&xprv);
        assert!(check_signature_xpub_helper(&xpub, &data, sign_data));
    }
}
