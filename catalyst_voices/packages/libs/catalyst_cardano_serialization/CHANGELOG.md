## 0.4.0

> Note: This release has breaking changes.

 - **FIX**: to be signed message should be a plain cbor sequence ([#701](https://github.com/input-output-hk/catalyst-voices/issues/701)). ([7c2dec6e](https://github.com/input-output-hk/catalyst-voices/commit/7c2dec6e2f91c1f18a39e7646ee3a5ca6a6e7249))
 - **FIX**: rbac txn inputs hash ([#688](https://github.com/input-output-hk/catalyst-voices/issues/688)). ([b644026f](https://github.com/input-output-hk/catalyst-voices/commit/b644026fa3b675591d071819eda185365257f0d1))
 - **FEAT**(catalyst_cardano_serialization): add CborEncodable interface for standardized CBOR handling ([#696](https://github.com/input-output-hk/catalyst-voices/issues/696)). ([4222926f](https://github.com/input-output-hk/catalyst-voices/commit/4222926f028460ddb100008806fe39a38ac3511c))
 - **BREAKING** **FIX**: required signers are the hash of the public key, not the public key itself ([#703](https://github.com/input-output-hk/catalyst-voices/issues/703)). ([a63c4686](https://github.com/input-output-hk/catalyst-voices/commit/a63c4686ee6e79aa65ace0cb4ed9b0c91e994320))
 - **BREAKING** **FEAT**: add initial support for Cardano Native scripts, Plutus scripts, advanced transaction outputs, and additional transaction body fields and witnesses ([#713](https://github.com/input-output-hk/catalyst-voices/issues/713)). ([74fcb725](https://github.com/input-output-hk/catalyst-voices/commit/74fcb725f221bb3acf3824a3dd18a073d0a321e0))
 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

## 0.3.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**: cardano serialization must depend on flutter ([#679](https://github.com/input-output-hk/catalyst-voices/issues/679)). ([b7d5276b](https://github.com/input-output-hk/catalyst-voices/commit/b7d5276b238b4c7273997b004465e2ffb29f8436))

## 0.2.0

> Note: This release has breaking changes.

 - **FEAT**: add catv1 auth token generator ([#671](https://github.com/input-output-hk/catalyst-voices/issues/671)). ([79efc828](https://github.com/input-output-hk/catalyst-voices/commit/79efc82800a7e6aca3e8516bbb4866bd502e2f36))
 - **BREAKING** **FIX**: X509 registration metadata encoding ([#640](https://github.com/input-output-hk/catalyst-voices/issues/640)). ([c45a2ac9](https://github.com/input-output-hk/catalyst-voices/commit/c45a2ac96b34c4215352ece5ef9bd2fa73b591e8))
 - **BREAKING** **FEAT**: update transactions inputs hash size ([#643](https://github.com/input-output-hk/catalyst-voices/issues/643)). ([a729823d](https://github.com/input-output-hk/catalyst-voices/commit/a729823d9b2e0c369456f8e99f5b776f046e6d1f))

## 0.1.3

 - **FEAT**: rbac metadata envelope ([#630](https://github.com/input-output-hk/catalyst-voices/issues/630)). ([150d5676](https://github.com/input-output-hk/catalyst-voices/commit/150d567636c4281c092d020d51882e638b16beb5))
 - **FEAT**: rbac metadata ([#619](https://github.com/input-output-hk/catalyst-voices/issues/619)). ([daf24a15](https://github.com/input-output-hk/catalyst-voices/commit/daf24a15a0b8d6345131ca8e3ec33c92865af4f8))
 - **FEAT**: add required signers ([#605](https://github.com/input-output-hk/catalyst-voices/issues/605)). ([bebc0fbd](https://github.com/input-output-hk/catalyst-voices/commit/bebc0fbd241b6370b31b91e5a60b1d5d30cec403))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

## 0.1.2

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))
 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: catalyst cardano transaction builder ([#501](https://github.com/input-output-hk/catalyst-voices/issues/501)). ([e150394f](https://github.com/input-output-hk/catalyst-voices/commit/e150394fb348e88b016e03ab69efe782f9daf94f))
 - **FEAT**: catalyst cardano documentation ([#507](https://github.com/input-output-hk/catalyst-voices/issues/507)). ([f003e8d9](https://github.com/input-output-hk/catalyst-voices/commit/f003e8d90d23d350ea07ee69a73d6be7c5af191b))
 - **FEAT**: catalyst cardano witnesses management ([#490](https://github.com/input-output-hk/catalyst-voices/issues/490)). ([dfbb9f83](https://github.com/input-output-hk/catalyst-voices/commit/dfbb9f837f88fbd0e3e02eff67a7515826380df1))
 - **FEAT**: add shelley address & cardano serialization lib ([#478](https://github.com/input-output-hk/catalyst-voices/issues/478)). ([6d985bbc](https://github.com/input-output-hk/catalyst-voices/commit/6d985bbce2e2e2f5d827f3c19a752c6c19ce93af))

## 0.1.1+1

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))

## 0.1.1

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: catalyst cardano transaction builder ([#501](https://github.com/input-output-hk/catalyst-voices/issues/501)). ([e150394f](https://github.com/input-output-hk/catalyst-voices/commit/e150394fb348e88b016e03ab69efe782f9daf94f))
 - **FEAT**: catalyst cardano documentation ([#507](https://github.com/input-output-hk/catalyst-voices/issues/507)). ([f003e8d9](https://github.com/input-output-hk/catalyst-voices/commit/f003e8d90d23d350ea07ee69a73d6be7c5af191b))
 - **FEAT**: catalyst cardano witnesses management ([#490](https://github.com/input-output-hk/catalyst-voices/issues/490)). ([dfbb9f83](https://github.com/input-output-hk/catalyst-voices/commit/dfbb9f837f88fbd0e3e02eff67a7515826380df1))
 - **FEAT**: add shelley address & cardano serialization lib ([#478](https://github.com/input-output-hk/catalyst-voices/issues/478)). ([6d985bbc](https://github.com/input-output-hk/catalyst-voices/commit/6d985bbce2e2e2f5d827f3c19a752c6c19ce93af))

# 0.1.0

* Initial release.
