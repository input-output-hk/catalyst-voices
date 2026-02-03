import 'dart:async';

import 'package:catalyst_voices/app/view/app_content.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';

/// Main app widget. Builds globally accessible [Bloc]s via [MultiBlocProvider].
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
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _multiBlocProviders(),
      child: AppContent(
        routerConfig: widget.routerConfig,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(Dependencies.instance.get<UserService>().useLocalUser());
    Dependencies.instance.get<SessionCubit>().init();
  }

  List<BlocProvider> _multiBlocProviders() {
    return [
      BlocProvider<AdminToolsCubit>(
        create: (_) => Dependencies.instance.get<AdminToolsCubit>(),
      ),
      BlocProvider<SystemStatusCubit>(
        create: (_) => Dependencies.instance.get<SystemStatusCubit>(),
      ),
      BlocProvider<SessionCubit>(
        create: (_) => Dependencies.instance.get<SessionCubit>(),
      ),
      BlocProvider<CampaignBuilderCubit>(
        create: (_) => Dependencies.instance.get<CampaignBuilderCubit>(),
      ),
      BlocProvider<CategoryDetailCubit>(
        create: (_) => Dependencies.instance.get<CategoryDetailCubit>(),
      ),
      BlocProvider<AccountCubit>(
        create: (context) => Dependencies.instance.get<AccountCubit>(),
      ),
      BlocProvider<NewProposalCubit>(
        create: (_) => Dependencies.instance.get<NewProposalCubit>(),
      ),
      BlocProvider<DevToolsBloc>(
        create: (_) => Dependencies.instance.get<DevToolsBloc>(),
      ),
      BlocProvider<CampaignPhaseAwareCubit>(
        // Making it not lazy to not show two loading screens in a row (one for app splash screen and one for campaign phase aware)
        lazy: false,
        create: (_) => Dependencies.instance.get<CampaignPhaseAwareCubit>(),
      ),
      // Have to be global
      BlocProvider<VotingBallotBloc>(
        create: (_) => Dependencies.instance.get<VotingBallotBloc>(),
      ),
      BlocProvider<FeatureFlagsCubit>(
        create: (_) => Dependencies.instance.get<FeatureFlagsCubit>(),
      ),
      BlocProvider<SyncIndicatorCubit>(
        create: (_) => Dependencies.instance.get<SyncIndicatorCubit>(),
      ),
    ];
  }
}
