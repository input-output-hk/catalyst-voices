import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoicesSpacesExample extends StatelessWidget {
  static const String route = '/spaces-example';

  const VoicesSpacesExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoicesAppBar(
        actions: [
          _SessionHeader(),
        ],
      ),
      drawer: const VoicesDrawer(children: []),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _SpacesNavigationLocation()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32)
                .add(const EdgeInsets.only(bottom: 32)),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const _Segment(name: 'Segment 1'),
                  const SizedBox(height: 24),
                  const _Segment(name: 'Segment 2'),
                  const SizedBox(height: 24),
                  const _Segment(name: 'Segment 3'),
                ],
              ),
            ),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Spacer(),
                StandardLinksPageFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const _VisitorSessionHeader(),
          GuestSessionState() => const _GuestSessionHeader(),
          ActiveUserSessionState() => const _ActiveUserSessionHeader(),
        };
      },
    );
  }
}

class _VisitorSessionHeader extends StatelessWidget {
  const _VisitorSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          child: Text('Get Started'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('Visitor'),
        ),
      ],
    );
  }
}

class _GuestSessionHeader extends StatelessWidget {
  const _GuestSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          trailing: Icon(CatalystVoicesIcons.lock_open),
          child: Text('Unlock'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('Guest'),
        ),
      ],
    );
  }
}

class _ActiveUserSessionHeader extends StatelessWidget {
  const _ActiveUserSessionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesFilledButton(
          trailing: Icon(CatalystVoicesIcons.lock_closed),
          child: Text('Lock'),
          onTap: () =>
              context.read<SessionBloc>().add(const NextStateSessionEvent()),
        ),
        const SizedBox(width: 12),
        VoicesFilledButton(
          child: Text('John Smith'),
        ),
      ],
    );
  }
}

class _SpacesNavigationLocation extends StatelessWidget {
  const _SpacesNavigationLocation();

  @override
  Widget build(BuildContext context) {
    return const NavigationLocation(
      parts: [
        'Discovery Space',
        'Homepage',
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1376 / 673,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.onSurfaceNeutralOpaqueLv1,
          border: Border.all(color: theme.colors.outlineBorderVariant!),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colors.textOnPrimary,
              ),
            ),
            const Spacer(),
            VoicesFilledButton(
              child: const Text('CTA to Model'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
