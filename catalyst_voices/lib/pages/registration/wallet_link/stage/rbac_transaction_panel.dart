import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): define content
class RbacTransactionPanel extends StatelessWidget {
  const RbacTransactionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).previousStep();
          },
          child: const Text('Previous'),
        ),
        const SizedBox(height: 12),
        VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).nextStep();
          },
          child: const Text('Next'),
        ),
      ],
    );
  }
}