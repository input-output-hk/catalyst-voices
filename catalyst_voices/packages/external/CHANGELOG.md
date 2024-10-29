# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-09-03

### Changes

---

Packages with breaking changes:

 - [`catalyst_analysis` - `v2.0.0`](#catalyst_analysis---v200)
 - [`catalyst_cardano` - `v0.3.0`](#catalyst_cardano---v030)
 - [`catalyst_cardano_platform_interface` - `v0.3.0`](#catalyst_cardano_platform_interface---v030)
 - [`catalyst_cardano_serialization` - `v0.4.0`](#catalyst_cardano_serialization---v040)
 - [`catalyst_cardano_web` - `v0.3.0`](#catalyst_cardano_web---v030)
 - [`catalyst_compression` - `v0.3.0`](#catalyst_compression---v030)
 - [`catalyst_compression_platform_interface` - `v0.2.0`](#catalyst_compression_platform_interface---v020)
 - [`catalyst_compression_web` - `v0.3.0`](#catalyst_compression_web---v030)
 - [`catalyst_cose` - `v0.3.0`](#catalyst_cose---v030)

Packages with other changes:

 - There are no other changes in this release.

---

#### `catalyst_analysis` - `v2.0.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_cardano` - `v0.3.0`

 - **FIX**: catalyst cardano null utxos ([#746](https://github.com/input-output-hk/catalyst-voices/issues/746)). ([3f2f5925](https://github.com/input-output-hk/catalyst-voices/commit/3f2f592593efe306f85fb0e81ce07aa1ea90b7b6))
 - **FIX**: rbac txn inputs hash ([#688](https://github.com/input-output-hk/catalyst-voices/issues/688)). ([b644026f](https://github.com/input-output-hk/catalyst-voices/commit/b644026fa3b675591d071819eda185365257f0d1))
 - **BREAKING** **FEAT**: add initial support for Cardano Native scripts, Plutus scripts, advanced transaction outputs, and additional transaction body fields and witnesses ([#713](https://github.com/input-output-hk/catalyst-voices/issues/713)). ([74fcb725](https://github.com/input-output-hk/catalyst-voices/commit/74fcb725f221bb3acf3824a3dd18a073d0a321e0))
 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_cardano_platform_interface` - `v0.3.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_cardano_serialization` - `v0.4.0`

 - **FIX**: to be signed message should be a plain cbor sequence ([#701](https://github.com/input-output-hk/catalyst-voices/issues/701)). ([7c2dec6e](https://github.com/input-output-hk/catalyst-voices/commit/7c2dec6e2f91c1f18a39e7646ee3a5ca6a6e7249))
 - **FIX**: rbac txn inputs hash ([#688](https://github.com/input-output-hk/catalyst-voices/issues/688)). ([b644026f](https://github.com/input-output-hk/catalyst-voices/commit/b644026fa3b675591d071819eda185365257f0d1))
 - **FEAT**(catalyst_cardano_serialization): add CborEncodable interface for standardized CBOR handling ([#696](https://github.com/input-output-hk/catalyst-voices/issues/696)). ([4222926f](https://github.com/input-output-hk/catalyst-voices/commit/4222926f028460ddb100008806fe39a38ac3511c))
 - **BREAKING** **FIX**: required signers are the hash of the public key, not the public key itself ([#703](https://github.com/input-output-hk/catalyst-voices/issues/703)). ([a63c4686](https://github.com/input-output-hk/catalyst-voices/commit/a63c4686ee6e79aa65ace0cb4ed9b0c91e994320))
 - **BREAKING** **FEAT**: add initial support for Cardano Native scripts, Plutus scripts, advanced transaction outputs, and additional transaction body fields and witnesses ([#713](https://github.com/input-output-hk/catalyst-voices/issues/713)). ([74fcb725](https://github.com/input-output-hk/catalyst-voices/commit/74fcb725f221bb3acf3824a3dd18a073d0a321e0))
 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_cardano_web` - `v0.3.0`

 - **FIX**: catalyst cardano null utxos ([#746](https://github.com/input-output-hk/catalyst-voices/issues/746)). ([3f2f5925](https://github.com/input-output-hk/catalyst-voices/commit/3f2f592593efe306f85fb0e81ce07aa1ea90b7b6))
 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_compression` - `v0.3.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_compression_platform_interface` - `v0.2.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_compression_web` - `v0.3.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

#### `catalyst_cose` - `v0.3.0`

 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))


## 2024-08-13

### Changes

---

Packages with breaking changes:

 - [`catalyst_cardano_serialization` - `v0.3.0`](#catalyst_cardano_serialization---v030)

Packages with other changes:

 - [`catalyst_cardano_web` - `v0.2.0+1`](#catalyst_cardano_web---v0201)
 - [`catalyst_cardano` - `v0.2.0+1`](#catalyst_cardano---v0201)
 - [`catalyst_cardano_platform_interface` - `v0.2.0+1`](#catalyst_cardano_platform_interface---v0201)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `catalyst_cardano_web` - `v0.2.0+1`
 - `catalyst_cardano` - `v0.2.0+1`
 - `catalyst_cardano_platform_interface` - `v0.2.0+1`

---

#### `catalyst_cardano_serialization` - `v0.3.0`

 - **BREAKING** **FIX**: cardano serialization must depend on flutter ([#679](https://github.com/input-output-hk/catalyst-voices/issues/679)). ([b7d5276b](https://github.com/input-output-hk/catalyst-voices/commit/b7d5276b238b4c7273997b004465e2ffb29f8436))


## 2024-08-12

### Changes

---

Packages with breaking changes:

 - [`catalyst_cardano` - `v0.2.0`](#catalyst_cardano---v020)
 - [`catalyst_cardano_platform_interface` - `v0.2.0`](#catalyst_cardano_platform_interface---v020)
 - [`catalyst_cardano_serialization` - `v0.2.0`](#catalyst_cardano_serialization---v020)
 - [`catalyst_cardano_web` - `v0.2.0`](#catalyst_cardano_web---v020)
 - [`catalyst_compression` - `v0.2.0`](#catalyst_compression---v020)
 - [`catalyst_compression_web` - `v0.2.0`](#catalyst_compression_web---v020)
 - [`catalyst_cose` - `v0.2.0`](#catalyst_cose---v020)

Packages with other changes:

 - There are no other changes in this release.

---

#### `catalyst_cardano` - `v0.2.0`

 - **BREAKING** **FIX**: signData return type should be DataSignature, not VkeyWitness ([#647](https://github.com/input-output-hk/catalyst-voices/issues/647)). ([69dba1d2](https://github.com/input-output-hk/catalyst-voices/commit/69dba1d24022eb77cc03ac670dda0da047304766))
 - **BREAKING** **FIX**: X509 registration metadata encoding ([#640](https://github.com/input-output-hk/catalyst-voices/issues/640)). ([c45a2ac9](https://github.com/input-output-hk/catalyst-voices/commit/c45a2ac96b34c4215352ece5ef9bd2fa73b591e8))
 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))

#### `catalyst_cardano_platform_interface` - `v0.2.0`

 - **BREAKING** **FIX**: signData return type should be DataSignature, not VkeyWitness ([#647](https://github.com/input-output-hk/catalyst-voices/issues/647)). ([69dba1d2](https://github.com/input-output-hk/catalyst-voices/commit/69dba1d24022eb77cc03ac670dda0da047304766))

#### `catalyst_cardano_serialization` - `v0.2.0`

 - **FEAT**: add catv1 auth token generator ([#671](https://github.com/input-output-hk/catalyst-voices/issues/671)). ([79efc828](https://github.com/input-output-hk/catalyst-voices/commit/79efc82800a7e6aca3e8516bbb4866bd502e2f36))
 - **BREAKING** **FIX**: X509 registration metadata encoding ([#640](https://github.com/input-output-hk/catalyst-voices/issues/640)). ([c45a2ac9](https://github.com/input-output-hk/catalyst-voices/commit/c45a2ac96b34c4215352ece5ef9bd2fa73b591e8))
 - **BREAKING** **FEAT**: update transactions inputs hash size ([#643](https://github.com/input-output-hk/catalyst-voices/issues/643)). ([a729823d](https://github.com/input-output-hk/catalyst-voices/commit/a729823d9b2e0c369456f8e99f5b776f046e6d1f))

#### `catalyst_cardano_web` - `v0.2.0`

 - **BREAKING** **FIX**: signData return type should be DataSignature, not VkeyWitness ([#647](https://github.com/input-output-hk/catalyst-voices/issues/647)). ([69dba1d2](https://github.com/input-output-hk/catalyst-voices/commit/69dba1d24022eb77cc03ac670dda0da047304766))
 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))

#### `catalyst_compression` - `v0.2.0`

 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))

#### `catalyst_compression_web` - `v0.2.0`

 - **FEAT**: cose flutter package structure ([#649](https://github.com/input-output-hk/catalyst-voices/issues/649)). ([1875849c](https://github.com/input-output-hk/catalyst-voices/commit/1875849c530babbd69dce3882423cc7d9ffdbfa4))
 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))

#### `catalyst_cose` - `v0.2.0`

 - **FEAT**: cose flutter package structure ([#649](https://github.com/input-output-hk/catalyst-voices/issues/649)). ([1875849c](https://github.com/input-output-hk/catalyst-voices/commit/1875849c530babbd69dce3882423cc7d9ffdbfa4))
 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))


## 2024-07-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`catalyst_cardano` - `v0.1.3`](#catalyst_cardano---v013)
 - [`catalyst_cardano_platform_interface` - `v0.1.3`](#catalyst_cardano_platform_interface---v013)
 - [`catalyst_cardano_serialization` - `v0.1.3`](#catalyst_cardano_serialization---v013)
 - [`catalyst_cardano_web` - `v0.1.3`](#catalyst_cardano_web---v013)
 - [`catalyst_compression` - `v0.1.1`](#catalyst_compression---v011)
 - [`catalyst_compression_platform_interface` - `v0.1.1`](#catalyst_compression_platform_interface---v011)
 - [`catalyst_compression_web` - `v0.1.1`](#catalyst_compression_web---v011)

---

#### `catalyst_cardano` - `v0.1.3`

 - **FIX**: catalyst cardano integration with Typhoon wallet ([#636](https://github.com/input-output-hk/catalyst-voices/issues/636)). ([2c6e270d](https://github.com/input-output-hk/catalyst-voices/commit/2c6e270ddcb95389ac417ffe5f60ccabc04b5931))
 - **FEAT**: rbac metadata envelope ([#630](https://github.com/input-output-hk/catalyst-voices/issues/630)). ([150d5676](https://github.com/input-output-hk/catalyst-voices/commit/150d567636c4281c092d020d51882e638b16beb5))
 - **FEAT**: catalyst compression - brotli/zstd ([#626](https://github.com/input-output-hk/catalyst-voices/issues/626)). ([2b8e7d72](https://github.com/input-output-hk/catalyst-voices/commit/2b8e7d7239f9982aa7144a676a86d21b97f912fb))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

#### `catalyst_cardano_platform_interface` - `v0.1.3`

 - **FIX**: catalyst cardano integration with Typhoon wallet ([#636](https://github.com/input-output-hk/catalyst-voices/issues/636)). ([2c6e270d](https://github.com/input-output-hk/catalyst-voices/commit/2c6e270ddcb95389ac417ffe5f60ccabc04b5931))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

#### `catalyst_cardano_serialization` - `v0.1.3`

 - **FEAT**: rbac metadata envelope ([#630](https://github.com/input-output-hk/catalyst-voices/issues/630)). ([150d5676](https://github.com/input-output-hk/catalyst-voices/commit/150d567636c4281c092d020d51882e638b16beb5))
 - **FEAT**: rbac metadata ([#619](https://github.com/input-output-hk/catalyst-voices/issues/619)). ([daf24a15](https://github.com/input-output-hk/catalyst-voices/commit/daf24a15a0b8d6345131ca8e3ec33c92865af4f8))
 - **FEAT**: add required signers ([#605](https://github.com/input-output-hk/catalyst-voices/issues/605)). ([bebc0fbd](https://github.com/input-output-hk/catalyst-voices/commit/bebc0fbd241b6370b31b91e5a60b1d5d30cec403))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

#### `catalyst_cardano_web` - `v0.1.3`

 - **FIX**: catalyst cardano integration with Typhoon wallet ([#636](https://github.com/input-output-hk/catalyst-voices/issues/636)). ([2c6e270d](https://github.com/input-output-hk/catalyst-voices/commit/2c6e270ddcb95389ac417ffe5f60ccabc04b5931))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

#### `catalyst_compression` - `v0.1.1`

 - **FEAT**: catalyst compression - brotli/zstd ([#626](https://github.com/input-output-hk/catalyst-voices/issues/626)). ([2b8e7d72](https://github.com/input-output-hk/catalyst-voices/commit/2b8e7d7239f9982aa7144a676a86d21b97f912fb))

#### `catalyst_compression_platform_interface` - `v0.1.1`

 - **FEAT**: catalyst compression - brotli/zstd ([#626](https://github.com/input-output-hk/catalyst-voices/issues/626)). ([2b8e7d72](https://github.com/input-output-hk/catalyst-voices/commit/2b8e7d7239f9982aa7144a676a86d21b97f912fb))

#### `catalyst_compression_web` - `v0.1.1`

 - **FEAT**: catalyst compression - brotli/zstd ([#626](https://github.com/input-output-hk/catalyst-voices/issues/626)). ([2b8e7d72](https://github.com/input-output-hk/catalyst-voices/commit/2b8e7d7239f9982aa7144a676a86d21b97f912fb))


## 2024-07-04

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`catalyst_analysis` - `v1.2.0`](#catalyst_analysis---v120)
 - [`catalyst_cardano` - `v0.1.2`](#catalyst_cardano---v012)
 - [`catalyst_cardano_platform_interface` - `v0.1.2`](#catalyst_cardano_platform_interface---v012)
 - [`catalyst_cardano_serialization` - `v0.1.2`](#catalyst_cardano_serialization---v012)
 - [`catalyst_cardano_web` - `v0.1.2`](#catalyst_cardano_web---v012)

---

#### `catalyst_analysis` - `v1.2.0`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))
 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**(poc): add catalyst voices remote widgets ([#320](https://github.com/input-output-hk/catalyst-voices/issues/320)). ([cd566225](https://github.com/input-output-hk/catalyst-voices/commit/cd56622574b5d6074a3f7308acabdbbe2035a62d))
 - **FEAT**: improve frontend app architecture ([#158](https://github.com/input-output-hk/catalyst-voices/issues/158)). ([1a9e7950](https://github.com/input-output-hk/catalyst-voices/commit/1a9e7950346689fd56ebd911b60f3f8eb7671e60))
 - **FEAT**: add catalyst voices assets pub ([#154](https://github.com/input-output-hk/catalyst-voices/issues/154)). ([e82e3c81](https://github.com/input-output-hk/catalyst-voices/commit/e82e3c8121d4a011e3c31ac2a909b0f19e5643f0))

#### `catalyst_cardano` - `v0.1.2`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))
 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

#### `catalyst_cardano_platform_interface` - `v0.1.2`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

#### `catalyst_cardano_serialization` - `v0.1.2`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))
 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: catalyst cardano transaction builder ([#501](https://github.com/input-output-hk/catalyst-voices/issues/501)). ([e150394f](https://github.com/input-output-hk/catalyst-voices/commit/e150394fb348e88b016e03ab69efe782f9daf94f))
 - **FEAT**: catalyst cardano documentation ([#507](https://github.com/input-output-hk/catalyst-voices/issues/507)). ([f003e8d9](https://github.com/input-output-hk/catalyst-voices/commit/f003e8d90d23d350ea07ee69a73d6be7c5af191b))
 - **FEAT**: catalyst cardano witnesses management ([#490](https://github.com/input-output-hk/catalyst-voices/issues/490)). ([dfbb9f83](https://github.com/input-output-hk/catalyst-voices/commit/dfbb9f837f88fbd0e3e02eff67a7515826380df1))
 - **FEAT**: add shelley address & cardano serialization lib ([#478](https://github.com/input-output-hk/catalyst-voices/issues/478)). ([6d985bbc](https://github.com/input-output-hk/catalyst-voices/commit/6d985bbce2e2e2f5d827f3c19a752c6c19ce93af))

#### `catalyst_cardano_web` - `v0.1.2`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))


## 2024-07-01

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`catalyst_analysis` - `v1.1.1`](#catalyst_analysis---v111)
 - [`catalyst_cardano` - `v0.1.1+1`](#catalyst_cardano---v0111)
 - [`catalyst_cardano_serialization` - `v0.1.1+1`](#catalyst_cardano_serialization---v0111)
 - [`catalyst_cardano_web` - `v0.1.1+1`](#catalyst_cardano_web---v0111)
 - [`catalyst_cardano_platform_interface` - `v0.1.1+1`](#catalyst_cardano_platform_interface---v0111)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `catalyst_cardano_web` - `v0.1.1+1`
 - `catalyst_cardano_platform_interface` - `v0.1.1+1`

---

#### `catalyst_analysis` - `v1.1.1`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))

#### `catalyst_cardano` - `v0.1.1+1`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))

#### `catalyst_cardano_serialization` - `v0.1.1+1`

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))


## 2024-06-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`catalyst_analysis` - `v1.1.0`](#catalyst_analysis---v110)
 - [`catalyst_cardano` - `v0.1.1`](#catalyst_cardano---v011)
 - [`catalyst_cardano_platform_interface` - `v0.1.1`](#catalyst_cardano_platform_interface---v011)
 - [`catalyst_cardano_serialization` - `v0.1.1`](#catalyst_cardano_serialization---v011)
 - [`catalyst_cardano_web` - `v0.1.1`](#catalyst_cardano_web---v011)

---

#### `catalyst_analysis` - `v1.1.0`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**(poc): add catalyst voices remote widgets ([#320](https://github.com/input-output-hk/catalyst-voices/issues/320)). ([cd566225](https://github.com/input-output-hk/catalyst-voices/commit/cd56622574b5d6074a3f7308acabdbbe2035a62d))
 - **FEAT**: improve frontend app architecture ([#158](https://github.com/input-output-hk/catalyst-voices/issues/158)). ([1a9e7950](https://github.com/input-output-hk/catalyst-voices/commit/1a9e7950346689fd56ebd911b60f3f8eb7671e60))
 - **FEAT**: add catalyst voices assets pub ([#154](https://github.com/input-output-hk/catalyst-voices/issues/154)). ([e82e3c81](https://github.com/input-output-hk/catalyst-voices/commit/e82e3c8121d4a011e3c31ac2a909b0f19e5643f0))

#### `catalyst_cardano` - `v0.1.1`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

#### `catalyst_cardano_platform_interface` - `v0.1.1`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

#### `catalyst_cardano_serialization` - `v0.1.1`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: catalyst cardano transaction builder ([#501](https://github.com/input-output-hk/catalyst-voices/issues/501)). ([e150394f](https://github.com/input-output-hk/catalyst-voices/commit/e150394fb348e88b016e03ab69efe782f9daf94f))
 - **FEAT**: catalyst cardano documentation ([#507](https://github.com/input-output-hk/catalyst-voices/issues/507)). ([f003e8d9](https://github.com/input-output-hk/catalyst-voices/commit/f003e8d90d23d350ea07ee69a73d6be7c5af191b))
 - **FEAT**: catalyst cardano witnesses management ([#490](https://github.com/input-output-hk/catalyst-voices/issues/490)). ([dfbb9f83](https://github.com/input-output-hk/catalyst-voices/commit/dfbb9f837f88fbd0e3e02eff67a7515826380df1))
 - **FEAT**: add shelley address & cardano serialization lib ([#478](https://github.com/input-output-hk/catalyst-voices/issues/478)). ([6d985bbc](https://github.com/input-output-hk/catalyst-voices/commit/6d985bbce2e2e2f5d827f3c19a752c6c19ce93af))

#### `catalyst_cardano_web` - `v0.1.1`

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

