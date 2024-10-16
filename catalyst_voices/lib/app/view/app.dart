import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class App extends StatefulWidget {
  final RouterConfig<Object> routerConfig;

  const App({
    super.key,
    required this.routerConfig,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// A singleton bloc that manages the user session.
  final SessionBloc _sessionBloc = Dependencies.instance.get();

  @override
  void initState() {
    super.initState();
    _sessionBloc.add(const RestoreSessionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _multiBlocProviders(),
      child: BlocListener<SessionBloc, SessionState>(
        listenWhen: _listenToSessionChangesWhen,
        listener: _onSessionChanged,
        child: AppContent(
          routerConfig: widget.routerConfig,
        ),
      ),
    );
  }

  List<BlocProvider> _multiBlocProviders() {
    return [
      BlocProvider<AuthenticationBloc>(
        create: (_) => Dependencies.instance.get<AuthenticationBloc>(),
      ),
      BlocProvider<LoginBloc>(
        create: (_) => Dependencies.instance.get<LoginBloc>(),
      ),
      BlocProvider<SessionBloc>.value(value: _sessionBloc),
    ];
  }

  bool _listenToSessionChangesWhen(SessionState prev, SessionState next) {
    // We deliberately check if previous was guest because we don't
    // want to show the snackbar after the registration is completed.
    final keychainUnlocked =
        prev is GuestSessionState && next is ActiveUserSessionState;

    final keychainLocked =
        prev is ActiveUserSessionState && next is GuestSessionState;

    return keychainUnlocked || keychainLocked;
  }

  void _onSessionChanged(BuildContext context, SessionState state) {
    if (state is ActiveUserSessionState) {
      _onUnlockedKeychain();
    } else if (state is GuestSessionState) {
      _onLockedKeychain();
    }
  }

  void _onUnlockedKeychain() {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      icon: VoicesAssets.icons.lockOpen.buildIcon(),
      title: context.l10n.unlockSnackbarTitle,
      message: context.l10n.unlockSnackbarMessage,
    ).show(context);
  }

  void _onLockedKeychain() {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      icon: VoicesAssets.icons.lockClosed.buildIcon(),
      title: context.l10n.lockSnackbarTitle,
      message: context.l10n.lockSnackbarMessage,
    ).show(context);
  }
}
