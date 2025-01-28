---
icon: material/account
---
# Roles/Actors

The system defines several roles/actors that interact with entities to achieve various operational goals.
These roles include users and administrative entities that manage, review, or vote on proposals and campaigns.

| **Role/Actor**  | **Description**                                                            | **Responsibilities**                                                                      |
| --------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| **Admin**       | Campaign manager responsible for proposal oversight.                       | Configure campaigns, assign reviewers, moderate content.                                  |
| **Delegator**   | Assigns voting power to other users                                        | Has the ability to assign voting power to another role                                    |
| **Moderator**   | Oversees moderation tasks within the system.                               | Classify and address flagged comments or proposals, ensure system integrity.              |
| **Proposer**    | User who creates and submits proposals.                                    | Draft proposals, respond to campaign questions, manage proposal life cycles.              |
| **Reviewer**    | Assesses and provides feedback on proposals.                               | Review proposals, submit ratings, offer detailed feedback.                                |
| **Role Zero**   | Base role for any user who registers with catalyst.                        | Base features, request additional roles, comment on proposals.                            |
| Super Admin     | `Out of scope?` Oversees system-wide settings, brand, and role management. | Manage the brand, global roles, ensure operational compliance, configure system settings. |
| Tally Committee | `Out of scope?` Group responsible for managing the vote tallying process.  | Oversee and ensure accurate tallying for campaigns or events.                             |
| **Vote Tally**  | Automates vote verification and result calculations.                       | Verify votes, calculate outcomes, generate reports.                                       |
| **Voter**       | User who votes on proposals and delegates voting power.                    | Cast votes, delegate voting power, view voting results.                                   |

> ❓ Info
>
> * Is the role that can comment on proposals the same as the reviewer or can anyone with role zero comment?
> * Does a reviewer get additional responsibilities and if so do we need separate roles for each type of reviewer
> or can we just have a single role with varying abilities based on reputation or other measure as discussed ?
>