---
Title: Signed Document Types and Metadata
Category: Catalyst
Status: Proposed
Authors:
    - Steven Johnson <steven.johnson@iohk.io>
Implementors: 
    - Catalyst Fund 14
Discussions: []
Created: 2024-12-03
License: CC-BY-4.0
---

* [Abstract](#abstract)
* [Motivation: why is this CIP necessary?](#motivation-why-is-this-cip-necessary)
* [Specification](#specification)
  * [Document Type : `type`](#document-type--type)
    * [Document Type Definitions](#document-type-definitions)
      * [Document Templates](#document-templates)
      * [Document Content Templates](#document-content-templates)
  * [Document Metadata](#document-metadata)
    * [Document ID : `id`](#document-id--id)
    * [Document Version : `ver`](#document-version--ver)
    * [Document Reference : `ref`](#document-reference--ref)
    * [Template Reference : `template`](#template-reference--template)
    * [Document Reference : `reply`](#document-reference--reply)
    * [Document Reference : `section`](#document-reference--section)
    * [Authorized Collaborators : `collabs`](#authorized-collaborators--collabs)
  * [Document Type Specifications](#document-type-specifications)
    * [Proposal Template](#proposal-template)
    * [Comment Template](#comment-template)
    * [Proposal Document](#proposal-document)
    * [Comment Document](#comment-document)
* [Reference Implementation](#reference-implementation)
* [Rationale: how does this CIP achieve its goals?](#rationale-how-does-this-cip-achieve-its-goals)
* [Path to Active](#path-to-active)
  * [Acceptance Criteria](#acceptance-criteria)
  * [Implementation Plan](#implementation-plan)
* [Copyright](#copyright)

## Abstract

Project Catalyst both produces and consumes documents of data.
To ensure the document is authoritative, all documents of this kind will be signed.
In addition to the document contents, documents will also include metadata which describes
what kind of document it is, and how the document relates to other documents.

## Motivation: why is this CIP necessary?

As we decentralize project catalyst, it will be required to unambiguously identify who produced a
document, and the purpose of the document.

A signed document specification will detail the structure of a signed document, this specification
is just the metadata that structure will carry for different kinds of documents.

## Specification

### Document Type : `type`

Each document will have a document type identifier called `type`.
This identifier will be a [CBOR] Encoded [UUID Byte String].
Only [UUID] V4 is supported and used.

The document types and their identifiers are listed here:

#### Document Type Definitions

##### Document Templates

Document Templates are themselves signed documents, the templates currently defined or planned are:

| [UUID] | [CBOR] | Type Description | Payload Type |
| --- | --- | --- | --- |
| 0ce8ab38-9258-4fbc-a62e-7faa6e58318f | `37(h'0ce8ab3892584fbca62e7faa6e58318f')` | Proposal Template | [Brotli] Compressed [JSON Schema] |
| 0b8424d4-ebfd-46e3-9577-1775a69d290c | `37(h'0b8424d4ebfd46e395771775a69d290c')` | Comment Template | [Brotli] Compressed [JSON Schema] |
| ebe5d0bf-5d86-4577-af4d-008fddbe2edc | `37(h'ebe5d0bf5d864577af4d008fddbe2edc')` | Review Template | [Brotli] Compressed [JSON Schema] |
| 65b1e8b0-51f1-46a5-9970-72cdf26884be | `37(h'65b1e8b051f146a5997072cdf26884be')` | Category Parameters Template | [Brotli] Compressed [JSON Schema] |
| 7e8f5fa2-44ce-49c8-bfd5-02af42c179a3 | `37(h'7e8f5fa244ce49c8bfd502af42c179a3')` | Campaign Parameters Template | [Brotli] Compressed [JSON Schema] |
| fd3c1735-80b1-4eea-8d63-5f436d97ea31 | `37(h'fd3c173580b14eea8d635f436d97ea31')` | Brand Parameters Template | [Brotli] Compressed [JSON Schema] |

##### Document Content Templates

Document Contents are signed documents, and are typically produced in accordance with a template document.

| [UUID] | [CBOR] | Type Description | Payload Type |
| --- | --- | --- | --- |
| 7808d2ba-d511-40af-84e8-c0d1625fdfdc | `37(h'7808d2bad51140af84e8c0d1625fdfdc')` | Proposal Document | [Brotli] Compressed [JSON] |
| b679ded3-0e7c-41ba-89f8-da62a17898ea | `37(h'b679ded30e7c41ba89f8da62a17898ea')` | Comment Document | [Brotli] Compressed [JSON] |
| e4caf5f0-098b-45fd-94f3-0702a4573db5 | `37(h'e4caf5f0098b45fd94f30702a4573db5')` | Review Document | [Brotli] Compressed [JSON] |
| 48c20109-362a-4d32-9bba-e0a9cf8b45be | `37(h'48c20109362a4d329bbae0a9cf8b45be')` | Category Parameters Document | [Brotli] Compressed [JSON] |
| 0110ea96-a555-47ce-8408-36efe6ed6f7c | `37(h'0110ea96a55547ce840836efe6ed6f7c')` | Campaign Parameters Document | [Brotli] Compressed [JSON] |
| 3e4808cc-c86e-467b-9702-d60baa9d1fca | `37(h'3e4808ccc86e467b9702d60baa9d1fca')` | Brand Parameters Document | [Brotli] Compressed [JSON] |
| 5e60e623-ad02-4a1b-a1ac-406db978ee48 | `37(h'5e60e623ad024a1ba1ac406db978ee48')` | Proposal Action Document | *TBD* |

### Document Metadata

Documents will contain metadata which allows the document to be categorized, versioned and linked.
This data does not properly belong inside the document,
but is critical to ensure the document is properly referenced and indexable.

#### Document ID : `id`

<!-- markdownlint-disable MD036 -->
**REQUIRED, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

Every document will have a unique document ID, this is to allow the same document to be referenced.
All documents with the same `doc_id` are considered versions of the same document.
However, `id` uniqueness is only guaranteed on first use.

If the same `id` is used, by unauthorized publishers, the document is invalid.

The `id` is a [UUID].
This identifier will be a [CBOR] Encoded [UUID Byte String].
Only [UUID] V7 is supported and used.

The first time a document is created, it will be assigned by the creator a new `id` which must
be well constructed.

* The time must be the time the document was first created.
* The random value must be truly random.

Creating `id` this way ensures there are no collisions, and they can be independently created without central co-ordination.

*Note: All documents are signed, the first creation of a `id` assigns that `id` to the creator and any assigned collaborators.
A Signed Document that is not signed by the creator, or an assigned collaborator, is invalid.
There is no reasonable way a `id` can collide accidentally.
Therefore, detection of invalid `id`s published by unauthorized publishers, could result in anti-spam
or system integrity mitigations being triggered.
This could result in all actions in the system being blocked by the offending publisher,
including all otherwise legitimate publications by the same author being marked as fraudulent.*

#### Document Version : `ver`

<!-- markdownlint-disable MD036 -->
**REQUIRED, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

Every document in the system will be versioned.
There can, and probably will, exist multiple versions of the same document.

The `ver` is a [UUID].
This identifier will be a [CBOR] Encoded [UUID Byte String].
Only [UUID] V7 is supported and used.

The initial `ver` assigned the first time a document is published will be identical to the [`id`](#document-id--id).
Subsequent versions will retain the same [`id`](#document-id--id) and will create a new `ver`,
following best practice for creating a new [UUID] v7.

#### Document Reference : `ref`

<!-- markdownlint-disable MD036 -->
**OPTIONAL, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

This is a reference to another document.  
The purpose of the `ref` will vary depending on the document [`type`](#document-type--type).

The `ref` can be either a single [UUID] or a [CBOR] Array of Two [UUID].

If the `ref` is a single [UUID], it is a reference to the document of that [`id`](#document-id--id).
If the `ref` is a [CBOR] array, it has the form `[<id>,<ver>]` where:

* `<id>` = the [UUID] of the referenced documents [`id`](#document-id--id)
* `<ver>` = the [UUID] of the referenced documents [`ver`](#document-version--ver).

#### Template Reference : `template`

<!-- markdownlint-disable MD036 -->
**REQUIRED, IF THE DOCUMENT WAS FORMED FROM A TEMPLATE, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

If the document was formed from a template, this is a reference to that template document.
The format is the same as the [CBOR] Array form of [`ref`](#document-reference--ref).

It is invalid not to reference the template that formed a document.
If this is missing from such documents, the document will itself be considered invalid.

Template references must explicitly reference both the Template Document ID, and Version.

#### Document Reference : `reply`

<!-- markdownlint-disable MD036 -->
**OPTIONAL, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

This is a reply to another document.
The format is the same as the [CBOR] Array form of [`ref`](#document-reference--ref).

`reply` is always referencing a document of the same type, and that document must `ref` reference the same document `id`.
However, depending on the document type, it may reference a different `ver` of that `id`.

#### Document Reference : `section`

<!-- markdownlint-disable MD036 -->
**OPTIONAL, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

This is a reference to a section of a document.
It is a CBOR String, and contains a [JSON Path] identifying the section in question.

Because this metadata field uses [JSON Path], it can only be used to reference a document whose payload is [JSON].

#### Authorized Collaborators : `collabs`

<!-- markdownlint-disable MD036 -->
**OPTIONAL, PROTECTED HEADER**
<!-- markdownlint-enable MD036 -->

This is a list of entities other than the original author that may also publish versions of this document.
This may be updated by the original author, or any collaborator that is given "author" privileges.

The latest `collabs` list in the latest version, published by an authorized author is the definitive
list of allowed collaborators after that point.

The `collabs` list is a [CBOR] Array.
The contents of the array are TBD.

However, they will contain enough information such that each collaborator can be uniquely identified and validated.

*Note: An Author can unilaterally set the `collabs` list to any list of collaborators.
It does NOT mean that the listed collaborators have agreed to collaborate, only that the Author
gives them permission to.*

This list can impact actions that can be performed by the `Proposal Action Document`.

### Document Type Specifications

Note, not all document types are currently specified.

#### Proposal Template

This document provides the template structure which a Proposal must be formatted to, and validated against.

#### Comment Template

This document pr provides the template structure which a Comment must be formatted to, and validated against.

#### Proposal Document

This is a document, formatted against the referenced proposal template, which defines a proposal which may be submitted
for consideration under one or more brand campaign categories.

The brand, campaign and category are not part of the document because the document can exist outside this boundary.
They are defined when a specific document is submitted for consideration.

#### Comment Document

This is a document which provides a comment against a particular proposal.
Because comments are informed by a particular proposals version, they *MUST* contain a [`ref`](#document-reference--ref)

They may *OPTIONALLY* also contain a [`reply`](#document-reference--reply) metadata field, which is a reference to another comment,
where the comment is in reply to the referenced comment.

Comments may only [`reply`](#document-reference--reply) to a single other comment document.
The referenced `comment` must be for the same proposal [`id`](#document-id--id),
but can be for a different proposal [`ver`](#document-version--ver).

Comments may *OPTIONALLY* also contain a [`subsection`](#document-reference--section) field,
when the comment only applies to a specific section to the document being commented upon,
and not the entire document.

## Reference Implementation

The first implementation will be Catalyst Voices.

*TODO: Generate a set of test vectors which conform to this specification.*

## Rationale: how does this CIP achieve its goals?

By specifying metadata attached to signed documents and unambiguous document type identifiers, we allow
documents to be broadcast over insecure means, and for their meaning and relationships to remain intact.

The Document itself is soft, but the metadata provides concrete relationships between documents.

## Path to Active

### Acceptance Criteria

Working Implementation before Fund 14.

### Implementation Plan

Fund 14 project catalyst will deploy this scheme for Key derivation.>

## Copyright

This document is licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode).

[UUID Byte String]: https://github.com/lucas-clemente/cbor-specs/blob/master/uuid.md
[JSON Schema]: https://json-schema.org/draft-07
[Brotli]: https://datatracker.ietf.org/doc/html/rfc7932
[JSON]: https://datatracker.ietf.org/doc/html/rfc7159
[CBOR]: https://datatracker.ietf.org/doc/html/rfc8610
[UUID]: https://www.rfc-editor.org/rfc/rfc9562.html
[JSON Path]: https://datatracker.ietf.org/doc/html/rfc9535
