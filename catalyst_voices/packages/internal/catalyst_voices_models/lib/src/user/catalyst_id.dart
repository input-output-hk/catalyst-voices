import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Definition of a URI, which allows for RBAC keys used for different
/// purposes to be easily and unambiguously identified.
///
/// See: https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/rbac_id_uri/catalyst-id-uri/
final class CatalystId extends Equatable {
  /// The default scheme for the Catalyst ID.
  static const String idScheme = 'id.catalyst';

  /// [Uri.fragment] if the key is for encryption.
  ///
  /// If the fragment is not present in the uri then the key is for signing.
  static const String encryptFragment = 'encrypt';

  /// The scheme part of the URI.
  final String scheme;

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
  final Uint8List role0Key;

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
    this.scheme = CatalystId.idScheme,
    required this.host,
    this.username,
    this.nonce,
    required this.role0Key,
    this.role,
    this.rotation,
    this.encrypt = false,
  }) : assert(
         role0Key.length == 32,
         'Role0Key must be 32 bytes long. '
         'Make sure to use plain public key, '
         'not the extended public key.',
       );

  /// Parses the [CatalystId] from [Uri].
  factory CatalystId.fromUri(Uri uri) {
    final scheme = uri.scheme;
    final (username, nonce) = _parseUserInfo(uri.userInfo);
    final (role0Key, role, rotation) = _parsePath(uri.path);

    return CatalystId(
      scheme: scheme,
      host: uri.host,
      username: username,
      nonce: nonce,
      role0Key: role0Key,
      role: role,
      rotation: rotation,
      encrypt: uri.fragment.equalsIgnoreCase(encryptFragment),
    );
  }

  /// A convenience factory for parsing a [CatalystId] from a string.
  ///
  /// This method is a wrapper around [CatalystId.fromUri] that first parses
  /// the input [data] string into a [Uri] and then constructs the [CatalystId].
  ///
  /// Throws a [FormatException] if the [data] string is not a valid URI.
  factory CatalystId.parse(String data) {
    return CatalystId.fromUri(Uri.parse(data));
  }

  @override
  List<Object?> get props => [
    host,
    username,
    nonce,
    role0Key,
    role,
    rotation,
    encrypt,
  ];

  CatalystId copyWith({
    String? scheme,
    String? host,
    Optional<String>? username,
    Optional<int>? nonce,
    Uint8List? role0Key,
    Optional<AccountRole>? role,
    Optional<int>? rotation,
    bool? encrypt,
  }) {
    return CatalystId(
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      username: username.dataOr(this.username),
      nonce: nonce.dataOr(this.nonce),
      role0Key: role0Key ?? this.role0Key,
      role: role.dataOr(this.role),
      rotation: rotation.dataOr(this.rotation),
      encrypt: encrypt ?? this.encrypt,
    );
  }

  /// Objects which holds [CatalystId] can be uniquely identified only by
  /// comparing [role0Key] and [host] thus they're significant parts of
  /// [CatalystId].
  CatalystId toSignificant() => CatalystId(scheme: scheme, host: host, role0Key: role0Key);

  @override
  String toString() => toUri().toString();

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

  CatalystId withoutUsername() => copyWith(username: const Optional.empty());

  String _formatPath() {
    final encodedRole0Key = base64UrlNoPadEncode(role0Key);
    final role = this.role?.number.toString();
    final rotation = this.rotation?.toString();

    final parts = [
      encodedRole0Key,
      if (role != null) role,
      if (rotation != null) rotation,
    ];

    return parts.join('/');
  }

  String? _formatUserInfo() {
    final username = this.username?.trim() ?? '';
    final nonce = this.nonce;

    final parts = [
      username,
      if (nonce != null) nonce,
    ];
    final userInfo = parts.join(':');
    return userInfo.isNotEmpty ? userInfo : null;
  }

  /// A convenience method that wraps [CatalystId.parse] in a `try-catch`
  /// block.
  ///
  /// If [data] is a valid [CatalystId] string, it will be parsed and
  /// a [CatalystId] instance will be returned. Otherwise, `null` is returned.
  static CatalystId? tryParse(String data) {
    try {
      return CatalystId.parse(data);
    } catch (_) {
      return null;
    }
  }

  /// Parses the data from [Uri.path].
  ///
  /// Format: role0Key[/roleNumber][/rotation]
  static (Uint8List role0Key, AccountRole? role, int? rotation) _parsePath(String path) {
    final sanitizedPath = _sanitizePath(Uri.decodeComponent(path));
    final parts = sanitizedPath.split('/');

    final role0Key = parts.elementAt(0);
    final role = int.tryParse(parts.elementAtOrNull(1) ?? '');
    final rotation = int.tryParse(parts.elementAtOrNull(2) ?? '');

    final decodedRole0Key = base64UrlNoPadDecode(role0Key);
    final catalystRole0Key = decodedRole0Key;
    final accountRole = role != null ? AccountRole.fromNumber(role) : null;

    return (catalystRole0Key, accountRole, rotation);
  }

  /// Parse [username] and [nonce] from [Uri.userInfo].
  ///
  /// Format: [username][:nonce]
  static (String? username, int? nonce) _parseUserInfo(String userInfo) {
    final decoded = Uri.decodeComponent(userInfo);
    final parts = decoded.split(':');
    final username = parts.elementAtOrNull(0) ?? '';
    final nonce = parts.elementAtOrNull(1) ?? '';

    return (
      username.isNotBlank ? username : null,
      nonce.isNotBlank ? int.parse(nonce) : null,
    );
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
    return CatalystIdHost.values.firstWhere(
      (element) => element.host.equalsIgnoreCase(host),
      orElse: () => CatalystIdHost.undefined,
    );
  }
}
