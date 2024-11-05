//! Cardano deterministic key hierarchy using BIP-0039 module.
//!
//! This module provides functions necessary to handle deterministic key derivation
//! using BIP-0039 mnemonics.

use bip32::DerivationPath;
use bip39::Mnemonic;
pub use ed25519_bip32::{DerivationIndex, DerivationScheme, Signature, XPrv, XPub};
use flutter_rust_bridge::{frb, spawn_blocking_with};
use hmac::Hmac;
use pbkdf2::pbkdf2;
use sha2::Sha512;

use crate::frb_generated::FLUTTER_RUST_BRIDGE_HANDLER;

/// BIP32-Ed25519 extended private key bytes type.
/// Compose of:
/// - 64 Bytes: extended Ed25519 secret key
/// - 32 Bytes: chain code
#[derive(Clone, Debug, PartialEq, Eq)]
#[frb(opaque)]
pub struct Bip32Ed25519XPrivateKey([u8; 96]);

impl From<XPrv> for Bip32Ed25519XPrivateKey {
    fn from(xprv: XPrv) -> Self {
        Bip32Ed25519XPrivateKey(xprv.into())
    }
}

impl Bip32Ed25519XPrivateKey {
    /// Create a new `Bip32Ed25519XPrivateKey` from the given bytes.
    #[frb(sync)]
    pub fn new(xprv_bytes: [u8; 96]) -> Self {
        Bip32Ed25519XPrivateKey(xprv_bytes)
    }

    /// Get the inner bytes.
    #[frb(getter, sync)]
    pub fn get_inner(&self) -> [u8; 96] {
        self.0
    }

    /// Extract the chain code from the extended private key.
    /// The chain code is the last 32 bytes of the extended private key.
    ///
    /// # Returns
    ///
    /// Returns a 32 length bytes representing the chain code.
    #[frb(getter, sync)]
    pub fn get_chain_code(&self) -> [u8; 32] {
        let mut chain_code = [0; 32];
        chain_code.copy_from_slice(&self.0[64..96]);
        chain_code
    }

    /// Extract the extended secret key from the extended private key.
    /// The extended secret key is the first 64 bytes of the extended private key.
    ///
    /// # Returns
    ///
    /// Returns a 64 length bytes representing the extended secret key.
    #[frb(getter, sync)]
    pub fn get_extended_secret_key(&self) -> [u8; 64] {
        let mut x_secret = [0; 64];
        x_secret.copy_from_slice(&self.0[0..64]);
        x_secret
    }

    /// Derive a new extended private key from the given extended private key.
    /// - V2 derivation scheme is used as it is mention in [SLIP-0023](https://github.com/satoshilabs/slips/blob/master/slip-0023.md).
    /// - More information about child key derivation can be found in [BIP32-Ed25519](https://input-output-hk.github.io/adrestia/static/Ed25519_BIP.pdf).
    ///  
    /// # Arguments
    ///
    /// - `xprv_bytes`: An extended private key bytes of type `Bip32Ed25519XPrivateKey`.
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
    pub async fn derive_xprv(&self, path: String) -> anyhow::Result<Self> {
        let xprv = XPrv::from_bytes_verified(self.0)?;

        let derive_xprv = spawn_blocking_with(
            move || derive_xprv_helper(xprv, &path),
            FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
        )
        .await??;

        Ok(derive_xprv.into())
    }

    /// Get extended public key from the given extended private key.
    ///
    /// # Returns
    ///
    /// Returns a 64 length bytes `Bip32Ed25519XPublicKey` representing the extended
    /// public key.
    ///
    /// # Errors
    ///
    /// Returns an error if the extended private key is invalid.
    pub async fn xpublic_key(&self) -> anyhow::Result<Bip32Ed25519XPublicKey> {
        let xprv = XPrv::from_bytes_verified(self.0)?;

        let xpub = spawn_blocking_with(
            move || xpublic_key_helper(&xprv),
            FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
        )
        .await?;

        Ok(Bip32Ed25519XPublicKey(xpub.into()))
    }

    /// Sign the given data with the given extended private key.
    ///
    /// # Arguments
    ///
    /// - `data`: The data to sign.
    ///
    /// # Returns
    /// Returns a 64 length bytes `Bip32Ed25519Signature` representing the signature.
    ///
    /// # Errors
    ///
    /// Returns an error if the extended private key is invalid.
    pub async fn sign_data(&self, data: Vec<u8>) -> anyhow::Result<Bip32Ed25519Signature> {
        let xprv = XPrv::from_bytes_verified(self.0)?;

        let signature = spawn_blocking_with(
            move || sign_data_helper(&xprv, &data),
            FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
        )
        .await?;

        Ok(Bip32Ed25519Signature(*signature.to_bytes()))
    }

    /// Verify the signature on the given data using extended private key.
    ///
    /// # Arguments
    ///
    /// - `data`: The data to sign.
    /// - `signature`: The signature to check.
    ///
    /// # Returns
    /// Returns a boolean value indicating if the signature match the sign data
    /// True if the signature is valid and match the sign data, false otherwise.
    ///
    /// # Errors
    ///
    /// Returns an error if the extended private key or signature is invalid.
    pub async fn verify_signature(
        &self, data: Vec<u8>, signature: &Bip32Ed25519Signature,
    ) -> anyhow::Result<bool> {
        let xprv = XPrv::from_bytes_verified(self.0)?;
        let verified_sig = Signature::from_slice(&signature.0)
            .map_err(|_| anyhow::anyhow!("Invalid signature"))?;

        let result = spawn_blocking_with(
            move || verify_signature_xprv_helper(&xprv, &data, &verified_sig),
            FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
        )
        .await?;

        Ok(result)
    }

    /// Drop the extended private key.
    #[frb(sync)]
    pub fn drop(&mut self) {
        // Zero out the private key bytes to improve security
        for byte in &mut self.0 {
            *byte = 0;
        }
    }
}

/// BIP32-Ed25519 extended public key bytes type.
#[derive(Clone, Debug, PartialEq, Eq)]
#[frb(opaque)]
pub struct Bip32Ed25519XPublicKey([u8; 64]);

impl From<XPub> for Bip32Ed25519XPublicKey {
    fn from(xpub: XPub) -> Self {
        Bip32Ed25519XPublicKey(xpub.into())
    }
}

impl Bip32Ed25519XPublicKey {
    /// Create a new `Bip32Ed25519XPublicKey` from the given bytes.
    #[frb(sync)]
    pub fn new(xpub_bytes: [u8; 64]) -> Self {
        Bip32Ed25519XPublicKey(xpub_bytes)
    }

    /// Get the inner bytes.
    #[frb(getter, sync)]
    pub fn get_inner(&self) -> [u8; 64] {
        self.0
    }

    /// Extract the chain code from the extended public key.
    /// The chain code is the last 32 bytes of the extended public key.
    ///
    /// # Returns
    ///
    /// Returns a 32 length bytes representing the chain code.
    #[frb(getter, sync)]
    pub fn get_chain_code(&self) -> [u8; 32] {
        let mut chain_code = [0; 32];
        chain_code.copy_from_slice(&self.0[32..64]);
        chain_code
    }

    /// Extract the public key from the extended public key.
    /// The public key is the first 32 bytes of the extended public key.
    ///
    /// # Returns
    ///
    /// Returns a 32 length bytes representing the public key.
    #[frb(getter, sync)]

    pub fn get_public_key(&self) -> [u8; 32] {
        let mut public_key = [0; 32];
        public_key.copy_from_slice(&self.0[0..32]);
        public_key
    }

    /// Verify the signature on the given data using extended public key.
    ///
    /// # Arguments
    ///
    /// - `data`: The data to sign.
    /// - `signature`: The signature to check.
    ///
    /// # Returns
    /// Returns a boolean value indicating if the signature match the sign data
    /// True if the signature is valid and match the sign data, false otherwise.
    ///
    /// # Errors
    ///
    /// Returns an error if the extended public key or signature is invalid.
    pub async fn verify_signature(
        &self, data: Vec<u8>, signature: &Bip32Ed25519Signature,
    ) -> anyhow::Result<bool> {
        let xpub = XPub::from_bytes(self.0);
        let verified_sig = Signature::from_slice(&signature.0)
            .map_err(|_| anyhow::anyhow!("Invalid signature"))?;

        let result = spawn_blocking_with(
            move || verify_signature_xpub_helper(&xpub, &data, &verified_sig),
            FLUTTER_RUST_BRIDGE_HANDLER.thread_pool(),
        )
        .await?;

        Ok(result)
    }
}

/// BIP32-Ed25519 signature bytes type.
#[derive(Clone, Debug, PartialEq, Eq)]
#[frb(opaque)]
pub struct Bip32Ed25519Signature([u8; 64]);

impl Bip32Ed25519Signature {
    /// Create a new `Bip32Ed25519Signature` from the given bytes.
    #[frb(sync)]
    pub fn new(sig_bytes: [u8; 64]) -> Self {
        Bip32Ed25519Signature(sig_bytes)
    }

    /// Get the inner bytes.
    #[frb(getter, sync)]
    pub fn get_inner(&self) -> [u8; 64] {
        self.0
    }
}

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
) -> anyhow::Result<Bip32Ed25519XPrivateKey> {
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
/// 4. given `pbkdf2_result` is S, modify S by assigning S\[0\] := S\[0\] & 0xf8 and S\[31\] :=
///    (S\[31\] & 0x1f) | 0x40.
/// 5. The result will be
///     - kL where S\[0:32\] a 256-bit integer in little-endian byte order.
///     - kR where S\[32:64\]
///     - Result in (kL, kR) as the root extended private key and c := S\[64:96\] as the
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

/// Helper function for `derive_xprv`.
fn derive_xprv_helper(xprv: XPrv, path: &str) -> anyhow::Result<XPrv> {
    let Ok(derivation_path) = path.parse::<DerivationPath>() else {
        return Err(anyhow::anyhow!("Invalid derivation path: {path}"));
    };
    let key = derivation_path.iter().fold(xprv, |xprv, child_num| {
        if child_num.is_hardened() {
            // Hardened derivation is indicated by setting the highest bit (i >= 2^31).
            // This modifies the child index by applying a mask to ensure it falls within the
            // hardened range. Note that 0x80_00_00_00 is equivalent to 2^31.
            // More about hardened, please visit
            // <https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki>
            xprv.derive(DerivationScheme::V2, child_num.index() | 0x80_00_00_00)
        } else {
            xprv.derive(DerivationScheme::V2, child_num.index())
        }
    });
    Ok(key)
}

/// Helper function for `xpub`.
fn xpublic_key_helper(xprv: &XPrv) -> XPub {
    xprv.public()
}

/// Helper function for `sign_data`.
fn sign_data_helper(xprv: &XPrv, data: &[u8]) -> Signature<Bip32Ed25519Signature> {
    xprv.sign(data)
}

/// Helper function for `Bip32Ed25519XPrivateKey` `verify_signature`.
fn verify_signature_xprv_helper(
    xprv: &XPrv, data: &[u8], signature: &Signature<Bip32Ed25519Signature>,
) -> bool {
    xprv.verify(data, signature)
}

/// Helper function for `Bip32Ed25519XPublicKey` `verify_signature`.
fn verify_signature_xpub_helper(
    xpub: &XPub, data: &[u8], signature: &Signature<Bip32Ed25519Signature>,
) -> bool {
    xpub.verify(data, signature)
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
        assert!(verify_signature_xprv_helper(&xprv, &data, &sign_data));
        let xpub = xpublic_key_helper(&xprv);
        assert!(verify_signature_xpub_helper(&xpub, &data, &sign_data));
    }
}
