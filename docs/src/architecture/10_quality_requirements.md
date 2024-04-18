---
icon: material/quality-high
---

# Quality Requirements (WIP)

<!-- See: https://docs.arc42.org/section-10/ -->

## Quality Tree

|  Quality Category |  Quality   |  Description | Scenarios  |

|:-:|:-:|:-:|:-:|
| Usable  |  Voting User experience  | Voting and browsing proposals should be easy and intuitive to do  | SC1-SC11 |
| Usable  |  Proposer User experience  | Voting and browsing proposals should be easy and intuitive to do  | SC12-SC15 |
| Usable  |  Correctness  | System functions should provide accurate results | SC9 |
| Usable  |  Accessibility  | The system should be design so as to be usable by everyone  | SC12 SC13|
| Secure   |  Access control  | Role-Based Access Control  | SC24-SC31  |
| Secure   |  Privacy  | User information are kept private  | SC8  |
| Secure   |  Auditability  | Voting results can be audited by external parties  | SC20-SC23 |
| Secure   |  Compliancy  |  | SC40-SC41 |
| Reliable   |  Fail-safe  | In case of failures the system does not loose data |  SC7 |
| Reliable   |  Integrity of the vote |  |  SC16-SC19 |
| Reliable   |  Scalability  |  |  SC43-SC49 |
| Efficient   |  Response Time  | The system should give feedback in timely manner |   |
| Efficient   |  Code Complexity  |  Code should be easy to understand and well documented |   |
| Operable   |  Deployability  |  The system should be easy to deploy and operate | SC37-SC40  |
| Operable   |  Testability  | Tests should be easy to run and give a clear feedback   | SC11 SC16  |
| Operable   |  Clarity  | Clarity in technical documentation  | |
| Flexible   |  Configurable  |  Efficient change of business rules | SC32-SC36   |
| Safe   |   |   |   |

## Quality Scenarios

|  Id |  Scenario   |
|:-:|:-:|
|  SC1 |  A user who is new to Catalyst can easily understand how to vote. |
|  SC2 |  A user should be able to stop voting and restart voting without loosing votes  |
|  SC3 |  If a user tries to vote on the same proposal twice he will receive a clear error message |
|  SC4 |  After a user cast a vote he will receive a clear and timely feedback on the status of his vote |
|  SC5 |  Proposals are fully loaded and able to be navigated by user in less than 10 seconds |
|  SC6 |  Search / sort / filter results returned in less than 5 seconds |
|  SC7 |  User clicks on one of the top 5 search results in at least 80% of search queries |
|  SC8 |  A user can vote in less than 3 clicks from loading proposals page |
|  SC9 |  A user can vote on another proposal in less than 2 clicks after voting on one proposal |
|  SC10 |  User gets confirmation of votes cast in less than 5 seconds |
|  SC11 |  User gets confirmation of votes confirmed in less than 30s |
|  SC12 |  More than 80% of proposals are submitted to a vote within 6 months of creation |
|  SC13 |  Less than 10% of proposals are reassigned to a new category between initial category select & submission |
|  SC14 |  Less than 10% of proposals are withdrawn from an event once submitted |
|  SC15 |  More than 80% of proposals are ready for submission in less than 10 editing sessions |
|  SC16 |  100% of votes confirmed are represented in final tally |
|  SC17 |  Less than 5% of votes cast are rejected |
|  SC18 |  100% of rejected transactions have known reason |
|  SC19 |  100% transactions sent to chain are traceable |
|  SC20 | All voters can be verified against mainnet snapshot |
|  SC21 | All voting power can be verified against mainnet snapshot |
|  SC22 | All votes cast are represented in tally |
|  SC23 | Tally is correctly calculated given all votes |
|  SC24 | User gets new access permissions within 60s of role registration tx confirmation |
|  SC25 | Only registered proposers may create, update, or delete a proposal |
|  SC26 | As a voter, I can only delegate voting power to dreps that have a valid drep registration |
|  SC27 | Only a registered drep may vote with delegated voting power |
|  SC28 | As a user, I need to sign my votes with a voter key |
|  SC29 | As a user, I need to sign proposal updates with a proposer key |
|  SC30 | As a user, I need to sign my drep votes with a drep key |
|  SC31 | As a user, I need to sign team-owned proposal updates with a team key |
|  SC32 | Able to handle arbitrary configurations of fund parameters |
|  SC33 | Able to handle arbitrary configurations of proposal template |
|  SC34 | Able to handle arbitrary configurations of category template |
|  SC35 | Able to integrate new modules in the future |
|  SC36 | Able to integrate open source community contributions |
|  SC37 | A single event can be administered by a single non technical user |
|  SC38 | Overall platform can be maintained by 1 SRE, 2 SWE, 1 QA |
|  SC39 | Important metrics viewable by non technical users |
|  SC40 | New versions can be deployed by SRE in less than 1 hour |
|  SC41 | On chain immutable record of registrations, proposals, votes, and tally for every event |
|  SC42 | KYC maintained by 3rd party for all relevant user types |
|  SC43 | Up to 1M concurrent users - wallet connect, login, registration, proposal create, comment, vote |
|  SC44 | Up to 100 votes per second |
|  SC45 | Up to 10 people editing the same proposal |
|  SC45 | Up to 50 concurrent brands / customers running parallel events on platform |
|  SC46 | Up to 500 concurrent events / voting rounds |
|  SC47 | Up to 100k proposals |
|  SC48 | Up to 500k comments |
|  SC49 | Up to 250k registered accounts |

|  SC5 |  The system can handle correctly at least 30 votes per second |
|  SC6 |  The system does not permit to vote twice |
|  SC7 |  If the system gets more then 30 votes per second the votes are not lost |
|  SC8 |  User private key are secure |
|  SC9 |  Correct search results |
|  SC10 |  Rollout of a new feature |
|  SC11 |  Quick Unit tests |
|  SC12 | Localizable to several languages |
|  SC13 | Compliance with WCA accessibility guidelines
|  SC16 | Clear test reporting |
