# ULIDs for CBOR

This document specifies a tag for ULIDs in Concise Binary Object Representation (CBOR) [1].

    Tag: 32770
    Data item: byte string
    Semantics: Binary ULID (https://github.com/ulid/spec/tree/master)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>
    Description of semantics: https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/ulid.md

## Semantics

Tag 32770 can be applied to a byte string (major type 2) to indicate that the byte string is a binary [ULID] as specified by the [ULID Binary Layout].

## References

[1] C.
Bormann, and P.
Hoffman.
"Concise Binary Object Representation (CBOR)".
RFC 7049, October 2013.

[2] [Universally Unique Lexicographically Sortable Identifier][ULID]

## Author

Steven Johnson <steven.johnson@iohk.io>

[ULID]: https://github.com/ulid/spec/blob/master/README.md
[ULID Binary Layout]: https://github.com/ulid/spec/tree/master#binary-layout-and-byte-order
