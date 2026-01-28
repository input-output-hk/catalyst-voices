import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/display_consent_choice_picker.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DisplayConsentChoiceMenu extends StatelessWidget {
  final CollaboratorDisplayConsentStatus selectedStatus;
  final ValueChanged<CollaboratorDisplayConsentStatus> onSelected;

  const DisplayConsentChoiceMenu({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DisplayConsentChoicePicker(items: _consentChoiceItems(context), onSelected: onSelected);
  }

  List<DropdownMenuViewModel<CollaboratorDisplayConsentStatus>> _consentChoiceItems(
    BuildContext context,
  ) => CollaboratorDisplayConsentStatusAllowedOptions.allowedOptions.map((item) {
    return DropdownMenuViewModel(
      value: item,
      name: item.changedStatusToLocalized(context),
      isSelected: item == selectedStatus,
    );
  }).toList();
}
