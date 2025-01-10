import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

enum _YesNoChoice {
  yes(true),
  no(false);

  // ignore: avoid_positional_boolean_parameters
  const _YesNoChoice(this.value);

  final bool value;

  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      yes => localizations.yes,
      no => localizations.no,
    };
  }
}

class YesNoChoiceWidget extends StatefulWidget {
  final DocumentProperty<bool> property;
  final ValueChanged<DocumentChange> onChanged;
  final String description;
  final bool isEditMode;
  final bool isRequired;

  const YesNoChoiceWidget({
    super.key,
    required this.property,
    required this.onChanged,
    required this.description,
    required this.isEditMode,
    required this.isRequired,
  });

  @override
  State<YesNoChoiceWidget> createState() => _YesNoChoiceWidgetState();
}

class _YesNoChoiceWidgetState extends State<YesNoChoiceWidget> {
  Set<_YesNoChoice> _iconsMultiSelection = const {};
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        VoicesSegmentedButton<_YesNoChoice>(
          segments: _YesNoChoice.values
              .map(
                (choice) => ButtonSegment(
                  value: choice,
                  label: Text(choice.localizedName(context.l10n)),
                ),
              )
              .toList(),
          selected: _iconsMultiSelection,
          onChanged: (selected) {
            setState(() {
              _iconsMultiSelection = Set.from(selected);
            });
          },
          emptySelectionAllowed: true,
        ),
      ],
    );
  }
}
