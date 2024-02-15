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
| Usable  | Accessibility  |   | SC12 |
| Secure   | Access control  | Role-Based Access Control  |   |
| Secure   | Privacy  | User information are kept private  | SC8  |
| Secure   | Accountability  |  |  |
| Reliable   |  Fail-safe | In case of failures the system does not loose data |  SC7 |
| Efficient   |  Response Time |   |   |
| Operable   | Devops-Metrics |   | SC10  |
| Operable   | Testability |   | SC11  |
| Flexibile   |  |   |   |
| Safe   |   |   |   |
| Suitable   |   |   |   |

## Quality Scenarios

|  Id |  Scenario   |
|:-:|:-:|
|  SC1 |  A user who is new to Catalyst can easily understand how to vote. |
|  SC2 |  A user should be able to stop voting and restart voting without loosing votes  |
|  SC3 |  If a user tries to vote on the same proposal twice he will receive a clear error message |
|  SC4 |  After a user cast a vote he will recive a clear and timely feedback on the status of his vote |
|  SC5 |  The system can handle correctly at least 30 votes per second |
|  SC6 |  The system does not permit to vote twice |
|  SC7 |  If the system gets more then 30 votes per second the votes are not lost |
|  SC8 |  User private key are secure(WIP) |
|  SC9 |  Correct search results(WIP) |
|  SC10 |  Rollout of a new feature |
|  SC11 |  Quick Unit tests |
|  SC12 | Localizable to several languages |
