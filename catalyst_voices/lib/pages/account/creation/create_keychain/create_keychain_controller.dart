import 'package:catalyst_voices/pages/account/creation/create_keychain/create_keychain_stage.dart';
import 'package:flutter/widgets.dart';

class CreateKeychainController extends ChangeNotifier {
  CreateKeychainStage _stage;

  CreateKeychainController({
    CreateKeychainStage stage = CreateKeychainStage.splash,
  }) : _stage = stage;

  CreateKeychainStage get stage => _stage;

  void goToNextStage() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    goToStage(nextStage);
  }

  void goToPreviousStage() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final nextStage = CreateKeychainStage.values[currentStageIndex - 1];
    goToStage(nextStage);
  }

  void goToStage(CreateKeychainStage stage) {
    _stage = stage;
    notifyListeners();
  }

  /// Looks up tree for [CreateKeychainControllerScope] and if found
  /// returns assisted controller.
  static CreateKeychainController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CreateKeychainControllerScope>()
        ?.controller;
  }

  /// Utility for [maybeOf]. Unwrapping controller with assertion.
  static CreateKeychainController of(BuildContext context) {
    final controller = maybeOf(context);

    assert(
      controller != null,
      'Unable to find CreateKeychainControllerScope as parent widget',
    );

    return controller!;
  }
}

class CreateKeychainControllerScope extends InheritedWidget {
  final CreateKeychainController controller;

  const CreateKeychainControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant CreateKeychainControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
