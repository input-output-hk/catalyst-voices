---
    title: 0011  Align BE / FE unstable releases
    adr:
        author: Oleksandr Prokhorenko
        created: 21-Oct-2025
        status:  draft
---

## Context

Our current deployment practices create instability and coordination problems:

1. **Shared environment blocking**: The `dev` environment frequently gets blocked by specific versions (e.g., fund15)
that teams want to stabilize and test, preventing other work from being deployed and tested.

2. **Version traceability**: When issues occur, it's difficult to identify which version caused the problem
because deployments aren't tied to explicit release tags.

3. **Test environment accessibility**: Alternative test environments exist but require manual setup and
training, making them not straightforward for general use.

4. **Breaking changes in main**: Large breaking changes (like API V2) merged to `main` cause problems
for both teams - backend loses ability to release from `main`, and frontend can't deploy without breaking changes.

We agreed (Oct 13, 2025 discussion) to standardize on **releasing from tags only (not every merge)** for both BE and FE,
with **feature-branch environments** for testing larger breaking changes before they land in `main`.

## Assumptions

- **OpenAPI** is (and remains) our single source of truth for public HTTP APIs.
- Teams accept **spec-first** changes: spec updates land in PRs **before** code changes.
- CI/CD can:
  - compute **breaking diffs** between the current spec and the last released spec,
  - run **spec conformance tests** against a running provider.
- We can operate **channelized promotions** (unstable → testing → stable) and **preview envs** per PR/feature branch.
- Weekly **release train** (lightweight) is acceptable; hotfixes remain possible.

## Decision

Adopt an **OpenAPI-driven, spec-first release model** with **tag-based deployments** to align BE(s) and FE:

### Core Principle: Deploy from Tags, Not from Main

Both backend and frontend will **only deploy tagged releases** to shared environments (`dev`, `qa`, `prod` and `feature env`).
This ensures:
- Explicit version tracking for troubleshooting
- Controlled, coordinated releases between teams
- Ability to keep environments stable during critical testing periods

### 1. **Spec-first PRs**
   - Any API change updates `openapi.yaml` in the backend repo first.
   - FE + BE reviewers required on spec-changing PRs.

### 2. **Breaking-change gate (OpenAPI diff)**
   - CI compares PR's `openapi.yaml` to the **last released tag's** spec; **breaking diffs fail** the PR.
   - Large breaking changes (like API V2) **must not merge to `main`** until ready for general deployment:
     - Use long-lived feature branches (e.g., `feat/api-v2`)
     - Deploy feature branches to dedicated preview environments for testing
     - Only merge to `main` when both BE and FE are ready to adopt the changes
   - Smaller breaking changes must ship as **vN → vN+1** with coexistence of vN for one train,
   or be adapted via a temporary shim at the gateway.

### 3. **Explicit backend version pinning**
   - Frontend explicitly tracks which backend tag/version it is compatible with (e.g., via environment config or documentation).
   - FE upgrades to work with new backend versions are explicit and coordinated (not automatic).

### 4. **Provider conformance tests**
   - Backend CI runs **conformance tests** validating real responses against the OpenAPI schemas for
   critical endpoints (e.g.,Schemathesis runs).
   - Release promotion requires green conformance.

### 5. **Environment strategy & promotions**
   - **Shared environments (`dev`, `preprod`, `prod`)** only receive tagged releases:
     - `dev`: latest unstable tagged release
     - `qa`: promoted release candidates
     - `prod`: production-ready releases
   - **Preview environments** for:
     - PRs requiring integration testing
     - Long-lived feature branches with breaking changes (e.g., API V2, fund15)
     - Must be easily accessible without special training
   - Artifacts flow **unstable → testing → stable**; FE E2E smoke runs against **testing** before promotion to **stable**.
   - **Weekly release train** (lightweight, e.g., Wed 14:00 CET) promotes what's ready from testing → stable across BE/FE.

### 6. **Versioning & deprecation**
   - Prefer **path or header versioning** (`/api/v1`, `/api/v2` or `Accept: application/vnd.catalyst.v2+json`).
   - Mark deprecated fields in the spec and keep **vN-1** available for **one train** with an explicit removal date.

## Risks

- **Spec discipline**: If engineers forget to update the spec first, the guard loses value.
- **False negatives**: Diff rules must be tuned; overly permissive settings could miss meaningful breaks.
- **Infra & process**: Preview envs add CI complexity; preview environments must be made easily accessible without training.
- **Version coordination**: Without automated SDK generation, FE and BE teams must manually coordinate compatible versions; risk of version mismatches.
- **Cultural shift**: Teams must adapt to tag-based releases instead of continuous deployment from `main` (especially FE team).
- **Feature branch discipline**: Long-lived feature branches increase merge complexity; teams must actively keep them up-to-date with `main`.

## Consequences

- **Fewer FE breakages**: Breaking server changes are either **blocked** or **versioned**;
coordinated releases ensure compatibility.
- **Better traceability**: Changes tie to **explicit tags** and versioned clients; when issues occur,
teams can immediately identify which version caused the problem.
- **Unified deployment process**: Both BE and FE follow the same tag-based deployment model,
eliminating environment drift.
- **Stable shared environments**: Teams can keep critical versions stable in `dev` for testing without
blocking other work (which moves to preview envs).
- **Faster feedback**: Conformance tests + preview envs fail early.
- **Predictable cadence**: Weekly train synchronizes cross-repo releases.
- **Main stays releasable**: By keeping breaking changes in feature branches until ready,
 `main` remains in a deployable state.
- **Gateway shims minimized**: Only exceptional, time-boxed use with explicit sunset.

## KPIs

- **0** critical FE outages caused by BE API changes over 2 trains.
- **≥90%** of FE critical paths covered by schema-backed conformance tests.
- **Mean time tag → stable ≤ 5 days** (including testing dwell).
- **80% reduction** in “dev is blocked” incidents.

## Ownership

- **Release captain (weekly, rotating)**: runs the train and promotions.
- **Spec owners**: maintain `openapi.yaml`, review gates.
- **FE/BE owner**: coordinates FE/BE version compatibility and upgrades.
- **Env/platform owner**: preview env automation & channel promotions.

## More Information

- Drivers and context from **Monday's Technical Discussion** (Oct 13, 2025) -
[meeting transcript](https://docs.google.com/document/d/16rnXxr6z3WwWBB0EYlffef8cbqRrPzC8DXJhdKevedw/edit?usp=sharing).
- Key insight from discussion: "We should just deploy from releases and rely on releases only.
At least it would make life easier in that sense that if something bad happened we will definitely know what was the version."
