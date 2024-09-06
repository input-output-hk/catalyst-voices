# Cryptography Schema

---

Title: Voting Protocol Cryptography Schema

Status: Proposed

Authors:
    - Alex Pozhylenkov <alex.pozhylenkov@iohk.io>

Created: 2024-09-06

---

## Abstract

This voting protocol is based on this [paper][treasury_system_paper] and on this [specification][treasury_system_spec],
so all formal definitions described in this document you can find there.
It provides a fully anonymous, secured, verifiable schema of casting votes and performing tally process for executing "Catalyst" fund events.

## Motivation

## Specification

### Preliminaries

Through this paper we will use the following notations to refer to some entities of this protocol:

* **Proposals set** $\mathcal{P}:=\{p_1,\ldots, p_k \}$ -
  voting subjects on which each voter will be cast their votes.
  Where $k$ - a number of proposals in the proposals set.
* **Voting committee set** $\mathcal{C}:=\{c_1,\ldots, c_l \}$ -
  a special **trusted** entity, which perform tally process and revealing the results of the tallying.
  It has a capability to de anonymize each vote.
  Where $l$ - a number of voting commitee members in the committee set.
* **Voters set** $\mathcal{V}:=\{v_1,\ldots, v_n \}$.
  Where $n$ - a number of voter members in the voters set.

The generation of the proposals set or proposal submission procedure
aswell as voting committee definition and voters registration
are not subjects of this paper.


### Vote




## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

[treasury_system_paper]: https://eprint.iacr.org/2018/435.pdf
[treasury_system_spec]: https://github.com/input-output-hk/treasury-crypto/blob/master/docs/voting_protocol_spec/Treasury_voting_protocol_spec.pdf
[BLAKE2b-256]: https://www.blake2.net/blake2.pdf
