---
icon: octicons/goal-24
---

# Introduction and Goals

<!-- See: https://docs.arc42.org/section-1/ -->

## Requirements Overview

Project Catalyst is Cardano’s community funding program that enables open proposal submission and community voting.

Catalyst Voices provides the new client stack for proposal submission and voting across web and mobile.

This repository contains the user interfaces, the backend gateway, and utilities needed to run events end to end.

The scope covers proposal creation, collaboration, review, discovery, voting, and auditability for funded events.

The system must integrate on-chain registration and stake data to establish permissions and voting power.

The system must store user generated content and votes with cryptographic integrity and versioning.

The system must scale to global participation while remaining usable by non-technical users.

## Quality Goals

Main quality goals:

| Quality Category | Quality | Description |
| --- | --- | --- |
| Usable | User experience | Voting and browsing proposals should be easy and intuitive to do |
| Usable | Correctness | System functions should provide accurate results |
| Secure | Access control | Role-Based Access Control |
| Secure | Privacy | User information are kept private |
| Secure | Accountability | Voting results can be audited by external parties |
| Reliable | Fail-safe | In case of failures the system does not lose data |

Supporting goals and drivers:

* Inclusive access across languages and devices.
* Offline friendly user workflows with safe recovery.
* Transparent APIs and documented processes for independent verification.

## Stakeholders

| Role/Name | Contact |
| --- | --- |
| Product Owner | Project Catalyst Governance |
| Engineering | Catalyst Engineering Team |
| Community | Proposers, Voters, and dReps |
| Operations | Site Reliability Engineering |
| QA | Catalyst QA Team |
| External | Auditors and Researchers |
