# ULIDs for CBOR

This document specifies a tag for ULIDs in Concise Binary Object Representation (CBOR) [1].

    Tag: 32780
    Data item: byte string
    Semantics: Binary ULID (https://github.com/ulid/spec/tree/master)
    Point of contact: Steven Johnson <steven.johnson@iohk.io>
    Description of semantics: 
    https://github.com/input-output-hk/catalyst-voices/tree/main/docs/src/catalyst-standards/cbor_tags/ulid.md

## Semantics

Tag 32780 can be applied to a byte string (major type 2) to indicate that the byte string
is a binary [ULID] as specified by the [ULID Binary Layout].

## References

<!-- markdownlint-disable max-one-sentence-per-line -->
[1] [C. Bormann, and P. Hoffman. "Concise Binary Object Representation (CBOR)". RFC 8949, October 2020.][RFC 8949]
<!-- markdownlint-enable max-one-sentence-per-line -->

[2] [Universally Unique Lexicographically Sortable Identifier][ULID]

## Author

Steven Johnson <steven.johnson@iohk.io>

[RFC 8949]: https://datatracker.ietf.org/doc/html/rfc8949
[ULID]: https://github.com/ulid/spec/blob/master/README.md
[ULID Binary Layout]: https://github.com/ulid/spec/tree/master#binary-layout-and-byte-order
