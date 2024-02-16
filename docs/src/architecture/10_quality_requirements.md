---
icon: material/quality-high
---

# Quality Requirements (WIP)

<!-- See: https://docs.arc42.org/section-10/ -->

## Quality Tree

|  Quality Category |  Quality   |  Description | Scenarios  |
|:-:|:-:|:-:|:-:|
|  Usable |  User experience  | Voting and browsing proposals should be easy and intuitive to do  | SC1 SC2 SC3 SC4|
| Usable  | Correctness  | System functions should provide accurate results | SC9 |
| Usable  | Accessibility  | The system should be design so as to be usable by everyone  | SC12 SC13|
| Secure   | Access control  | Role-Based Access Control  | SC14  |
| Secure   | Privacy  | User information are kept private  | SC8  |
| Secure   | Accountability  | Voting results can be audited by external parties  | SC15 |
| Reliable   |  Fail-safe | In case of failures the system does not loose data |  SC7 |
| Efficient   |  Response Time | The system should give feedback in timenly manner |   |
| Efficient   |  Code Complexity |  Code should be easy to understand and well documented |   |
| Operable   | Deployability |  The system should be easy to deploy | SC10  |
| Operable   | Testability | Tests should be easy to run and give a clear feedback   | SC11 SC16  |
| Operable   | Clarity | Clarity in technical documentation  | |
| Flexibile   | Configurable |  Efficient change of buisness rules |   |
| Safe   |   |   |   |
| Suitable   |   |   |   |

## Quality Scenarios

|  Id |  Scenario   |
|:-:|:-:|
|  SC1 |  A user who is new to Catalyst can easily understand how to vote. |
|  SC2 |  A user should be able to stop voting and restart voting without loosing votes  |
|  SC3 |  If a user tries to vote on the same proposal twice he will receive a clear error message |
|  SC4 |  After a user cast a vote he will reicive a clear and timely feedback on the status of his vote |
|  SC5 |  The system can handle correctly at least 30 votes per second |
|  SC6 |  The system does not permit to vote twice |
|  SC7 |  If the system gets more then 30 votes per second the votes are not lost |
|  SC8 |  User private key are secure |
|  SC9 |  Correct search results |
|  SC10 |  Rollout of a new feature |
|  SC11 |  Quick Unit tests |
|  SC12 | Localizable to several languages |
|  SC13 | Compliance with WCA accessibility guidelines |
|  SC14 | A Drep needs to register |
|  SC15 | A user can tally the vote |
|  SC16 | Clear test reporting |
