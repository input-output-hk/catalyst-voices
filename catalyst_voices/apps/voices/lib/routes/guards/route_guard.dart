import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Interface defining a route guard.
///
/// A route guard is a mechanism to control access to specific routes within
/// a navigation system. It provides a way to intercept navigation requests
/// and decide whether to allow or redirect the user to a different route based
/// on certain conditions.
///
/// **Purpose:**
///
/// - **Authentication:** Ensure that only authenticated users can access
/// protected routes.
/// - **Authorization:** Verify that users have the necessary permissions
/// to access specific routes.
/// - **Conditional access:** Implement custom logic to determine whether
/// a user can proceed to a route.
/// - **Redirection:** Redirect users to appropriate routes based on their
/// authentication status or other criteria.
///
/// **Usage:**
///
/// 1. **Implement the `RouteGuard` interface:** Create a class that implements
/// the `RouteGuard` interface.
/// 2. **Override the `redirect` method:** In the `redirect` method, implement
/// your custom logic to decide whether to allow navigation or redirect
/// the user.
/// 3. **Register the route guard:** Associate the route guard with specific
/// routes in your navigation system.
///
/// **Example:**
///
/// ```dart
/// class AuthenticationGuard implements RouteGuard {
///   @override
///   FutureOr<String?> redirect(BuildContext context, GoRouterState state)
///     async {
///     if (!context.read<AuthenticationBloc>().isAuthenticated) {
///       return const LoginRoute().location; // Redirect to login page if user is not authenticated
///     }
///     return null; // Allow navigation
///   }
/// }
/// ```
///
/// **Note:**
///
/// - The `redirect` method returns a `FutureOr<String?>`. If a `String`
/// is returned, it indicates the path to redirect to. If `null` is returned,
/// navigation is allowed to proceed.
/// - The `BuildContext` and `GoRouterState` parameters provide information
/// about the current navigation context.
// ignore: one_member_abstracts
abstract interface class RouteGuard {
  /// Determines whether to allow navigation or redirect the user to
  /// a different route.
  ///
  /// **Parameters:**
  ///
  /// - `context`: The current build context.
  /// - `state`: The current `GoRouterState` representing
  /// the navigation request.
  ///
  /// **Returns:**
  ///
  /// - A `FutureOr<String?>` indicating the path to redirect to, or `null`
  /// if navigation is allowed.
  FutureOr<String?> redirect(
    BuildContext context,
    GoRouterState state,
  );
}
