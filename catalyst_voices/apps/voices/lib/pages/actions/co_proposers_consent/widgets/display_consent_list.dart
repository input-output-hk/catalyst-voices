import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class DisplayConsentList extends StatelessWidget {
  const DisplayConsentList({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [1, 2, 3, 4, 5];
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: BorderRadius.circular(16),
        ),
        sliver: SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Container(
                height: 120,
                color: Colors.grey[300],
                child: Center(
                  child: Text('Card ${cards[index]}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
