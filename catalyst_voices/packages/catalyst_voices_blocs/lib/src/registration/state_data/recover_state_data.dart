import 'package:equatable/equatable.dart';

final class RecoverStateData extends Equatable {
  const RecoverStateData({
    this.foundKeychain = false,
  });

  final bool foundKeychain;

  RecoverStateData copyWith({
    bool? foundKeychain,
  }) {
    return RecoverStateData(
      foundKeychain: foundKeychain ?? this.foundKeychain,
    );
  }

  @override
  List<Object?> get props => [
        foundKeychain,
      ];
}
