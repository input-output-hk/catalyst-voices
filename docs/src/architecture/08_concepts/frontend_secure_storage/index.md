---
icon: material/lock
---

# Frontend Secure Storage

This section documents secure storage patterns for sensitive data in the Catalyst Voices frontend
application.

## Overview

The application uses `FlutterSecureStorage` with encryption for storing sensitive data like keys,
credentials, and user information.

## Architecture

### FlutterSecureStorage

Platform-specific secure storage:

* **iOS**: Keychain
* **Android**: EncryptedSharedPreferences (AES encryption)
* **Web**: Encrypted localStorage (AES encryption)

### Vault Pattern

The `Vault` interface provides encrypted storage with:

* **Encryption/Decryption**: Data encrypted before storage
* **Lock/Unlock**: Vault can be locked/unlocked
* **TTL-based Unlock**: Automatic locking after timeout
* **Cache**: In-memory cache for unlocked state

### SecureStorageVault

Implementation of `Vault` using `FlutterSecureStorage`:

```dart
class SecureStorageVault implements Vault {
  // Encrypted read/write operations
  Future<String?> read({required String key});
  Future<void> write(String? value, {required String key});

  // Lock/unlock operations
  Future<void> unlock(Uint8List key);
  Future<void> lock();
  bool get isUnlocked;
}
```

## Key Management

### Keychain Provider

`VaultKeychainProvider` manages keychains:

* Multiple keychains per user
* Encrypted storage
* Secure key derivation
* Cache management

### Key Derivation

Keys derived from mnemonics using Rust WASM:

* BIP32-Ed25519-XCatalyst key derivation
* Secure key storage
* Platform-specific secure storage

## Encryption

### LocalCryptoService

Provides encryption/decryption:

* AES encryption for vault data
* Password hashing
* Secure random generation

### Encryption Flow

1. Data encrypted with lock key
2. Encrypted data stored in secure storage
3. Lock key derived from user credentials
4. Lock key cleared from memory after use

## Usage Patterns

### Storing Sensitive Data

```dart
final vault = VaultKeychainProvider(...);
await vault.unlock(derivedKey);
await vault.write('sensitive_data', key: 'data_key');
```

### Reading Sensitive Data

```dart
final data = await vault.read(key: 'data_key');
```

### Locking Vault

```dart
await vault.lock(); // Clears keys from memory
```

## Security Considerations

### Key Management

* Keys never stored in plaintext
* Keys cleared from memory after use
* Secure key derivation from mnemonics

### Encryption

* AES encryption for all sensitive data
* Platform-specific secure storage
* Encrypted at rest

### Access Control

* Vault must be unlocked before access
* TTL-based automatic locking
* Active state management

## Best Practices

1. **Always encrypt sensitive data**: Never store plaintext sensitive data
2. **Use vault pattern**: Use Vault interface for encrypted storage
3. **Lock when inactive**: Lock vault when not in use
4. **Clear keys from memory**: Erase keys after use
5. **Use secure key derivation**: Derive keys securely from user input
6. **Platform-specific storage**: Rely on platform secure storage
