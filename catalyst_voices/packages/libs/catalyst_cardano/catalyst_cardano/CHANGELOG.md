## 0.4.0

 - **REFACTOR**(cat-voices): self contained frontend dir ([#1082](https://github.com/input-output-hk/catalyst-voices/issues/1082)). ([62e5f437](https://github.com/input-output-hk/catalyst-voices/commit/62e5f43778fab323d7c1e4ebab4b5e89c1ba0cb5))
 - **FIX**(cat-voices): equatable lint issue fix ([#1280](https://github.com/input-output-hk/catalyst-voices/issues/1280)). ([e551c617](https://github.com/input-output-hk/catalyst-voices/commit/e551c61702ab4a229c88119a43611a42516b2665))
 - **FEAT**(cat-voices): Integration tests using flutter_driver ([#1304](https://github.com/input-output-hk/catalyst-voices/issues/1304)). ([34de044c](https://github.com/input-output-hk/catalyst-voices/commit/34de044c9b5f22f2c0fb7406a25699c5bd12b9f5))
 - **FEAT**: rust key derivation ([#1063](https://github.com/input-output-hk/catalyst-voices/issues/1063)). ([0712347b](https://github.com/input-output-hk/catalyst-voices/commit/0712347b1e6e85d67b43d1733650d62d1c9d7c94))
 - **FEAT**(general): Bump cat-ci to `v3.2.23` ([#1125](https://github.com/input-output-hk/catalyst-voices/issues/1125)). ([d967d275](https://github.com/input-output-hk/catalyst-voices/commit/d967d2750f6b9b1fb3b80366380572e7528268d4))

## 0.3.0

> Note: This release has breaking changes.

 - **FIX**: catalyst cardano null utxos ([#746](https://github.com/input-output-hk/catalyst-voices/issues/746)). ([3f2f5925](https://github.com/input-output-hk/catalyst-voices/commit/3f2f592593efe306f85fb0e81ce07aa1ea90b7b6))
 - **FIX**: rbac txn inputs hash ([#688](https://github.com/input-output-hk/catalyst-voices/issues/688)). ([b644026f](https://github.com/input-output-hk/catalyst-voices/commit/b644026fa3b675591d071819eda185365257f0d1))
 - **BREAKING** **FEAT**: add initial support for Cardano Native scripts, Plutus scripts, advanced transaction outputs, and additional transaction body fields and witnesses ([#713](https://github.com/input-output-hk/catalyst-voices/issues/713)). ([74fcb725](https://github.com/input-output-hk/catalyst-voices/commit/74fcb725f221bb3acf3824a3dd18a073d0a321e0))
 - **BREAKING** **CHORE**: upgrade flutter to 3.24.1 and dart to 3.5.0 ([#725](https://github.com/input-output-hk/catalyst-voices/issues/725)). ([eb8a516e](https://github.com/input-output-hk/catalyst-voices/commit/eb8a516edbd25386c0fbe41501285870abf82543))

## 0.2.0+1

 - Update a dependency to the latest release.

## 0.2.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**: signData return type should be DataSignature, not VkeyWitness ([#647](https://github.com/input-output-hk/catalyst-voices/issues/647)). ([69dba1d2](https://github.com/input-output-hk/catalyst-voices/commit/69dba1d24022eb77cc03ac670dda0da047304766))
 - **BREAKING** **FIX**: X509 registration metadata encoding ([#640](https://github.com/input-output-hk/catalyst-voices/issues/640)). ([c45a2ac9](https://github.com/input-output-hk/catalyst-voices/commit/c45a2ac96b34c4215352ece5ef9bd2fa73b591e8))
 - **BREAKING** **FEAT**: COSE_SIGN1 signatures and verification ([#669](https://github.com/input-output-hk/catalyst-voices/issues/669)). ([f5a910ef](https://github.com/input-output-hk/catalyst-voices/commit/f5a910efe36442171521b9ec429aed4a46e05b83))

## 0.1.3

 - **FIX**: catalyst cardano integration with Typhoon wallet ([#636](https://github.com/input-output-hk/catalyst-voices/issues/636)). ([2c6e270d](https://github.com/input-output-hk/catalyst-voices/commit/2c6e270ddcb95389ac417ffe5f60ccabc04b5931))
 - **FEAT**: rbac metadata envelope ([#630](https://github.com/input-output-hk/catalyst-voices/issues/630)). ([150d5676](https://github.com/input-output-hk/catalyst-voices/commit/150d567636c4281c092d020d51882e638b16beb5))
 - **FEAT**: catalyst compression - brotli/zstd ([#626](https://github.com/input-output-hk/catalyst-voices/issues/626)). ([2b8e7d72](https://github.com/input-output-hk/catalyst-voices/commit/2b8e7d7239f9982aa7144a676a86d21b97f912fb))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))

## 0.1.2

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))
 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: automate melos release ([#593](https://github.com/input-output-hk/catalyst-voices/issues/593)). ([7e4bf294](https://github.com/input-output-hk/catalyst-voices/commit/7e4bf294a81c8aa73a91170969d2189201869aa0))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

## 0.1.1+1

 - **FIX**: readme versioning for catalyst packages ([#585](https://github.com/input-output-hk/catalyst-voices/issues/585)). ([e433b2db](https://github.com/input-output-hk/catalyst-voices/commit/e433b2dbba7a43c50f4411ea5279a623c221b66b))

## 0.1.1

 - **FIX**: issues before publishing catalyst-cardano ([#581](https://github.com/input-output-hk/catalyst-voices/issues/581)). ([7b5338b3](https://github.com/input-output-hk/catalyst-voices/commit/7b5338b3dd6ab028e56c958a3664b6bf20b24d65))
 - **FEAT**: frontend features ([#549](https://github.com/input-output-hk/catalyst-voices/issues/549)). ([0f094180](https://github.com/input-output-hk/catalyst-voices/commit/0f094180e4cf698365ab8633cceab830da09ec22))
 - **FEAT**: cardano wallet api ([#522](https://github.com/input-output-hk/catalyst-voices/issues/522)). ([0a11853f](https://github.com/input-output-hk/catalyst-voices/commit/0a11853f9885be3a59582ab14639562bc6a246dc))
 - **FEAT**: cardano multiplatform lib plugin structure ([#441](https://github.com/input-output-hk/catalyst-voices/issues/441)). ([1099447a](https://github.com/input-output-hk/catalyst-voices/commit/1099447ae5ad6064caa8462b753529bd80edf70b))

# 0.1.0

* Initial release.
