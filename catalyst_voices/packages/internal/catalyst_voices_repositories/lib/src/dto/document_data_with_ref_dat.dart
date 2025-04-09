import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class DocumentsDataWithRefData extends Equatable {
  final DocumentData data;
  final DocumentData refData;

  const DocumentsDataWithRefData({
    required this.data,
    required this.refData,
  });

  @override
  List<Object?> get props => [data, refData];
}
