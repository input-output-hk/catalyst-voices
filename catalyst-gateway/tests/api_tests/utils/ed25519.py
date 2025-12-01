from enum import StrEnum
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey, Ed25519PublicKey
from pycardano.crypto.bip32 import BIP32ED25519PrivateKey, BIP32ED25519PublicKey

class Ed25519Type(StrEnum):
    Regular = "regular"
    Bip32Extended = "bip32-extended"

    def __str__(self) -> str:
        return self
    
class Ed25519Keys:
    def __init__(self, sk_hex: str, type: Ed25519Type):
        self.sk_hex = sk_hex
        self.type = type

    def pk_hex(self) -> str:
        if self.type == Ed25519Type.Regular:
            sk = Ed25519PrivateKey.from_private_bytes(bytes.fromhex(self.sk_hex))
            return sk.public_key().public_bytes_raw().hex()
        if self.type == Ed25519Type.Bip32Extended:
            sk = BIP32ED25519PrivateKey(
                    bytes.fromhex(self.sk_hex)[:64],
                    bytes.fromhex(self.sk_hex)[64:]
                )
            return sk.public_key.hex()
        return ""
    
    def sign(self, msg: bytes) -> bytes:
        if self.type == Ed25519Type.Regular:
            sk = Ed25519PrivateKey.from_private_bytes(bytes.fromhex(self.sk_hex))
            return sk.sign(msg)
        if self.type == Ed25519Type.Bip32Extended:
            sk = BIP32ED25519PrivateKey(
                    bytes.fromhex(self.sk_hex)[:64],
                    bytes.fromhex(self.sk_hex)[64:]
                )
            return sk.sign(msg)
        return b""