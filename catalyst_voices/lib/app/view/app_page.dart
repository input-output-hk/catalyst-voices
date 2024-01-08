import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final CredentialsStorageRepository _credentialsStorageRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppContent(),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _authenticationRepository.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _configureRepositories();
  }

  void _configureRepositories() {
    _credentialsStorageRepository = CredentialsStorageRepository(
      secureStorageService: SecureStorageService(),
    );

    _authenticationRepository = AuthenticationRepository(
      credentialsStorageRepository: _credentialsStorageRepository,
    );
  }
}
