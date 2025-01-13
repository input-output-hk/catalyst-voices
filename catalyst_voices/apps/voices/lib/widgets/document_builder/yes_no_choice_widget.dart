import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

enum _YesNoChoice {
  yes(true),
  no(false);

  // ignore: avoid_positional_boolean_parameters
  const _YesNoChoice(this.value);

  // ignore: avoid_positional_boolean_parameters
  static _YesNoChoice fromBool(bool value) {
    return _YesNoChoice.values.firstWhere((e) => e.value == value);
  }

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
  late Set<_YesNoChoice> selectedValue;

  @override
  void initState() {
    super.initState();

    _handleInitialValue();
  }

  @override
  void didUpdateWidget(covariant YesNoChoiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.property.value != widget.property.value) {
      _handleInitialValue();
    }

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _handleInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.description.isNotEmpty) ...[
          Text(
            widget.description,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        _YesNoChoiceSegmentButton(
          value: selectedValue,
          onChanged: _handleValueChanged,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleInitialValue() {
    final value = widget.property.value;
    if (value != null) {
      selectedValue = {_YesNoChoice.fromBool(value)};
    } else {
      selectedValue = {};
    }
  }

  void _handleValueChanged(Set<_YesNoChoice> value) {
    setState(() {
      selectedValue = Set.from(value);
    });
    if (widget.property.value != value.first.value && value.isNotEmpty) {
      _notifyChangeListener(value.first.value);
    }
  }

  void _notifyChangeListener(bool? value) {
    widget.onChanged(
      DocumentChange(
        nodeId: widget.property.schema.nodeId,
        value: value,
      ),
    );
  }
}

class _YesNoChoiceSegmentButton extends StatelessWidget {
  final Set<_YesNoChoice> value;
  final ValueChanged<Set<_YesNoChoice>> onChanged;
  final bool enabled;

  const _YesNoChoiceSegmentButton({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: VoicesSegmentedButton<_YesNoChoice>(
        segments: _YesNoChoice.values
            .map(
              (choice) => ButtonSegment(
                value: choice,
                label: Text(choice.localizedName(context.l10n)),
              ),
            )
            .toList(),
        selected: value,
        onChanged: onChanged,
        emptySelectionAllowed: true,
      ),
    );
  }
}
