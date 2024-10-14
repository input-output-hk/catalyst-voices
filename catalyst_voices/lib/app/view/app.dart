import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class App extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const App({
    super.key,
    required this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _multiBlocProviders(),
      child: AppContent(
        routerConfig: routerConfig,
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
      BlocProvider<SessionBloc>(
        create: (_) => Dependencies.instance.get<SessionBloc>()
          ..add(const RestoreSessionEvent()),
      ),
    ];
  }
}
