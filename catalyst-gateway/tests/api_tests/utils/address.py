# cspell: words convertbits, segwit
from hashlib import blake2b
from bitcoin.segwit_addr import bech32_encode, convertbits

# according to [CIP-19](https://cips.cardano.org/cips/cip19/).
def stake_public_key_to_address(key: str, is_stake: bool, network_type: str):
    def stake_header(is_stake: bool, network_type: str):
        if is_stake:
            # stake key hash
            typeid = int("1110", 2)
        else:
            # script hash
            typeid = int("1111", 2)
        if network_type == "mainnet":
            network_id = 1
        elif (
            network_type == "testnet"
            or network_type == "preprod"
            or network_type == "preview"
        ):
            network_id = 0
        else:
            raise f"Unknown network type: {network_type}"

        typeid = typeid << 4
        return typeid | network_id

    key_bytes = bytes.fromhex(key)
    key_hash = blake2b(key_bytes, digest_size=28)
    header = stake_header(is_stake=is_stake, network_type=network_type)
    key_hash_with_header = header.to_bytes(1, "big") + key_hash.digest()

    if network_type == "mainnet":
        hrp = "stake"
    elif (
        network_type == "testnet"
        or network_type == "preprod"
        or network_type == "preview"
    ):
        hrp = "stake_test"
    else:
        raise f"Unknown network type: {network_type}"

    return bech32_encode(hrp, convertbits(key_hash_with_header, 8, 5))
