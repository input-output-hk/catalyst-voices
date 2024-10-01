import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RoleChooserCard extends StatelessWidget {
  final String imageUrl;
  final bool value;
  final String label;
  final String viewMoreUrl;
  final ValueChanged<bool>? onChanged;

  const RoleChooserCard({
    super.key,
    required this.imageUrl,
    required this.value,
    required this.label,
    required this.viewMoreUrl,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              children: [
                CatalystImage.asset(
                  imageUrl,
                  width: 70,
                  height: 70,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async => launchUrlString(viewMoreUrl),
                        child: Text(
                          'Learn more',
                          style: TextStyle(
                            color: Theme.of(context).colors.textPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: VoicesSegmentedButton<bool>(
                          segments: [
                            ButtonSegment(
                              value: true,
                              label: const Text('Yes'),
                              icon: value ? const Icon(Icons.check) : null,
                            ),
                            ButtonSegment(
                              value: false,
                              label: const Text('No'),
                              icon: !value ? const Icon(Icons.block) : null,
                            ),
                          ],
                          selected: {value},
                          onChanged: (selected) => onChanged?.call(!value),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
