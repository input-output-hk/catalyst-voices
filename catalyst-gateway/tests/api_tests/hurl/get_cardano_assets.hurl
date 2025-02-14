# Get staked ADA amount: zero assets
GET http://localhost:3030/api/draft/cardano/assets/stake_test1ursne3ndzr4kz8gmhmstu5026erayrnqyj46nqkkfcn0ufss2t7vt
HTTP 200
{"persistent":{"ada_amount":9809147618,"native_tokens":[],"slot_number":76323283},"volatile":{"ada_amount":0,"native_tokens":[],"slot_number":0}}

# Get staked ADA amount: single asset
GET http://localhost:3030/api/draft/cardano/assets/stake_test1uq7cnze6az9f8ffjrvkxx4ad77jz088frkhzupxcc7y4x8q5x808s
HTTP 200
{"persistent":{"ada_amount":8870859858,"native_tokens":[{"amount":3,"asset_name":"GoldRelic","policy_hash":"0x2862c9b33e98096107e2d8b8c072070834db9c91c0d2f3743e75df65"}],"slot_number":76572358},"volatile":{"ada_amount":0,"native_tokens":[],"slot_number":0}}

# Get staked ADA amount: multiple assets
GET http://localhost:3030/api/draft/cardano/assets/stake_test1ur66dds0pkf3j5tu7py9tqf7savpv7pgc5g3dd74xy0x2vsldf2mx
HTTP 200
[Asserts]
jsonpath "$.persistent.native_tokens" count == 9