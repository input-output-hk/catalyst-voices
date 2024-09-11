<!-- cspell: words mathbf Gamal homomorphically ipfs -->

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
It provides a fully anonymous, secured, verifiable schema of casting votes
and performing tally process for executing "Catalyst" fund events.

## Motivation

## Specification

### Preliminaries

Through this paper we will use the following notations to refer to some entities of this protocol:

* **Proposal** -
  voting subject on which each voter will be cast their votes.
* **Proposal voting options** -
  an amount of different proposal options, e.g. "Yes", "No", "Abstain".
* **Voting committee** -
  a special **trusted** entity, which perform tally process and revealing the results of the tallying.
  Such committee consists of the 1 person.
* **Voters** -
  actors who actually performing the voting by posting ballots with their voting choices.
* **Election public key** $pk$ - a committee's generated public key,
  which is shared across all voters
  and used for vote's encryption and tallying processes.
* **Voter's voting power** -
  an integer value which defines a voting power for a specific voter.
  This value could be equals to $1$ for every voter,
  so everyone would be equal in their voting rights.
  Or it could be defined based on their stake in the blockchain,
  which is more appropriate for web3 systems.

Important to note that current protocol defined to work with the one specific proposal,
so all definitions and procedures would be applied for some proposal.
Obviously, it could be easily scaled for a set of proposals,
performing all this protocol in parallel.

The voting committee and voters registration/definition
are not subjects of this paper.

### Initial setup

Before any voting will start an initial setup procedure should be performed.

* Define a number of voting options/choices for a proposal,
  e.g. "Yes", "No", "Abstain" - 3 voting options.
* Voting committee must generate a shared election public key $pk$ and distribute it among voters.
  A corresponding private key (secret share) $sk$ will be used to perform tally.
* Define for each voter their own voting power.
  Basically this step could be done at any point of time, but before the tally.

### Vote

Each voter $v_i$, $i \in [1, n]$ could cast a vote for the proposal $\mathcal{P}$.
To do that, obviously, a voting choice should be made and decoded in specific format.
Next step to achieve the anonymity this voting choice must be encrypted,
using the specific election public key, so later voting committee could perform tally.
It is also important for the voter generate a cryptographically secured proof,
that he has done everything correctly and according to the protocol,
and everyone would be able to verify it.
So we will preserve anonymity without lacking transparency and correctness.

#### Voting choice

For a specific proposal $\mathcal{P}$
voter generates a unit vector $\mathbf{e}_t$, $t \in [1, \ldots, M]$.
Where $t$-th component is $1$ and the rest components are $0$,
$M$ - proposal's voting options number.

E.g. proposal has 3 voting options ("Yes", "No", "Abstain"):

* $\mathbf{e}_1$ equals to $100$,
* $\mathbf{e}_2$ equals to $010$,
* $\mathbf{e}_3$ equals to $001$

Lets $e_{t,f}$, $f \in [1, \ldots, M]$
denote as an each component value of the unit vector $e_t$.
<!-- markdownlint-disable emphasis-style -->
\begin{equation}
\mathbf{e}_t = (e_{t,1}, \ldots, e_{t,M})
\end{equation}
<!-- markdownlint-enable emphasis-style -->

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
\mathbf{c} = (c_1, \ldots, c_{M})
\end{equation}

This is a first part of the published vote for a specific proposal.

#### Voter's proof

Since tally is calculated homomorphically by summing up encrypted unit vectors $\mathbf{c}$
(which will be shown in next section),
it is crucial to verify that encryptions are formed correctly
(i.e., that they indeed encrypt unit vectors).

Because by the definition of the encryption algorithm $Enc_{pk}(message \; ; \; randomness)$
it is possible to encrypt an any message value,
it is not restricted for encryption only $0$ and $1$ values
(as was stated in the previous section,
$e_{t,f}$ vector components only could be $0$ or $1$).

To generate such a proof a ZK (Zero Knowledge) proof is generated,
which allows by not revealing an actual value of $\mathbf{e}_t$
still transparently verify the correctness of data of $\mathbf{e}_t$.

#### Vote publishing

After all these procedures are done,
a final step is to publish an encrypted voting choice $\mathbf{c}$
and voter's proof corresponded to this choice.
It could be published using any public channel, e.g. blockchain, ipfs, on any p2p network,
but this is not a topic of current document.

### Tally

After the every voter done the choice and published it,
voter committee could perform tally,
for some proposal $\mathcal{P}$.

Lets denote $C := {\mathbf{c}_{v_1}, \mathbf{c}_{v_2}, \ldots, \mathbf{c}_{v_n}}$
as a voter ballots for the specific proposal,
where $\mathbf{c}_{v_i}$, $i \in [1, \ldots, n]$
is an encrypted unit vector with the choice of a voter $v_i$ ($n$ - number of voters),
which was generated on this [step](#vote-encrypting-procedure).

The first step is to take a
voter's choice $\mathbf{c}_{v_i}$ with the corresponding voter's voting power $\alpha_i$.
Expand $\mathbf{c}_{v_i}$ unit vector into the vector components
$\mathbf{c}_{v_i} = (e_{v_i,1}, \ldots, e_{v_i,M})$,
where $M$ number of voting options defined for the proposal.
And for each corresponding unit vector component
:
\begin{equation}
\mathbf{c}_{v_i, j}^{\alpha_i}
\end{equation}

And it must be performed for every voter's ballot $\mathbf{c}_{v_i}$ and all these results shoud be multiplied with each other.
So at the end we will have a new value $r_j$ corresponded to the specific voting option $j$,
which is accumulated homomorphically all voting results with its voting powers for this voting option:
\begin{equation}
r_j := \mathbf{c}_{v_1, j}^{\alpha_1} * \mathbf{c}_{v_2, j}^{\alpha_2} * \ldots * \mathbf{c}_{v_n, j}^{\alpha_n}
\end{equation}

where $n$ is a number of voters.




## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

[treasury_system_paper]: https://eprint.iacr.org/2018/435.pdf
[treasury_system_spec]: https://github.com/input-output-hk/treasury-crypto/blob/master/docs/voting_protocol_spec/Treasury_voting_protocol_spec.pdf
