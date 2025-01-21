import 'package:catalyst_voices/pages/discovery/how_it_works.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _Body(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) => state.account?.isProposer ?? false,
      builder: (context, state) {
        return _GuestVisitorBody(
          isProposer: state,
        );
      },
    );
  }
}

class _GuestVisitorBody extends StatelessWidget {
  final bool isProposer;

  const _GuestVisitorBody({required this.isProposer});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const _HeroSection(),
                const HowItWorks(),
                const _CurrentCampaign(),
                const _CampaignCategories(),
                const _LatestProposals(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _CampaignCategories extends StatelessWidget {
  const _CampaignCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      fallbackHeight: 1440,
      child: Text('Campaign Categories'),
    );
  }
}

class _CurrentCampaign extends StatelessWidget {
  const _CurrentCampaign({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      fallbackHeight: 900,
      child: Text('Current Campaign'),
    );
  }
}

class _LatestProposals extends StatelessWidget {
  const _LatestProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      color: Colors.blueGrey,
      child: Text('Latest Proposals'),
    );
  }
}
