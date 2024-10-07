import 'package:equatable/equatable.dart';

final class RecoverStateData extends Equatable {
  final bool foundKeychain;

  const RecoverStateData({
    this.foundKeychain = false,
  });

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
