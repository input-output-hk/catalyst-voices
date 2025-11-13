import 'package:equatable/equatable.dart';

class AppVersion extends Equatable {
  final String versionNumber;
  final int buildNumber;

  const AppVersion({required this.versionNumber, required this.buildNumber});

  @override
  List<Object?> get props => [versionNumber, buildNumber];
}
