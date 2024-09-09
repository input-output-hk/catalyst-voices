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
* **Election public key** $pk$ - a committee's generated public key,
  which is shared across all voters
  and used for vote's encryption and tallying processes.

The generation of the proposals set or proposal submission procedure
aswell as voting committee definition and voters registration
are not subjects of this paper.

### Initial setup

Before any voting will start an initial setup procedure should be performed.

* Define a number of voting options/choices for each proposal,
  e.g. "Yes", "No", "Abstain" - 3 voting options.
* Voting committee must generate a shared election public key.
  If committee consists from more than 1 member,
  it is possible to use some distributed key generation algorithms,
  which is not a topic of the current document.

### Vote

Each voter $v_i$, $i \in [1, n]$ could cast a vote for some proposal $p_j$, $j \in [1, \ldots, k]$.

#### Voting choice

For a specific proposal  voter generates a unit vector $\mathbf{e}_t$, $t \in [1, \ldots, m_j]$.
Where $t$-th component is $1$ and the rest components are $0$,
$m_j$ - proposal's $p_j$ voting options number.

E.g. proposal has 3 voting options ("Yes", "No", "Abstain"), so $m_j$ would be equals to $3$:

* $\mathbf{e}_1$ equals to $100$,
* $\mathbf{e}_2$ equals to $010$,
* $\mathbf{e}_3$ equals to $001$

Lets $e_{t,f}$, $f \in [1, \ldots, m_j]$
denote as an each component value of the unit vector $e_t$.

\begin{equation}
\mathbf{e}_t = (e_{t,1}, \ldots, e_{t,m_j})
\end{equation}

#### Vote encrypting procedure

After the choice is done,
vote **must** be encrypted using shared voting committee public key $pk$.
It is done by using lifted ElGamal encryption algorithm noted as $Enc_{pk}(message; randomness)$.

$Enc_{pk}(message \; ; \; randomness)$ algorithm produces a ciphertext $c$ as a result.
\begin{equation}
c = Enc_{pk}(message \; ; \; randomness)
\end{equation}

To do that, by the provided unit vector $\mathbf{e}_t$
for each vector component value $e_{t,f}$ generate a corresponding $r_f$ randomness.
Therefore for each corresponding $r_f$ and component of the unit vector $e_{t,f}$
apply encryption algorithm and get ciphertext values $c_f$.
Encryption is done using the shared election public key $pk$.
\begin{equation}
c_f = Enc_{pk}(e_{t,f} \; ; \; r_f)
\end{equation}

As a result getting a vector $\mathbf{c}$ of ciphertext values $c_f$,
with the size equals of the size $\mathbf{e}_t$ unit vector.
Lets denote this vector as:
\begin{equation}
\mathbf{c} = (c_1, \ldots, c_{m_j})
\end{equation}

This is a first part of the published vote for a specific proposal.

#### Voter's proof


## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

### A Lifted ElGamal

### B


[treasury_system_paper]: https://eprint.iacr.org/2018/435.pdf
[treasury_system_spec]: https://github.com/input-output-hk/treasury-crypto/blob/master/docs/voting_protocol_spec/Treasury_voting_protocol_spec.pdf
[BLAKE2b-256]: https://www.blake2.net/blake2.pdf
