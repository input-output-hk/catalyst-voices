import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
      child: AppContent(
        routerConfig: widget.routerConfig,
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
}
