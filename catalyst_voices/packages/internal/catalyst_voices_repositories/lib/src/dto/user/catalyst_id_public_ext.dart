import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';

String? _tryDecodeUsername(dynamic source) {
  if (source is! String) {
    return null;
  }

  try {
    final encoded = Uri.encodeComponent(source);
    final decoded = Uri.decodeComponent(encoded);
    return decoded.replaceAll('%20', ' ');
  } catch (e) {
    return null;
  }
}

extension CatalystIdPublicExt on CatalystIDPublic {
  CatalystIDPublic decode() {
    return copyWith(
      username: _tryDecodeUsername(username),
    );
  }
}
