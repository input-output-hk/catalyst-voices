import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

extension ExceptionMapper on Exception {
  LocalizedException toLocalizedException() {
    if (this is NotFoundException) {
      return const LocalizedNotFoundException();
    } else {
      return const LocalizedUnknownException();
    }
  }
}
