import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';

extension CatalystIdPublicExt on CatalystIDPublic {
  CatalystIDPublic decode() {
    final username = this.username as String?;
    if (username == null) {
      return this;
    }

    return copyWith(
      // decoding from Uri to replace %20 for white space, etc.
      username: Uri.decodeComponent(username),
    );
  }
}
