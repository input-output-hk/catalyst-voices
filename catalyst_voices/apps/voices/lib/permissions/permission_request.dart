import 'dart:async';

import 'package:catalyst_voices/permissions/permission_handler_factory.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequest extends Equatable {
  final Permission permission;
  final Completer<PermissionResult> completer;

  const PermissionRequest(this.permission, this.completer);

  @override
  List<Object?> get props => [permission, completer];
}
