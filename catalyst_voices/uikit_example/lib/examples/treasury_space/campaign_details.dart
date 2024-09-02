import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class CampaignDetails extends StatelessWidget {
  const CampaignDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        if (index.isOdd) return const SizedBox(height: 16);

        return Container(
          height: 128,
          decoration: BoxDecoration(
            color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
            borderRadius: BorderRadius.circular(28),
          ),
          alignment: Alignment.center,
          child: Text(index.toString()),
        );
      },
    );
  }
}
