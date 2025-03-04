import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// An interface for the mapper of [Document].
// ignore: one_member_abstracts
abstract interface class DocumentMapper {
  DocumentDataContent toContent(Document document);
}
