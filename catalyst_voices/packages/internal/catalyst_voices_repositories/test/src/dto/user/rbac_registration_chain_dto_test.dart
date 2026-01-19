import 'dart:convert';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
import 'package:catalyst_voices_repositories/src/dto/user/rbac_registration_chain_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(RbacRegistrationChain, () {
    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance = FakeBip32Ed25519XPublicKeyFactory();
    });

    RbacRegistrationChain getRegistrationChain(String jsonString) {
      final jsonData = json.decode(jsonString);
      final jsonMap = jsonData as Map<String, dynamic>;
      return RbacRegistrationChain.fromJson(jsonMap);
    }

    test('can decode catalystId', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.catalystId,
        equals('preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY'),
      );
    });

    test('can decode lastPersistentTxn', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.lastPersistentTxn,
        equals(
          '0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2',
        ),
      );
    });

    test('can decode lastVolatileTxn', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.lastVolatileTxn,
        equals(
          '0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2',
        ),
      );
    });

    test('can decode purpose', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.purpose,
        equals(['ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c']),
      );
    });

    test('can decode voter & proposer roles', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.accountRoles,
        equals({AccountRole.voter, AccountRole.proposer}),
      );
    });

    test('can decode voter only role', () {
      final registrationChain = getRegistrationChain(_voterJson);

      expect(
        registrationChain.accountRoles,
        equals({AccountRole.voter}),
      );
    });

    test('cannot decode registration without roles', () {
      final registrationChain = getRegistrationChain(_noRoleJson);

      expect(
        () => registrationChain.accountRoles,
        throwsA(isArgumentError),
      );
    });

    test('can decode stake address', () {
      final registrationChain = getRegistrationChain(_voterAndProposerJson);

      expect(
        registrationChain.stakeAddress,
        /* cSpell:disable */
        equals(
          ShelleyAddress.fromBech32(
            'stake_test1urhsxq8996yy7varz0kgr0ev2e9wltvkcr0kuzd4wwzsdzqvt0e8t',
          ),
        ),
        /* cSpell:enable */
      );
    });
  });
}

/* cSpell:disable */
const _noRoleJson = '''
{
    "catalyst_id": "preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY",
    "last_persistent_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
    "purpose": [
        "ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c"
    ],
    "roles": []
}
''';

const _voterAndProposerJson = r'''
{
  "catalyst_id": "preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY",
  "last_persistent_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
  "last_volatile_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
  "purpose": [
    "ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c"
  ],
  "invalid": [
    {
      "previous_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
      "purpose": "c9993e54-1ee1-41f7-ab99-3fdec865c744",
      "report": {
        "kind": "Error",
        "msg": "An error has occurred, the details of the error are ..."
      },
      "slot": 1234567,
      "time": "2024-04-09T15:28:21+00:00",
      "txn_id": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
      "txn_index": 7
    }
  ],
  "roles": [
    {
      "role_id": 0,
      "encryption_keys": [
        {
          "is_persistent": true,
          "key_type": "x509",
          "key_value": {
            "pubkey": "0x56CDD154355E078A0990F9E633F9553F7D43A68B2FF9BEF78B9F5C71C808A7C8"
          },
          "slot": 1234567,
          "time": "2024-04-09T15:28:21+00:00",
          "txn_index": 7
        }
      ],
      "extended_data": [
        {
          "key": 10,
          "value": "0x6f526567697374657220726f6c652030"
        }
      ],
      "payment_addresses": [
        {
          "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
          "is_persistent": true,
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ],
      "signing_keys": [
        {
          "is_persistent": true,
          "key_type": "x509",
          "key_value": {
            "x509": "-----BEGIN CERTIFICATE-----\nMIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE\nCBMAMQkwBwYDVQQHEwAxCTAHBgNVBAoTADEJMAcGA1UECxMAMQkwBwYDVQQDEwAw\nHhcNMjUwNDEwMDIyMTQzWhcNOTkxMjMxMjM1OTU5WjBCMQkwBwYDVQQGEwAxCTAH\nBgNVBAgTADEJMAcGA1UEBxMAMQkwBwYDVQQKEwAxCTAHBgNVBAsTADEJMAcGA1UE\nAxMAMEowBQYDK2VwA0EAQhSfGm8dpD/PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cbS\np2gpo7U+Zq95uwyx763gdfCuZeqqu3X1EGu+71m4ZqOBpDCBoTCBngYDVR0RBIGW\nMIGTggxteWRvbWFpbi5jb22CEHd3dy5teWRvbWFpbi5jb22CC2V4YW1wbGUuY29t\ngg93d3cuZXhhbXBsZS5jb22GU3dlYitjYXJkYW5vOi8vYWRkci9zdGFrZV90ZXN0\nMXVyaHN4cTg5OTZ5eTd2YXJ6MGtncjBldjJlOXdsdHZrY3Iwa3V6ZDR3d3pzZHpx\ndnQwZTh0MAUGAytlcANBAJfN2mgVI44FkRamkGFX2U2TNzrG1vkmSaIERqUfDmw0\n922x+rvbIBKMMlIrysFSJSbjYPABYMNU45bl2ryWGwc=\n-----END CERTIFICATE-----"
          },
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ]
    },
    {
      "role_id": 3,
      "encryption_keys": [
        {
          "is_persistent": true,
          "key_type": "x509",
          "key_value": {
            "pubkey": "0x56CDD154355E078A0990F9E633F9553F7D43A68B2FF9BEF78B9F5C71C808A7C8"
          },
          "slot": 1234567,
          "time": "2024-04-09T15:28:21+00:00",
          "txn_index": 7
        }
      ],
      "extended_data": [
        {
          "key": 10,
          "value": "0x6448696869"
        }
      ],
      "payment_addresses": [
        {
          "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
          "is_persistent": true,
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        },
        {
          "address": "addr_test1qr4jr9uuq0hdwgrsyze2pdr4vk6647c69suyndv6r75wd30qwklppmzu2aw2l7mgkzxrz3cxvm20uxhw5p7pd4j88yps20uevn",
          "is_persistent": true,
          "time": "2025-04-11T04:49:07+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ],
      "signing_keys": [
        {
          "is_persistent": true,
          "key_type": "pubkey",
          "key_value": {
            "pubkey": "0xac36a7c87a77de72c3404cca36029e63cdd5cc6e7b2538a52908eee983011b51"
          },
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        },
        {
          "is_persistent": true,
          "key_type": "pubkey",
          "key_value": {
            "pubkey": "0xac36a7c87a77de72c3404cca36029e63cdd5cc6e7b2538a52908eee983011b51"
          },
          "time": "2025-04-11T04:49:07+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ]
    }
  ]
}
''';

const _voterJson = r'''
{
  "catalyst_id": "preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY",
  "last_persistent_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
  "purpose": [
    "ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c"
  ],
  "roles": [
    {
      "role_id": 0,
      "encryption_keys": [
        {
          "is_persistent": true,
          "key_type": "x509",
          "key_value": {
            "pubkey": "0x56CDD154355E078A0990F9E633F9553F7D43A68B2FF9BEF78B9F5C71C808A7C8"
          },
          "slot": 1234567,
          "time": "2024-04-09T15:28:21+00:00",
          "txn_index": 7
        }
      ],
      "extended_data": [
        {
          "key": 10,
          "value": "0x6f526567697374657220726f6c652030"
        }
      ],
      "payment_addresses": [
        {
          "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
          "is_persistent": true,
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ],
      "signing_keys": [
        {
          "is_persistent": true,
          "key_type": "x509",
          "key_value": {
            "x509": "-----BEGIN CERTIFICATE-----\nMIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE\nCBMAMQkwBwYDVQQHEwAxCTAHBgNVBAoTADEJMAcGA1UECxMAMQkwBwYDVQQDEwAw\nHhcNMjUwNDEwMDIyMTQzWhcNOTkxMjMxMjM1OTU5WjBCMQkwBwYDVQQGEwAxCTAH\nBgNVBAgTADEJMAcGA1UEBxMAMQkwBwYDVQQKEwAxCTAHBgNVBAsTADEJMAcGA1UE\nAxMAMEowBQYDK2VwA0EAQhSfGm8dpD/PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cbS\np2gpo7U+Zq95uwyx763gdfCuZeqqu3X1EGu+71m4ZqOBpDCBoTCBngYDVR0RBIGW\nMIGTggxteWRvbWFpbi5jb22CEHd3dy5teWRvbWFpbi5jb22CC2V4YW1wbGUuY29t\ngg93d3cuZXhhbXBsZS5jb22GU3dlYitjYXJkYW5vOi8vYWRkci9zdGFrZV90ZXN0\nMXVyaHN4cTg5OTZ5eTd2YXJ6MGtncjBldjJlOXdsdHZrY3Iwa3V6ZDR3d3pzZHpx\ndnQwZTh0MAUGAytlcANBAJfN2mgVI44FkRamkGFX2U2TNzrG1vkmSaIERqUfDmw0\n922x+rvbIBKMMlIrysFSJSbjYPABYMNU45bl2ryWGwc=\n-----END CERTIFICATE-----"
          },
          "time": "2025-04-10T02:22:19+00:00",
          "slot": 1234567,
          "txn_index": 7
        }
      ]
    }
  ]
}
''';
/* cSpell:enable */
