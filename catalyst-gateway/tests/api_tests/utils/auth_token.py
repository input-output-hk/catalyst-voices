from datetime import datetime, timezone
import base64
import pytest
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey, Ed25519PublicKey

@pytest.fixture
def rbac_auth_token_factory():

    def __rbac_auth_token_factory(
        # Already registered as role 0
        # https://preprod.cexplorer.io/tx/764139bb8924f436486fa686ec836c180e98cc8d3e8ff413e3c11222fcf23836
        sk_hex: str = "e81127f0586aa9c6cf0b6048330f3200e1791187ea87ab780e14337f814e3f51a1f265eac3449c1109ba026d425c4b08f45088a4b47c3892157e740042a18e37",
        pk_hex: str = "6e42f8e589a76ebb13ef279df7841efce978f106bee196f0e3cfd347bb31a2e8"
    ) -> str:
        sk = Ed25519PrivateKey.from_private_bytes(bytes.fromhex(sk_hex)[:32])
        pk = Ed25519PublicKey.from_public_bytes(bytes.fromhex(pk_hex))
        return generate_rbac_auth_token("cardano", "preprod", pk, sk)
    return __rbac_auth_token_factory

def generate_rbac_auth_token(network: str, subnet: str | None, role0_pk: Ed25519PublicKey, sk: Ed25519PrivateKey) -> str:
    prefix = "catid.:"
    nonce = int(datetime.now(timezone.utc).timestamp())
    subnet = f"{subnet}." if subnet else ""
    role0_pk_b64 = base64_url(role0_pk.public_bytes_raw())
    
    catid_without_sig = f"{prefix}{nonce}@{subnet}{network}/{role0_pk_b64}."
    
    signature = sk.sign(catid_without_sig.encode()) 
    signature_b64 = base64_url(signature)

    return f"{catid_without_sig}{signature_b64}"
    

def base64_url(data: bytes) -> str:
    # URL safety and no padding base 64
    return base64.urlsafe_b64encode(data).decode().rstrip("=")
