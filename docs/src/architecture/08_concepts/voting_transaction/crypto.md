<!-- cspell: words mathbf mathbb Gamal homomorphically ipfs -->

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

The protocol is based around the following entities:

* **Proposal** -
  voting subject on which each voter will be cast their votes.
* **Proposal voting options** -
  a proposal options array, e.g. $[Yes, No, Abstain]$.
* **Voting committee** -
  a special **trusted** entity, which perform tally process and revealing the results of the tallying.
  Such committee consists of the 1 person.
* **Voters** -
  actors who actually performing the voting by posting ballots with their voting choices.
* **Election public key** $pk$ - committees generated public key,
  which is shared across all voters
  and used for vote's encryption and tallying processes.
* **Voter's voting power** -
  an integer value which defines a voting power for a specific voter.
  This value could be equals to $1$ for every voter,
  so everyone would be equal in their voting rights.
  Or it could be defined based on their stake in the blockchain,
  which is more appropriate for web3 systems.

Important to note that the protocol defined for some **one** proposal.
Obviously, it could be easily scaled for a set of proposals,
performing protocol steps in parallel.

### Initial setup

Before any voting will start an initial setup procedure should be performed.

* Define an array of voting options/choices for a proposal, e.g. $[Yes, No, Abstain]$.
* Voting committee must generate a shared election public key $pk$ and distribute it among voters.
  A corresponding private key (secret share) $sk$ will be used to perform tally.
* Define for each voter their own voting power.
  Basically this step could be done at any point of time, but before the tally.
* As most of the crypto algorithms are group dependent
  (more about this you can read in [appendix A](#a-group-definition)),
  it is needed to specifically define which cryptographically secure group would be used.

### Vote

A voter could cast a vote for some proposal.
To do that, obviously, a voting choice should be made and encoded in specific format.
For achieving anonymity this voting choice must be homomorphically encrypted,
using the specific election public key $pk$, so afterwards voting committee could perform tally.
It is also important for the voter to generate a cryptographically secured proof,
that he has generated and encrypted a vote correctly and according to the protocol,
and everyone would be able to verify it.
So we will preserve anonymity without lacking transparency and correctness.

#### Voting choice

<!-- markdownlint-disable no-inline-html -->
For some proposal, voter generates a unit vector $\mathbf{e}_i$,
the length of such vector **must** be equal to the amount of the voting options of the proposal.
<br/>
$i$ corresponds to the proposal voting choice and
defines that the $i$-th component of the unit vector equals to $1$
and the rest components are equals to $0$.
And it stands as an identifier of the unit vector and could varies $1 \le i \le M$,
$M$ - amount of the voting options.
<br/>
E.g. proposal has voting options $[Yes, No, Abstain]$:

* $\mathbf{e}_1$ equals to $(1,0,0)$ corresponds to $Yes$
* $\mathbf{e}_2$ equals to $(0,1,0)$ corresponds to $No$
* $\mathbf{e}_3$ equals to $(0,0,1)$ corresponds to $Abstain$

Lets $e_{i,j}$ denote as an each component value of the unit vector $\mathbf{e}_i$.
Where $i$ is a unit vector's identifier as it was described before,
$j$ index of the unit vector's component, which could varies $1 \le j \le M$,
$M$ - amount of the voting options and equals to the length of the unit vector.
<br/>
Using such notation unit vector $\mathbf{e}_i$ could be defined as
<!-- markdownlint-disable emphasis-style -->
\begin{equation}
\mathbf{e}_i = (e_{i,1}, \ldots, e_{i,M})
\end{equation}
<!-- markdownlint-enable emphasis-style -->

E.g. for the unit vector
$\mathbf{e}_1 = (1,0,0)$
components would be defined as follows:

* $e_{1, 1}$ equals to $1$
* $e_{1, 2}$ equals to $0$
* $e_{1, 3}$ equals to $0$

<!-- markdownlint-enable no-inline-html -->

#### Vote encrypting

<!-- markdownlint-disable no-inline-html -->

After the choice is done (described in [sectio](#voting-choice)),
vote **must** be encrypted using shared election public key $pk$.

To achieve that, Lifted ElGamal encryption algorithm is used,
noted as $ElGamalEnc(message, randomness, public \; key)$.
More detailed description of the lifted ElGamal algorithm
you can find in the [appendix B](#b-lifted-elgamal-encryptiondecryption).
<br/>
$ElGamalEnc(message, randomness, public \; key)$ algorithm produces a ciphertext $c$ as a result.
\begin{equation}
c = ElGamalEnc(message, randomness, public \; key)
\end{equation}

To encrypt previously generated unit vector $\mathbf{e}_i$ ($i$ - voting choice identifier),
for each vector component value $e_{i,j}$ generate a corresponding randomness.
<br/>
Lets denote randomness value as $r_j$,
where $j$ is the same vector component's index $j$ value, $e_{i, j} => r_j$.

Then, for each vector component $e_{i,j}$ with the corresponding randomness $r_j$,
perform encryption algorithm applying shared election public key $pk$.
\begin{equation}
c_j = ElGamalEnc(e_{i,j}, r_j, pk)
\end{equation}

As a result getting a vector $\mathbf{c}$ of ciphertext values $c_f$,
with the size equals of the size $\mathbf{e}_t$ unit vector,
equals to the amount of the voting options.
Lets denote this vector as:
\begin{equation}
\mathbf{c} = (c_1, \ldots, c_{M}) = (ElGamalEnc(e_{i,j}, r_j, pk), \ldots,  ElGamalEnc(e_{i,M}, r_M, pk))
\end{equation}

where $M$ is the voting options amount.

This is a first part of the published vote for a specific proposal.

<!-- markdownlint-enable no-inline-html -->

#### Voter's proof

After the voter's choice is generated and encrypted,
it is crucial to prove that [encoding](#voting-choice) and [encryption](#vote-encrypting) are formed correctly
(i.e. that the voter indeed encrypt a unit vector).

Because by the definition of the encryption algorithm $ElGamalEnc(message, randomness, public \; key)$
it is possible to encrypt an any message value,
it is not restricted for encryption only $0$ and $1$ values
(as it was stated in the previous [section](#voting-choice),
unit vector components only could be $0$ or $1$).
That's why it is needed to generate such a proof,
so everyone could validate a correctness of the encrypted vote data,
without revealing a voting choice itself.

To achieve that a some sophisticated ZK (Zero Knowledge) algorithm is used,
noted as $VotingChoiceProof(\mathbf{c})$.
It takes an encrypted vote vector $\mathbf{c}$ and generates a proof value $\pi$.
\begin{equation}
\pi = VotingChoiceProof(\mathbf{c})
\end{equation}

So to validate a $VotingChoiceCheck(\mathbf{c}, \pi)$ procedure should be used,
which takes an encrypted vote $\mathbf{c}$ and corresponded proof $\pi$
as arguments and returns `true` or `false`,
is it valid or not.
\begin{equation}
true | false = VotingChoiceCheck(\mathbf{c}, \pi)
\end{equation}

A more detailed description of how $VotingChoiceProof$, $VotingChoiceCheck$ work
you can find in the section *2.4* of this [paper][treasury_system_spec].

#### Vote publishing

After all these procedures are done,
a final step is to publish an encrypted vote $\mathbf{c}$
and voter's proof $\pi$ corresponded to this choice.
It could be published using any public channel, e.g. blockchain, ipfs or through p2p network.

### Tally

<!-- markdownlint-disable no-inline-html -->

After voters performed voting procedure and encrypted votes are published,
tally could be executed by the voting committee.
Important to note, voting committee doing tally does not revealing personal voting choices.

By the result of tally procedure means
an accumulated sum of voting power for each voting option of the proposal,
based on published votes.
<br/>
E.g.:

<!-- markdownlint-disable ul-indent -->
* proposal with voting options $[Yes, No, Abstain]$
* two different voters with their voting power:
    * "Alice" with voting power $10$
    * "Bob" with voting power $30$
* these voter's published their choices on this proposal:
    * "Alice" voted $Yes$
    * "Bob" voted $No$
* final result would be the following:
    * $Yes$ accumulated $10$
    * $No$ accumulated $30$
    * $Abstain$ accumulated $0$
<!-- markdownlint-enable ul-indent -->

So to replicate the same process but securely,
based on the set of encrypted votes $\mathbf{c}$,
a special $Tally$, $TallyDec$ and $TallyProof$ algorithms are used.

<!-- markdownlint-enable no-inline-html -->

#### Homomorphic tally

To perform homomorphic tally of the encrypted set of votes,
$Tally$ algorithm is used which described in [appendix C](#c-homomorphic-tally).
It takes as an input the following:

* $[\mathbf{c_1}, \mathbf{c_2}, \ldots, \mathbf{c}_{N}]$ -
  an array of all published encrypted vote's.
* $[\alpha_1, \alpha_2, \ldots, \alpha_N]$ - an array of corresponded voter's voting power.
* $i$ - voting option index.

Where $N$ - votes amount.

And produce an encrypted tally result for voting option $i$.
\begin{equation}
er_i = Tally(i, [\mathbf{c_1}, \mathbf{c_2}, \ldots, \mathbf{c_N}], [\alpha_1, \alpha_2, \ldots, \alpha_N])
\end{equation}

E.g. a proposal with voting choices $[Yes, No]$,
votes $[\mathbf{c_1}, \mathbf{c_2}]$,
voting powers $[\alpha_1, \alpha_2]$
and election secret key $sk$.

* Encrypted result for option $Yes$: $er_1 = Tally(1, [\mathbf{c_1}, \mathbf{c_2}], [\alpha_1, \alpha_2])$.
* Encrypted result for option $No$: $er_2 = Tally(2, [\mathbf{c_1}, \mathbf{c_2}], [\alpha_1, \alpha_2])$

#### Tally decryption

To decrypt each calculated tally result from the previous [step](#homomorphic-tally),
$TallyDec$ is used,
which is technically a common $ElGamalDec$ algorithm described in [appendix B](#b-lifted-elgamal-encryptiondecryption).
It takes as an input the following:

* $sk$ - an election private key held by voting committee.
* $er_i$ - an encrypted tally result for the specific voting option defined for a proposal.

It produces a decrypted tally result for the voting option of a proposal.
\begin{equation}
r_i = ElGamalDec(er_i, sk) = TallyDec(er_i, sk)
\end{equation}

This decrypted tally result is an exact result of the voting procedure,
which represents an outcome of the election process.

E.g. a proposal with voting choices $[Yes, No]$,
encrypted tally results $[er_1, er_2]$
and election secret key $sk$.

* Decrypted result for option $Yes$: $r_1 = TallyDec(er_1, sk)$.
* Decrypted result for option $No$: $r_2 = TallyDec(er_2, sk)$

#### Tally proof

An important step for bringing transparency and exclude misbehaving from the voting committee,
a corresponded proof for each decrypted tally result **must** be generated.

It is necessary to verify that encrypted tally was decrypted exactly by using committee secret key,
and not any other.
So the publicly published decrypted tally result (a final tally result) actually is correct and
represents a proper election outcome.

To do that, a sophisticated ZK (Zero Knowledge) $TallyProof$ algorithm is used.
Which proofs that a provided encrypted tally result value $er$ was decrypted into tally result $r$
using the exact secret key $sk$,
which is corresponded to the already known shared election public key $pk$.
\begin{equation}
\pi = TallyProof(er, sk)
\end{equation}

So to validate a $TallyCheck(er, r, pk, \pi)$ procedure should be used,
which takes an encrypted tally result $er$, decrypted tally result $r$,
election public key $pk$ and corresponded proof $\pi$
as arguments and returns `true` or `false`,
is it valid or not.
\begin{equation}
true | false = TallyCheck(er, r, pk, \pi)
\end{equation}

A more detailed description of how $TallyProof$, $TallyCheck$ work
you can find in the [appendix E](#e-non-interactive-zk-tally-proof).

#### Tally publishing

After all these procedures are done,
a final step is to publish an encrypted tally results $er_i$,
decrypted tally results $r_i$
and tally proofs $\pi_i$
corresponded for each voting option of some proposal.
It could be published using any public channel, e.g. blockchain, ipfs or through p2p network.

## A: Group Definition

<!-- markdownlint-disable no-inline-html -->

Important to note that some crypto algorithms, which are described below, are group $\mathbb{G}$ dependant.
More detailed about groups you can find at section *8.2.1* section on this [book][crypto_book].
<br/>
Therefore, the generalized notation of the group operation used - $\circ$.
And defined as follows:

* For all $a, b \in \mathbb{G}$, $a \circ b = c$, where $c \in \mathbb{G}$.
* For all $a \in \mathbb{G}$, and $n \in \mathbb{Z}$, $a^n = a \circ a \ldots \circ a$ ($n$ - times).
* There is an element noted as $1$, called *neutral* element,
  such that $a \circ 1 = a$, for all $a \in \mathbb{G}$.
* For each element $a \in \mathbb{G}$ exists $a^{-1} \in \mathbb{G}$,
  called the inversed of $a$, such that $a \circ a^{-1} = a^{-1} \circ a = 1$.

<!-- markdownlint-enable no-inline-html -->

## B: Lifted ElGamal Encryption/Decryption

<!-- markdownlint-disable no-inline-html -->

Lifted ElGamal encryption schema is defined over
any cyclic group $\mathbb{G}$ of order $q$ with group generator $g$ ($g \in \mathbb{G}$).
It could be multiplicative group of integers modulo $n$ or some elliptic curve over the finite field group.
<br/>
More detailed how group operations are defined, described in [appendix A](#a-group-definition).

### Encryption

Lifted ElGamal encryption algorithm
takes as arguments:

* $m$ - message ($m \in \mathbb{Z}_q^*$)
* $r$ - randomness ($r \in \mathbb{Z}_q^*$)
* $pk$ - public key ($pk \in \mathbb{G}$)

\begin{equation}
ElGamalEnc(m, r, pk) = (c_1, c_2) = c,
\end{equation}

\begin{equation}
c_1 = g^r, \quad c_2 = g^m \circ pk^r
\end{equation}

$c$ - is a resulted ciphertext which consists of two elements $c_1, c_2 \in \mathbb{G}$.

### Decryption

Lifted ElGamal decryption algorithm takes as arguments:

* $c$ -  ciphertext,
* $sk$ - secret key ($sk \in \mathbb{Z}_q^*$)

\begin{equation}
ElGamalDec(c, sk) = Dlog(c_2 \circ c_1^{-sk}) = m
\end{equation}

$m$ - an original message which was encrypted on the previous step,
$Dlog(x)$ is a discrete logarithm of $x$.
Note that since $Dlog$ is not efficient,
the message space should be a small set,
say $m \in {{0,1}}^{\xi}$, for $\xi \le 30$.

<!-- markdownlint-enable no-inline-html -->

## C: Homomorphic Tally

<!-- markdownlint-disable no-inline-html -->

Homomorphic tally schema is defined over any cyclic group $\mathbb{G}$ of order $q$ with group generator $g$ ($g \in \mathbb{G}$).
<br/>
More detailed how group operations are defined, described in [appendix A](#a-group-definition).

Homomorphic tally algorithm takes as arguments:

* $i$ - voting choice index
* $[\mathbf{c_1}, \mathbf{c_2}, \ldots, \mathbf{c_N}]$ - an array of encrypted votes vector's,
  where $N$ - votes amount
* $[\alpha_1, \alpha_2, \ldots, \alpha_N]$ - an array of corresponded voter's voting power,
  where $N$ - votes amount

\begin{equation}
Tally(i, [\mathbf{c_1}, \mathbf{c_2}, \ldots, \mathbf{c_N}], [\alpha_1, \alpha_2, \ldots, \alpha_N])
= c_{1, i}^{\alpha_1} \circ c_{2, i}^{\alpha_2} \circ \ldots \circ c_{N, i}^{\alpha_N} = er_i
\end{equation}

Where $c_{j, i}$ - an encrypted corresponded $i$-th vector's component of the encrypted vote $\mathbf{c_j}$.
As it was stated in this [section](#vote-encrypting) each encrypted vote is a vector
$\mathbf{c_j} = (c_{j, 1}, \ldots, c_{j, M})$, $M$ - number of voting choices.

$er_i$ noted as encrypted tally result for the provided $i$-th voting choice.
As it is not an open decrypted value yet,
it needs a decryption procedure corresponded for which encryption one was made.

<!-- markdownlint-enable no-inline-html -->

## D: Non-Interactive ZK Vote Proof

## E: Non-Interactive ZK Tally Proof

Non-Interactive ZK (Zero Knowledge) Tally Proof algorithm helps to solve only one problem,
to proove that the specific encrypted message was decrypted into the specific resulted value,
using exactly that secret key,
which is corresponds to the some shared public key.

<!-- markdownlint-disable max-one-sentence-per-line -->
A more detailed and formal description
you can find in the sections *Fig. 10* and *2.1.5* of this [paper][treasury_system_spec].
<!-- markdownlint-enable max-one-sentence-per-line -->

It is assumed that the original encryption and decryption is performing by ElGamal scheme.
It means that all described operations is also group dependent
(more about groups described in [appendix A](#a-group-definition)).

### Prover

The prover algorithm takes as arguments:

* $enc$ - an encrypted message (ciphertext)
* $sk$ - a secret key which was used to decrypt a message $enc$

\begin{equation}
TallyProof(enc, sk) = \pi
\end{equation}

$\pi$ is the final proof.
To compute it, prover needs to perform the next steps:

1. Take the first element of the ciphertext $enc = (enc_1, enc_2)$
  and calculate $d = enc_1^{sk}$.
3. Generate a random value $\mu, \quad \mu \in \mathbb{Z}_q^*$.
4. Compute $A_1 = g^{\mu}$, where $g$ is the group generator ($A_1 \in \mathbb{G}$).
5. Compute $A_2 = (enc_1)^{\mu}, \quad A_2 \in \mathbb{G}$.
6. Compute $e = H(pk | d | g | enc_1 | A_1 | A_2 )$,
  where $pk$ is a corresponding public key of $sk$, $H$ is a hash function.
7. Compute $z = sk * e + \mu, \quad z \in \mathbb{Z}_q^*$.

Finally the proof $\pi = (A_1, A_2, z)$.

### Verifier

The verifier algorithm takes as arguments:

* $enc$ - an encrypted message (ciphertext),
* $dec$ - a decrypted message from the encrypted ciphertext $enc$,
* $pk$ - a public key corresponded to the $sk$
  which was supposedly used to decrypt a message $enc$
* $\pi$ - a proover's proof generated on the [previous step](#prover)

\begin{equation}
TallyCheck(enc, dec, pk, \pi) = true | false
\end{equation}

As a result algorithm will return `true` or `false`,
is the verification was succeeded or not respectively.

Knowing that $\pi$ equals to $(A_1, A_2, z)$,
verifier needs to perform the next steps:

1. Take the first element $enc_1$ of the ciphertext $enc = (enc_1, enc_2)$.
2. Calculate $d = g^{dec} \circ (-enc_2), \quad d \in \mathbb{G}$.
3. Compute $e = H(pk | d | g | enc_1 | A_1 | A_2 )$, where $g$ is the group generator.
4. Verify $g^z == pk^e \circ A_1$
5. Verify $enc_1^z == d^e \circ A_2$

If step `3` and `4` returns `true` so the final result is `true` otherwise return `false`.

## Rationale

## Path to Active

### Acceptance Criteria
<!-- Describes what are the acceptance criteria whereby a proposal becomes 'Active' -->

### Implementation Plan
<!-- A plan to meet those criteria or `N/A` if an implementation plan is not applicable. -->

<!-- OPTIONAL SECTIONS: see CIP-0001 > Document > Structure table -->

[treasury_system_paper]: https://eprint.iacr.org/2018/435.pdf
[treasury_system_spec]: https://github.com/input-output-hk/treasury-crypto/blob/master/docs/voting_protocol_spec/Treasury_voting_protocol_spec.pdf
[crypto_book]: https://gnanavelrec.wordpress.com/wp-content/uploads/2019/06/2.understanding-cryptography-by-christof-paar-.pdf
