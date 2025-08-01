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
    unawaited(Dependencies.instance.get<UserService>().useLastAccount());
  }

  List<BlocProvider> _multiBlocProviders() {
    return [
      BlocProvider<AdminToolsCubit>(
        create: (_) => Dependencies.instance.get<AdminToolsCubit>(),
      ),
      BlocProvider<SessionCubit>(
        create: (_) => Dependencies.instance.get<SessionCubit>(),
      ),
      BlocProvider<ProposalsCubit>(
        create: (_) => Dependencies.instance.get<ProposalsCubit>(),
      ),
      BlocProvider<CampaignInfoCubit>(
        create: (_) => Dependencies.instance.get<CampaignInfoCubit>(),
      ),
      BlocProvider<CampaignBuilderCubit>(
        create: (_) => Dependencies.instance.get<CampaignBuilderCubit>(),
      ),
      BlocProvider<WorkspaceBloc>(
        create: (context) => Dependencies.instance.get<WorkspaceBloc>(),
      ),
      BlocProvider<DiscoveryCubit>(
        create: (context) => Dependencies.instance.get<DiscoveryCubit>(),
      ),
      BlocProvider<CategoryDetailCubit>(
        create: (_) => Dependencies.instance.get<CategoryDetailCubit>(),
      ),
      BlocProvider<AccountCubit>(
        create: (context) => Dependencies.instance.get<AccountCubit>(),
      ),
      BlocProvider<ProposalCubit>(
        create: (_) => Dependencies.instance.get<ProposalCubit>(),
      ),
      BlocProvider<NewProposalCubit>(
        create: (_) => Dependencies.instance.get<NewProposalCubit>(),
      ),
      BlocProvider<CampaignStageCubit>(
        lazy: false,
        create: (_) => Dependencies.instance.get<CampaignStageCubit>(),
      ),
      BlocProvider<DevToolsBloc>(
        create: (_) => Dependencies.instance.get<DevToolsBloc>(),
      ),
      BlocProvider<PublicProfileEmailStatusCubit>(
        create: (_) => Dependencies.instance.get<PublicProfileEmailStatusCubit>(),
      ),
    ];
  }
}
