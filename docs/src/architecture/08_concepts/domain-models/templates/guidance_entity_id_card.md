---
## icon: material/pencil-ruler
---

# **Entity Identity Card**

---

## **Sample with guidance**

---

### **Entity Name & Purpose**

| **Aspect** | **Description** |
| ------ | ----------- |
| **Name** | *Name of the entity (e.g., Proposal, Fund, Comment)* |
| **Purpose/Role** | *Brief description of what this entity represents and its role in the system.* |
| **Scope** | *Define if this entity is user-generated/owned, dApp (catalyst) owned, or system-controlled.* |

---

### **Ownership & Control**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Data Owner** | User / dApp | *(Who owns the data? Specify if it's user-generated or operational data owned by the dApp.)* |
| **Controller** | User / dApp / Shared | *(Who controls updates and access? Examples: who controls the cryptographic keys if applicable, potential for multi party control. )* |
| **Permissions** | Consent Based / Implicit | *(Is access explicitly granted by the owner, or implicitly set by system rules?)* |
| **Storage Controller** | User / dApp / Third-Party | *(Who is responsible for storing the data?)* |

---

### **Schema & Lifecycle**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Schema Stability** | Fixed / Flexible | *(Is the schema immutable or flexible? If flexible, what governance process governs schema changes and does the dApp define these processes?)* |
| **Versioning** | Linked Records / Overwrite | *(Define if updates create new versions or overwrite existing data. Note: All data stored in public distributed platforms must specify `Linked Records`)* |
| **Version History** | Time-bound / Indefinite | *(Define the rules governing responsibility for the lifecycle of historical versions.)* |
| **Lifecycle Stages** | Draft → Published → Archived | *(Define the entity's progression through different states. Reference external state, sequence and flow diagrams that are relevant.)* |
| **Validation Rules** | Strict / Flexible | *(Are data inputs strictly validated and how are validation rules enforced? Examples: Schema adherence, constraints.)* |
| **Required Fields** | Yes / No | *(Is there a minimum set of fields required for the entity's validity are the detailed in the schema?)* |
| **Expected Lifespan** | Short-lived / Long-lived / Indefinite | *(Expected lifespan of this entity.)* |
| **Archival Needs** | Indefinite / Conditional / None | *(Is archival required post-lifecycle completion? Justify reasoning as there are ownership and cost implications depending on the choice)* |

---

### **Visibility & Storage**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Public vs Private** | Public / Private / Hybrid | *(Define access levels throughout lifecycle, e.g., drafts private, submissions public.)* |
| **Storage Location** | User-Determined / Enforced / dApp provided | *(Where is the data stored? Examples: IPFS, Arweave, Filecoin, centralized backend, local disk)* |
| **Public Persistence** | IPFS, Filecoin, or Other | *(Mechanisms ensuring availability, such as decentralized storage redundancy.)* |
| **Data Impermanence** | Handled Gracefully | *(What happens if storage nodes fail? User responsibilities for re-pinning or redundancy.)* |

---

### **Access & Security**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Encryption** | Default On / Optional | *(Is encryption required for drafts or optional for published data?)* |
| **Encryption Key Owner** | User / dApp / Shared | *(Who controls the keys required for encryption? Align with section Ownership & Control:Controller)* |
| **Consent Rules** | Time-bound / Conditional | *(Define explicit conditions under which access is granted, revoked, or expired by the owner. Note: unless the data is encrypted it is not possible to withdraw consent from public documents)* |
| **Traceability** | Historical Linked Records / None | *(Is there an immutable audit trail of changes? Helps ensure trust and accountability.)* |

---

### **Integration & Rules Enforcement**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Mandatory Participation Conditions** | dApp Enforced / User Choice | *(Rules for submission, access, or interactions, e.g., deadlines or visibility requirements.)* |
| **Non-Compliance Consequences** | Ignored / Flagged | *(Entity impact for dapp rule violations, e.g., Blocked / Flagged / Moderated etc.)* |
| **Validation Mechanism** | Community Moderation / dApp Enforcement / Smart Contract Logic | *(How rules are enforced through available methods.)* |

---

### **Relationships**

Note: The following table is for illustration purposes only, the content of the relationship table will be determined by the entity
and its use case.

| **Source Entity** | **Target Entity** | **Relationship Type** | **Cardinality** (Source → Target) | **Cardinality** (Target → Source) | **Description**                                                                  |
| ----------------- | ----------------- | --------------------- | --------------------------------- | --------------------------------- | -------------------------------------------------------------------------------- |
| Proposal          | ProposalSchema    | Depends On            | 1..1                              | 0..*                              | Each proposal requires one schema. A schema can be used by many proposals.       |
| Proposal          | Fund              | Depends On            | 1..1                              | 0..*                              | Each proposal is associated with one fund. A fund can support many proposals.    |

---

### **Regulatory & Compliance Considerations**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Data Liability** | User / Shared / dApp | *(Who bears compliance responsibility under regulations like GDPR/CCPA?)* |
| **Regulatory Impacts** | Minimal Data Enforced | *(Ensure alignment with regulations via minimal data collection and clear user consent.)* |
| **Data Removal** | Append-Only / Superseded | *(Define mechanisms for marking data obsolete or superseded in immutable systems.)* |

---

### **Financial Considerations**

| **Aspect** | **Decision** | **Guidance/Notes** |
| ------ | -------- | -------------- |
| **Cost Bearer** | Who is responsible for paying storage costs for this entity’s data? | *(Who pays for storage, e.g., IPFS pinning costs?) Include details if shared.* |
| **Third-Party Storage** | Yes / No | *(Can a third party store and maintain the entity if they wish? )(Yes / No)* |
| **Funding Method** | Wallet / Transaction Fees / Community | *(How is the data storage and lifecycle financially supported?)* |

---

### **Security and Privacy Handling**

| **Aspect** | **Description** |
| ------ | ----------- |
| **Sensitive Data** | *(Does this entity include sensitive data? If yes, list the types. reference data sensitivity types.)* |
| **Privacy Measures** | *(How is privacy ensured, e.g., anonymization, encryption, limited access.)* |
| **Risk Mitigation** | *(Steps to mitigate privacy/security risks, e.g., GDPR compliance, security audits.)* |

---

### **Languages and Localization**

| **Aspect** | **Description** |
| ------ | ----------- |
| **Supported Languages** | *(List supported languages for this entity, e.g., English, Spanish.)* |
| **Localization Needs** | *(Specify if localization/customization is required for different regions or jurisdictions.)* |

---

### **Licensing and Reuse**

* *Specify applicable licenses (e.g., Creative Commons, MIT License) and reuse constraints of the data.*

---

### **Metadata Attributes**

Note: The following table is for illustration purposes only the content of the attribute table will be determined by the entity
and its use case.

Metadata Attributes are defined in the header of each document, common metadata attributes can appear on every document,
entity metadata attributes are those which have a specific meaning to the current entity.
While they can share a common name across entities their purpose may differ from entity to entity.

#### Common metadata attributes

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

#### Entity metadata attributes

| **Attribute** | **Type** | **Category**      | **Description**                                                            | **Constraints**                                                                            | **Notes**                                               |
| ------------- | -------- | ----------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------- |
| `campaign_id` | UUID     | Additional Fields | Unique identifier of the category the proposal has been published to       | Existing UUID of category, category `brand_id` MUST be the same as the proposal `brand_id` | Ensures each proposal is only published to one category |
| `brand_id`    | UUID     | Additional Fields | Unique identifier of the brand under which the proposal has been submitted | Existing UUID of brand                                                                     | Used for quick lookups on indexes                       |

---

### **Attributes**

Note: The following table is for illustration purposes only the content of the attribute table will be determined by the entity
and its use case.

Entity specific attributes that will appear in the document body.

| **Attribute**    | **Type** | **Required** | **Description**               | **Constraints**                         | **Notes**                             |
| ---------------- | -------- | ------------ | ----------------------------- | --------------------------------------- | ------------------------------------- |
| `title`          | String   | Yes          | Display name for the proposal | Max Length: 255                         | Shown in interfaces for user context. |
| `description`    | String   | Optional     | Summary of the proposal       | Optional, Max Length: 1000              | Displayed as UI/UX content.           |
| `requestedFunds` | Yes      | Presentation | Requested amount in ADA       | Between: 15,000-2,000,000 ADA inclusive |                                       |
| `duration`       | Yes      | Presentation | Project duration in months    | Between 2 and 12 inclusive              |                                       |

---

### **Actions**

Note: The following table is for illustration purposes only the content of the actions table will be determined by the entity
and its use case.

This section defines the actions that can be performed on the entity, the entities that can perform the action and any constraints
 placed on the action

| **Operation**           | **Action owner**                     | **Inputs**                                | **Constraints**                                                                            | **Expected Output**                                                                         | **Output Owner**             | **Additional Notes**                                                                                             |
| ----------------------- | ------------------------------------ | ----------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Create**              | Proposer (owner)                     | Register proposer                         | Proposer must have registered with Catalyst                                                | New proposal document created and assigned a unique ID. (Proposal Document)                 | Proposal creator now `Owner` | Proposal ownership is initially assigned to the creator; metadata includes creation timestamp.                   |
| **Proposal Submission**             | Proposal owner or collaborator       | Proposal ID                               | Proposal must be complete and pass validation                                              | Proposal becomes visible and active  (Proposal Publish Action Document)                     | Proposal Owner               | Transition from draft to public; ensures proposal adheres to all formatting and content guidelines.              |
| **Retract**             | Proposal owner or collaborator       | Proposal ID, reason for retraction        | Restricted to owner; may not retract proposals in active voting or funding phases          | Proposal is marked as retracted; becomes inactive (Proposal Retraction Action Document)     | Proposal Owner               | Retracted proposals remain in the system for record keeping but are excluded from future processes.              |
| **Comment**             | User with role 0 key                 | Proposal ID, comment text                 | User must have commenting permissions; content must adhere to community guidelines         | Comment linked to the proposal   (Comment Document)                                         | Comment creator              | Comments are public documents tied to the proposal; responsibility for the lifecycle remains with the commenter. |
| **Vote**                | Users who have registered for voting | Proposal ID, vote type (Yes, No, Abstain) | User must belong to an eligible voter group; voting period must be active                  | (Vote Document)                                                                             | Voter                        | Voting results are tied to the proposal; individual votes remain private unless explicitly disclosed.            |
| **Review**              | Assigned reviewers                   | Proposal ID, review feedback              | User must be assigned as a reviewer; review criteria must be satisfied                     | Proposal enters reviewed state with feedback    (Review Document)                           | Reviewer                     | Review documents are tied to the proposal but owned by the reviewer, who is responsible for feedback accuracy.   |
| **Approve**             | Assigned reviewers                   | Proposal ID, approval decision            | Restricted to authorized reviewers; approval may require a consensus                       | Proposal is approved and progresses to the next phase   (Approved Action Document)          | Moderator / Catalyst         |                                                                                                                  |
| **Reject**              | Assigned reviewers                   | Proposal ID, rejection reason             | Restricted to authorized reviewers; rejection reason must be provided                      | Proposal is rejected   (Rejected Action Document)                                           | Moderator / Catalyst         | Rejected proposals may be revised and resubmitted depending on system fund policies.                             |
| **Fund**                | Funding authority                    | Proposal ID, funding amount               | Proposal must have met all criteria for funding; funding pool must have sufficient balance | Proposal is marked as funded; funds are allocated   (Funded Action Document)                | Moderator / Catalyst         |                                                                                                                  |
| **Add Collaborator**    | Proposal owner                       | Proposal ID, collaborator ID              | Collaborator must have an active account and accept the invitation                         | Collaborator gains access to the proposal and may contribute (Collaborator Action Document) | Proposal Owner               | Added collaborators inherit specific permissions tied to their role in the proposal.                             |
| **Remove Collaborator** | Proposal owner                       | Proposal ID, collaborator ID              | Collaborator must already be associated with the proposal                                  | Collaborator's access is revoked  (Collaborator Revocation Action Document)                 | Proposal Owner               | Removed collaborators can no longer perform actions on the proposal document                                     |

---

### **Workflow**

* \*Step-by-step description of the entity life cycle and work flows, reference external diagrams

---

### **Error Handling**

* *Description of potential errors or exceptions and how they are handled and by whom.*

---

## Business Rules

* *List of business rules or logic associated with this entity*

---

## Data Flow

* *Description of how data moves into, through, and out of this entity*

---

## Security Considerations

* *Any security-related information specific to this entity*

---

## Open Issues

* *Any unresolved questions or potential future changes related to this entity*

---

### **Iteration Change Log**

| **Version** | **Date** | **Description of Change** | **Author** |
| ------- | ---- | --------------------- | ------ |
| *e.g., v1.0* | *2024-12-20* | *Initial creation of the entity identity card.* | *Name or Role* |
| *e.g., v1.1* | *2024-12-25* | *Added a new attribute to enhance functionality.* | *Name or Role* |

---
