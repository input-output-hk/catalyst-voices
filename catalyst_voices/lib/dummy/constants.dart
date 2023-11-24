import 'package:flutter/foundation.dart';

bool isUserLoggedIn = false;

abstract class WidgetKeys {
  static const loginScreen = Key('loginScreen');
  static const usernameTextController = Key('usernameTextController');
  static const passwordTextController = Key('passwordTextController');
  static const loginButton = Key('loginButton');
  static const loginErrorSnackbar = Key('loginErrorSnackbar');
  static const homeScreen = Key('homeScreen');
}
