import 'dart:convert';

import 'package:catalyst_voices_models/src/crypto/catalyst_public_key.dart';
import 'package:catalyst_voices_models/src/user/account_role.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Definition of a URI, which allows for RBAC keys used for different
/// purposes to be easily and unambiguously identified.
///
/// See: https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/rbac_id_uri/catalyst-id-uri/
final class CatalystId extends Equatable {
  /// The default scheme for the Catalyst ID.
  static const String scheme = 'id.catalyst';

  /// [Uri.fragment] if the key is for encryption.
  ///
  /// If the fragment is not present in the uri then the key is for signing.
  static const String encryptFragment = 'encrypt';

  /// The host refers to the network type where the RBAC registration was made.
  ///
  /// It IS NOT resolvable with DNS, and IS NOT a public host name.
  /// It is used as a decentralized network identifier.
  /// The consumer of the ID must be able to resolve these host names
  /// to known and supported blockchain networks.
  final String host;

  /// User defined readable name that can be attached to the keychain.
  final String? username;

  /// The nonce part contained in the password component of the username
  /// must be an integer, and it is the number of seconds since 1970 UTC,
  /// when the Catalyst ID URI was generated.
  final int? nonce;

  /// This is the very first role 0 key used to post
  /// the registration to the network.
  final CatalystPublicKey role0Key;

  //// Optional - This is the Role number being used.
  final AccountRole? role;

  /// Optional - This is the rotation of the defined role key being identified.
  final int? rotation;

  /// `true` if the key is for encryption, `false` for signing.
  ///
  /// `false` by default.
  final bool encrypt;

  /// The default constructor that builds [CatalystId] from [Uri] parts.
  const CatalystId({
    required this.host,
    this.username,
    this.nonce,
    required this.role0Key,
    this.role,
    this.rotation,
    this.encrypt = false,
  });

  /// Parses the [CatalystId] from [Uri].
  factory CatalystId.fromUri(Uri uri) {
    final (username, nonce) = _parseUserInfo(uri.userInfo);
    final (role0Key, role, rotation) = _parsePath(uri.path);

    return CatalystId(
      host: uri.host,
      username: username,
      nonce: nonce,
      role0Key: role0Key,
      role: role,
      rotation: rotation,
      encrypt: uri.fragment.toLowerCase() == encryptFragment.toLowerCase(),
    );
  }

  @override
  List<Object?> get props => [
        host,
        username,
        scheme,
        role0Key,
        role,
        rotation,
        encrypt,
      ];

  /// Builds the [Uri] from the [CatalystId].
  Uri toUri() {
    return Uri(
      scheme: scheme,
      userInfo: _formatUserInfo(),
      host: host,
      path: _formatPath(),
      fragment: encrypt ? encryptFragment : null,
    );
  }

  String _formatPath() {
    final buffer = StringBuffer(base64Encode(role0Key.bytes));

    final role = this.role?.number;
    if (role != null) {
      buffer.write('/$role');
    }

    final rotation = this.rotation;
    if (rotation != null) {
      buffer.write('/$rotation');
    }

    return buffer.toString();
  }

  String? _formatUserInfo() {
    final username = this.username;
    final nonce = this.nonce;

    final hasUsername = username != null && username.isNotBlank;
    final hasNonce = nonce != null;

    if (hasUsername && hasNonce) {
      return '$username:$nonce';
    } else if (hasUsername) {
      return username;
    } else if (hasNonce) {
      return ':$nonce';
    } else {
      return null;
    }
  }

  /// Parses the data from [Uri.path].
  ///
  /// Format: role0Key[/roleNumber][/rotation]
  static (
    CatalystPublicKey role0Key,
    AccountRole? role,
    int? rotation,
  ) _parsePath(String path) {
    final sanitizedPath = _sanitizePath(path);
    final parts = sanitizedPath.split('/');

    final role0Key = parts.elementAt(0);
    final role = parts.elementAtOrNull(1);
    final rotation = parts.elementAtOrNull(2);

    final decodedRole0Key = base64Decode(role0Key);
    final catalystRole0Key =
        CatalystPublicKey.factory.createPublicKey(decodedRole0Key);

    final roleNumber = role != null ? int.tryParse(role) : null;
    final accountRole =
        roleNumber != null ? AccountRole.fromNumber(roleNumber) : null;

    final rotationInt = rotation != null ? int.tryParse(rotation) : null;

    return (catalystRole0Key, accountRole, rotationInt);
  }

  /// Parse [username] and [nonce] from [Uri.userInfo].
  ///
  /// Format: [username][:nonce]
  static (String? username, int? nonce) _parseUserInfo(String userInfo) {
    if (userInfo.isEmpty) {
      return (null, null);
    } else if (!userInfo.contains(':')) {
      return (userInfo, null);
    } else {
      final parts = userInfo.split(':');
      return (parts[0], int.parse(parts[1]));
    }
  }

  /// Removes the first '/' from the [path].
  static String _sanitizePath(String path) {
    if (path.startsWith('/')) {
      return path.substring(1);
    } else {
      return path;
    }
  }
}

/// Predefined values for [CatalystId.host].
enum CatalystIdHost {
  cardano(host: 'cardano'),
  cardanoPreprod(host: 'preprod.cardano'),
  cardanoPreview(host: 'preview.cardano'),
  midnight(host: 'midnight'),
  ethereum(host: 'ethereum'),
  cosmos(host: 'cosmos'),
  undefined(host: 'undefined');

  final String host;

  const CatalystIdHost({required this.host});

  factory CatalystIdHost.fromHost(String host) {
    for (final value in values) {
      if (value.host.toLowerCase() == host.toLowerCase()) {
        return value;
      }
    }

    return undefined;
  }
}
