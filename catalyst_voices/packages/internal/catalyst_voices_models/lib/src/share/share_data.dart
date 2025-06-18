import 'package:equatable/equatable.dart';

final class ShareData extends Equatable {
  final Uri uri;
  final String? additionalMessage;

  const ShareData({
    required this.uri,
    this.additionalMessage,
  });

  @override
  List<Object?> get props => [uri, additionalMessage];
}
