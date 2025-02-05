---
icon: material/details
---

# Data Attributes

## Data Sensitivity Types

Data sensitivity types categorize data entities based on their content, context, and associated regulatory risks.
These classifications help identify and manage the inherent risks of handling data related to different data categories, ranging
from user-generated content to cryptographic keys and financial data.

Each data sensitivity type is associated with varying levels of sensitivity and regulatory scrutiny, influenced by frameworks like
GDPR, CCPA, and other global data protection laws.
By organizing data into these types, we can assess our regulatory obligations, implement appropriate safeguards, and address
compliance considerations effectively.
These sensitivity levels are adaptable and can be expanded or refined based on our specific domain and specific regulatory
requirements.

| Type                               | Short Description                        | Risk in Relation to Regulations                                     |
| ---------------------------------- | ---------------------------------------- | ------------------------------------------------------------------- |
| User Content                       | Data created or shared by users          | Moderate; subject to content regulations and copyright laws         |
| User Metadata                      | Information about user activity          | High; often falls under data protection laws like GDPR              |
| User Activity Data                 | Behavioral data on platform interactions | High; subject to privacy regulations and data processing laws       |
| Identifiable Data                  | Data directly identifying a user         | Very High; core focus of most data protection regulations           |
| S/PII                              | Highly sensitive personal information    | Extremely High; strictly regulated under multiple laws              |
| Business Data                      | Proprietary business information         | Moderate; subject to trade secret and corporate governance laws     |
| Pseudonymous Data                  | Data linked to aliases or pseudonyms     | Moderate; may be subject to data protection laws if re-identifiable |
| Anonymous Data                     | Data not linkable to individuals         | Low; generally less regulated but anonymization must be robust      |
| Cryptographic Keys                 | Private keys for digital asset access    | High; subject to financial regulations and cybersecurity laws       |
| Transaction Metadata               | Details about blockchain transactions    | Moderate; may fall under financial regulations and AML laws         |
| Decentralized Identity Information | Self-sovereign identity data             | High; emerging area with evolving regulatory landscape              |
| Tokenized Assets                   | Digital representations of ownership     | High; subject to securities laws and financial regulations          |
| Encrypted Communications           | Private messages on platforms            | Moderate; subject to encryption and data protection laws            |
| Governance Data                    | Voting and proposal information in DAOs  | Moderate; may fall under corporate governance regulations           |
| Zero-Knowledge Proofs              | Cryptographic validation data            | Low to Moderate; emerging technology with evolving regulations      |
| Finance Data                       | Financial activity data                  | Very High; subject to financial regulations                         |
