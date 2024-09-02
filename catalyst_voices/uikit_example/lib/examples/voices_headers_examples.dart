import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesHeadersExamples extends StatelessWidget {
  static const String route = '/headers-example';

  const VoicesHeadersExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Headers')),
      body: SizedBox(
        width: 360,
        child: Column(
          children: <Widget>[
            const SectionHeader(title: Text('Proposal stages')),
            SectionHeader(
              leading: VoicesIconButton(
                child: const Icon(CatalystVoicesIcons.arrow_narrow_left),
                onTap: () {},
              ),
              title: const Text('Proposal stages'),
            ),
            SectionHeader(
              title: const Text('Proposal stages'),
              trailing: [
                VoicesIconButton(
                  child: const Icon(CatalystVoicesIcons.cake),
                  onTap: () {},
                ),
                VoicesIconButton(
                  child: const Icon(CatalystVoicesIcons.arrow_narrow_right),
                  onTap: () {},
                ),
              ],
            ),
          ].separatedBy(const SizedBox(height: 16)).toList(),
        ),
      ),
    );
  }
}
