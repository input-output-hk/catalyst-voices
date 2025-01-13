import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
  final bool isEditMode;
  final bool isRequired;

  const YesNoChoiceWidget({
    super.key,
    required this.property,
    required this.onChanged,
    required this.isEditMode,
    required this.isRequired,
  });

  @override
  State<YesNoChoiceWidget> createState() => _YesNoChoiceWidgetState();
}

class _YesNoChoiceWidgetState extends State<YesNoChoiceWidget> {
  late bool? selectedValue;

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
          context,
          value: widget.property.value,
          enabled: widget.isEditMode,
          onChanged: _handleValueChanged,
          validator: (value) {
            // TODO(dtscalac): add validation
            final result = widget.property.schema.validatePropertyValue(value);

            return LocalizedDocumentValidationResult.from(result)
                .message(context);
          },
        ),
      ],
    );
  }

  void _handleInitialValue() {
    selectedValue = widget.property.value;
  }

  void _handleValueChanged(bool? value) {
    setState(() {
      selectedValue = widget.property.value;
    });
    if (value == null && widget.property.value != value) {
      _notifyChangeListener(value);
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

class _YesNoChoiceSegmentButton extends FormField<bool?> {
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  _YesNoChoiceSegmentButton(
    BuildContext context, {
    super.key,
    required this.value,
    required this.onChanged,
    super.validator,
    super.enabled,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          initialValue: value,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            void onChangedHandler(Set<bool> selected) {
              final newValue = selected.isEmpty ? null : selected.first;
              field.didChange(newValue);
              onChanged?.call(newValue);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  ignoring: !enabled,
                  child: VoicesSegmentedButton<bool>(
                    key: key,
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(context.l10n.yes),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(context.l10n.no),
                      ),
                    ],
                    selected: value != null ? {value} : {},
                    onChanged: onChangedHandler,
                    emptySelectionAllowed: true,
                    style: _getButtonStyle(field),
                  ),
                ),
                if (field.hasError)
                  Text(
                    field.errorText ?? context.l10n.snackbarErrorLabelText,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
              ],
            );
          },
        );

  static ButtonStyle? _getButtonStyle(FormFieldState<bool?> field) {
    if (field.errorText == null) return null;

    return ButtonStyle(
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Theme.of(field.context).colorScheme.error,
        ),
      ),
    );
  }
}
