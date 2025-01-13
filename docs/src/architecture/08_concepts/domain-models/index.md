---
## icon: material/view-module
---

# Entity Catalog

| **Entity Name** | **Type** | **Brief Description** | **Details Link** |
| ----------- | ---- | ----------------- | ------------ |
| **Brand** | Instance | Represents an organization or initiative creating campaigns | [Brand Details](./instances/brand/) |
| **Brand Template** | Template | Defines the structure for Brand Parameters Documents | [Brand Template Details](./instances/brand_template/) |
| **Campaign** | Instance | A specific funding initiative within a brand | [Campaign Details](./instances/campaign/) |
| **Campaign Template** | Template | Defines the reusable structure for Campaign Parameters Documents | [Campaign Template Details](./instances/campaign_template/) |
| **Category** | Instance | A grouping for proposals within a campaign | [Category Details](./instances/category/) |
| **Category Template** | Template | Defines the structure for Category Parameters Documents | [Category Template Details](./instances/category_template/) |
| **Comment** | Instance | User feedback on a proposal | [Comment Details](./instances/comment/) |
| **Comment Template** | Template | Defines the reusable structure for Comment Documents | [Comment Template Details](./instances/comment_template/) |
| **Event** | Instance | A time-bound activity within a campaign | [Event Details](./instances/event/) |
| **Proposal** | Instance | A user-submitted application for funding | [Proposal Details](./instances/proposal/) |
| **Proposal Template** | Template | Defines the structure and required elements for proposals | [Proposal Template Details](./instances/proposal_template/) |
| **Proposal Template Meta Schema** | Template | Defines the structure and required elements for proposal templates | [Proposal Template Meta Schema Details](./instances/proposal_template_meta_schema/) |
| **Review** | Instance | An assessment of a proposal | [Review Details](./instances/review/) |
| **Review Template** | Template | Defines the structure and required elements for Review Documents | [Review Template Details](./instances/review_template/) |
| **Role** | Instance | Specific roles with conditions, rules governing allowed actions | [Role Details](./instances/role/) |
| **Rule** | Instance | Defines reusable operational conditions for participation | [Rule Details](./instances/rule/) |
| **Space** | Instance | Represents stages for proposals, e.g., Discovery Space | [Space Details](./instances/space/) |
| **Vote** | Instance | A user's decision on a proposal | [Vote Details](./instances/vote/) |
| **ProposalSubmission** | Action | Stores record of proposal submission action | [Actions Details](./instances/proposal_submission/) |
| **ProposalRetraction** | Action | Stores record of proposal retraction action | [Actions Details](./instances/proposal_retraction/) |
| **DocumentRetraction** (TBD) | Action | Generic retraction action on any document type if specifics are not required | [Actions Details](./instances/document_retraction/) |
| **ProposalModerationBlock** | Action | Stores record of an action taken by a moderator to block a proposal | [Actions Details](./instances/proposal_moderation_block/) |

## **Categorization**

* **Instance:** Core documents that represent primary entity instances within Catalyst.
* **Templates:** Define the structure and validation rules for corresponding entity instances.
* **Action:** Action functionalities such as moderation and retraction, managing interactions and data integrity.
* **Specification:** ToDo: proposal template meta defined by spec, rules could be spec

## Metadata Headers for Entity Identification and References

### Common metadata attributes

| **Attribute** | **Required** | **Type**                 | **Category**       | **Description**                                                       | **Constraints**                                                                                                         | **Notes**                                        |
| ------------- | ------------ | ------------------------ | ------------------ | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `id`          | Yes          | UUID                     | Unprotected header | Unique identifier for the entity                                      | Primary Key                                                                                                             | Ensures global uniqueness for the entity.        |
| `ver`         | Yes          | ULID                     | Unprotected header | Version ID for the Proposal                                           | The initial ver assigned when published will be identical to the `id`                                                   | Enables versioning and traceability.             |
| `alg`         | Yes          | String                   | Unprotected header | Indicates the cryptography algorithm used for the security processing | It must be equal to EdDSA value.                                                                                        |                                                  |
| `type`        | Yes          | ULID or CBOR Array       | Unprotected header | Indicates the content type of the COSE payload                        | Define Media Types from IANA where possible [Reference](https://www.iana.org/assignments/media-types/media-types.xhtml) |                                                  |
| `encoding`    | Yes          | ULID or CBOR Array       | Unprotected header | Indicate the content encoding algorithm of the payload                | Current supported encoding algorithms: br - Brotli compressed data.                                                     |                                                  |
| `kid`         | Yes          | UTF-8 encoded URI string | Protected header   | A unique identifier of the signer.                                    | Each Catalyst Signed Document COSE signature must include the following protected header field                          |                                                  |
| `ref`         | Optional     | ULID or CBOR Array       | Reference          | References related entities                                           | Linked Record Constraint                                                                                                | `[<id>, <ver>]` format for version linking.      |
| `ref_hash`    | Optional     | ULID or CBOR Array       | Security           | This is a cryptographically secured reference to another document.    | Cryptographically secured Linked Record Constraint                                                                      | Hash of the referenced document CBOR bytes       |
| `template`    | Yes          | ULID or CBOR Array       | Reference          | Template guiding the entity structure                                 | Must reference an existing Template entity                                                                              | `[<id>, <ver>]` ensures traceable references.    |
| `reply`       | Optional     | CBOR Array               | Reference          | Identifies the entity this is replying to                             | Optional; `[<id>, <ver>]` format                                                                                        | Typically used for comments or discussions.      |
| `section`     | Optional     | JSON Path                | Reference          | Links to a specific section of a document                             | Must comply with valid JSON Path syntax                                                                                 | Useful for granular referencing within payloads. |
| `collabs`     | Optional     | CBOR Array               | Security           | Authorized collaborators for the entity                               | Must be valid collaborator address                                                                                      | Ensures multi party editing is traceable.        |

## Entity Relationship (Work In Progress)

```d2
{{ include_file('diagrams/entity_fund14.d2') }}
```
