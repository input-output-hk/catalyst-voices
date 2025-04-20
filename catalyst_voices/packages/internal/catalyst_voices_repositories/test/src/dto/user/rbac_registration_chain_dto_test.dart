import 'dart:convert';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/dto/user/rbac_registration_chain_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(RbacRegistrationChain, () {
    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance =
          _FakeBip32Ed25519XPublicKeyFactory();
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
    "roles": {}
}
''';

const _voterAndProposerJson = '''
{
    "catalyst_id": "preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY",
    "last_persistent_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
    "purpose": [
        "ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c"
    ],
    "roles": {
        "0": {
            "extended_data": {
                "10": [
                    111,
                    82,
                    101,
                    103,
                    105,
                    115,
                    116,
                    101,
                    114,
                    32,
                    114,
                    111,
                    108,
                    101,
                    32,
                    48
                ]
            },
            "payment_addresses": [
                {
                    "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
                    "is_persistent": true,
                    "time": "2025-04-10T02:22:19+00:00"
                }
            ],
            "signing_keys": [
                {
                    "is_persistent": true,
                    "key_type": "x509",
                    "key_value": "0x308201fc308201aea0030201020205008d00cd12300506032b6570304231093007060355040613003109300706035504081300310930070603550407130031093007060355040a130031093007060355040b13003109300706035504031300301e170d3235303431303032323134335a170d3939313233313233353935395a304231093007060355040613003109300706035504081300310930070603550407130031093007060355040a130031093007060355040b13003109300706035504031300304a300506032b657003410042149f1a6f1da43fcf066a473e12515b5b6216fedfc52b87bee091456981d9c6d2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866a381a43081a130819e0603551d11048196308193820c6d79646f6d61696e2e636f6d82107777772e6d79646f6d61696e2e636f6d820b6578616d706c652e636f6d820f7777772e6578616d706c652e636f6d86537765622b63617264616e6f3a2f2f616464722f7374616b655f7465737431757268737871383939367979377661727a306b6772306576326539776c74766b6372306b757a643477777a73647a71767430653874300506032b657003410097cdda6815238e059116a6906157d94d93373ac6d6f92649a20446a51f0e6c34f76db1fabbdb20128c32522bcac1522526e360f00160c354e396e5dabc961b07",
                    "time": "2025-04-10T02:22:19+00:00"
                }
            ]
        },
        "3": {
            "extended_data": {
                "10": [
                    100,
                    72,
                    105,
                    104,
                    105
                ]
            },
            "payment_addresses": [
                {
                    "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
                    "is_persistent": true,
                    "time": "2025-04-10T02:22:19+00:00"
                },
                {
                    "address": "addr_test1qr4jr9uuq0hdwgrsyze2pdr4vk6647c69suyndv6r75wd30qwklppmzu2aw2l7mgkzxrz3cxvm20uxhw5p7pd4j88yps20uevn",
                    "is_persistent": true,
                    "time": "2025-04-11T04:49:07+00:00"
                }
            ],
            "signing_keys": [
                {
                    "is_persistent": true,
                    "key_type": "pubkey",
                    "key_value": "0xac36a7c87a77de72c3404cca36029e63cdd5cc6e7b2538a52908eee983011b51",
                    "time": "2025-04-10T02:22:19+00:00"
                },
                {
                    "is_persistent": true,
                    "key_type": "pubkey",
                    "key_value": "0xac36a7c87a77de72c3404cca36029e63cdd5cc6e7b2538a52908eee983011b51",
                    "time": "2025-04-11T04:49:07+00:00"
                }
            ]
        }
    }
}
''';

const _voterJson = '''
{
    "catalyst_id": "preprod.cardano/QhSfGm8dpD_PBmpHPhJRW1tiFv7fxSuHvuCRRWmB2cY",
    "last_persistent_txn": "0x95f781a3db75af41d1dde5a997b9f9ab3e20035882d4a2ccafdc81cfda6f52a2",
    "purpose": [
        "ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c"
    ],
    "roles": {
        "0": {
            "extended_data": {
                "10": [
                    111,
                    82,
                    101,
                    103,
                    105,
                    115,
                    116,
                    101,
                    114,
                    32,
                    114,
                    111,
                    108,
                    101,
                    32,
                    48
                ]
            },
            "payment_addresses": [
                {
                    "address": "addr_test1qr3f7dmpr59t8vtp8an9ptrxvetvd4t7mzxwdp9tdjva8580qvqw2t5gfue6xylvsxljc4j2a7kedsxldcym2uu9q6yqs0ju92",
                    "is_persistent": true,
                    "time": "2025-04-10T02:22:19+00:00"
                }
            ],
            "signing_keys": [
                {
                    "is_persistent": true,
                    "key_type": "x509",
                    "key_value": "0x308201fc308201aea0030201020205008d00cd12300506032b6570304231093007060355040613003109300706035504081300310930070603550407130031093007060355040a130031093007060355040b13003109300706035504031300301e170d3235303431303032323134335a170d3939313233313233353935395a304231093007060355040613003109300706035504081300310930070603550407130031093007060355040a130031093007060355040b13003109300706035504031300304a300506032b657003410042149f1a6f1da43fcf066a473e12515b5b6216fedfc52b87bee091456981d9c6d2a76829a3b53e66af79bb0cb1efade075f0ae65eaaabb75f5106bbeef59b866a381a43081a130819e0603551d11048196308193820c6d79646f6d61696e2e636f6d82107777772e6d79646f6d61696e2e636f6d820b6578616d706c652e636f6d820f7777772e6578616d706c652e636f6d86537765622b63617264616e6f3a2f2f616464722f7374616b655f7465737431757268737871383939367979377661727a306b6772306576326539776c74766b6372306b757a643477777a73647a71767430653874300506032b657003410097cdda6815238e059116a6906157d94d93373ac6d6f92649a20446a51f0e6c34f76db1fabbdb20128c32522bcac1522526e360f00160c354e396e5dabc961b07",
                    "time": "2025-04-10T02:22:19+00:00"
                }
            ]
        }
    }
}
''';
/* cSpell:enable */

class _FakeBip32Ed25519XPublicKey extends Fake
    implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPublicKey(this.bytes);
}

class _FakeBip32Ed25519XPublicKeyFactory extends Fake
    implements Bip32Ed25519XPublicKeyFactory {
  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPublicKey(bytes);
  }
}
