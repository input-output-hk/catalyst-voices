<!-- cspell: words Aumasson Neves Zooko O'Hearn Winnerlein -->

# BLAKE2 and BLAKE3 for COSE Algorithms registry

This document specifies [COSE] Algorithm value types for [BLAKE2] and [BLAKE3] hash functions.

## BLAKE3

[BLAKE3] is a cryptographic hash function which was designed by
Jack O'Connor, Jean-Philippe Aumasson, Samuel Neves, Zooko Wilcox-O'Hearn.
It is an evolution of the BLAKE2 cryptographic hash functions

|  Name   | Value | Description | Capabilities | Reference | Recommended |
| - | - | - | - | - | - |
| Blake3 | 2525  | BLAKE3 hash has a 128-bit security level and a default output length of 256 bits (32 bytes) which can extended up to 264 bytes. | [] | [RFC 7693][BLAKE2] | Yes |

## BLAKE2

[BLAKE2] is a cryptographic hash function which was designed by
Jean-Philippe Aumasson, Samuel Neves, Zooko Wilcox-O'Hearn, and Christian Winnerlein.

There are only two variants of the [BLAKE2] hash functions:

* BLAKE2b (or just BLAKE2) is optimized for 64-bit platforms
  and produces digests of any size between 1 and 64 bytes.
* BLAKE2s is optimized for 8- to 32-bit platforms
  and produces digests of any size between 1 and 32 bytes.

|  Name   | Value | Description | Capabilities | Reference | Recommended |
| - | - | - | - | - | - |
| BLAKE2b | 2526  | BLAKE2b hash is optimized for 64-bit platforms and produces digests of any size between 1 and 64 bytes | [] | [RFC 7693][BLAKE2] | Yes |
| BLAKE2s | 2527  | BLAKE2s hash is optimized for 8- to 32-bit platforms and produces digests of any size between 1 and 32 bytes | [] | [RFC 7693][BLAKE2] | Yes |

## Author

Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

[COSE]: https://datatracker.ietf.org/doc/html/rfc8152
[BLAKE3]: https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf
[BLAKE2]: https://datatracker.ietf.org/doc/html/rfc7693
