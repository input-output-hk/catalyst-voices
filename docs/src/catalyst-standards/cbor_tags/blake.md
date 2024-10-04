<!-- cspell: words Aumasson Neves Zooko O'Hearn Winnerlein Bormann O'Conor -->

# BLAKE2 and BLAKE3 for for CBOR

This document specifies a CBOR [1] tags for BLAKE2 [2] and BLAKE3 [3] hash functions.

## BLAKE3

    Tag: 32781
    Data item: byte string
    Semantics: Binary BLAKE3 hash value (https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>, Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
    Description of semantics:
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/blake.md#BLAKE3

### Semantics

Tag 32781 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary BLAKE3 [2] hash value encoded in big-endian.
The length of the byte string will characterize the size of the hash function to be used e.g. BLAKE3-256, BLAKE3-512 etc.

## BLAKE2b

    Tag: 32782
    Data item: byte string
    Semantics: Binary BLAKE2b hash value (https://www.blake2.net/blake2.pdf)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>, Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
    Description of semantics:
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/blake.md#BLAKE2b

### Semantics

Tag 32782 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary BLAKE2b [3] hash value encoded in big-endian.
The length of the byte string will characterize the size of the hash function to be used e.g. BLAKE2b-256, BLAKE2b-512 etc.

## BLAKE2s

    Tag: 32783
    Data item: byte string
    Semantics: Binary BLAKE2s hash value (https://www.blake2.net/blake2.pdf)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>, Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
    Description of semantics:
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/blake.md#BLAKE2s

### Semantics

Tag 32783 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary BLAKE2s [3] hash value encoded in big-endian.
The length of the byte string will characterize the size of the hash function to be used e.g. BLAKE2s-256, BLAKE2s-512 etc.

## BLAKE2bp

    Tag: 32784
    Data item: byte string
    Semantics: Binary BLAKE2bp hash value (https://www.blake2.net/blake2.pdf)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>, Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
    Description of semantics:
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/blake.md#BLAKE2bp

### Semantics

Tag 32784 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary BLAKE2bp [3] hash value encoded in big-endian.
The length of the byte string will characterize the size of the hash function to be used e.g. BLAKE2bp-256, BLAKE2bp-512 etc.

## BLAKE2sp

    Tag: 32785
    Data item: byte string
    Semantics: Binary BLAKE2sp hash value (https://www.blake2.net/blake2.pdf)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>, Alex Pozhylenkov <alex.pozhylenkov@iohk.io>
    Description of semantics:
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/blake.md#BLAKE2s

### Semantics

Tag 32785 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary BLAKE2sp [3] hash value encoded in big-endian.
The length of the byte string will characterize the size of the hash function to be used e.g. BLAKE2sp-256, BLAKE2sp-512 etc.

## References

<!-- markdownlint-disable max-one-sentence-per-line -->
[1] [C. Bormann, and P. Hoffman. "Concise Binary Object Representation (CBOR)". RFC 8949, October 2020.][RFC 8949]

[2] [J. O'Conor, J-P. Aumasson, S. Neves, Z. Wilcox-O'Hearn. "BLAKE3 one function, fast everywhere".][BLAKE3]

[3] [J-P. Aumasson, S. Neves, Z. Wilcox-O'Hearn., C. Winnerlein. "BLAKE2: simpler, smaller, fast as MD5". January 2013.][BLAKE2]
<!-- markdownlint-enable max-one-sentence-per-line -->

## Authors

* Steven Johnson <steven.johnson@iohk.io>
* Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

[RFC 8949]: https://datatracker.ietf.org/doc/html/rfc8949
[BLAKE3]: https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf
[BLAKE2]: https://www.blake2.net/blake2.pdf
