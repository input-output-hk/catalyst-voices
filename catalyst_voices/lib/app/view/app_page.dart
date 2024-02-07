// ignore_for_file: discarded_futures

import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final Future<void> _initFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        return MultiBlocProvider(
          providers: _multiBlocProviders(),
          child: const AppContent(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  Future<void> _init() async {
    await Dependency.instance.init();
  }

  List<BlocProvider> _multiBlocProviders() {
    return [
      BlocProvider<AuthenticationBloc>(
        create: (_) => Dependency.instance.get<AuthenticationBloc>(),
      ),
      BlocProvider<LoginBloc>(
        create: (_) => Dependency.instance.get<LoginBloc>(),
      ),
    ];
  }
}
