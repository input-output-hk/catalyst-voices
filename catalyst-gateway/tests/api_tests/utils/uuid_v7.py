import time
import os


def uuid_v7() -> str:
    # random bytes
    value = bytearray(os.urandom(16))
    # current timestamp in ms
    timestamp = int(time.time() * 1000)

    # timestamp
    value[0] = (timestamp >> 40) & 0xFF
    value[1] = (timestamp >> 32) & 0xFF
    value[2] = (timestamp >> 24) & 0xFF
    value[3] = (timestamp >> 16) & 0xFF
    value[4] = (timestamp >> 8) & 0xFF
    value[5] = timestamp & 0xFF

    # version and variant
    value[6] = (value[6] & 0x0F) | 0x70
    value[8] = (value[8] & 0x3F) | 0x80

    return f"{value[:4].hex()}-{value[4:6].hex()}-{value[6:8].hex()}-{value[8:10].hex()}-{value[10:].hex()}"
