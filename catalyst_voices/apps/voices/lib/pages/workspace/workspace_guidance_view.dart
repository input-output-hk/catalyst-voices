import 'package:catalyst_voices/common/ext/guidance_ext.dart';
import 'package:catalyst_voices/widgets/cards/guidance_card.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class GuidanceView extends StatefulWidget {
  final List<Guidance> guidances;
  const GuidanceView(this.guidances, {super.key});

  @override
  State<GuidanceView> createState() => _GuidanceViewState();
}

class _GuidanceViewState extends State<GuidanceView> {
  final List<Guidance> filteredGuidances = [];

  GuidanceType? selectedType;

  @override
  void initState() {
    super.initState();
    filteredGuidances
      ..clear()
      ..addAll(widget.guidances);
  }

  @override
  void didUpdateWidget(GuidanceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.guidances != widget.guidances) {
      filteredGuidances
        ..clear()
        ..addAll(widget.guidances);
      _filterGuidances(selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        VoicesDropdown<GuidanceType?>(
          items: GuidanceType.values
              .map(
                (e) => VoicesDropdownMenuEntry<GuidanceType>(
                  label: e.localizedType(context.l10n),
                  value: e,
                  context: context,
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _filterGuidances(value);
            });
          },
          value: selectedType,
        ),
        if (filteredGuidances.isEmpty)
          Center(
            child: Text(context.l10n.noGuidanceOfThisType),
          ),
        Column(
          children: filteredGuidances
              .sortedByWeight()
              .toList()
              .map((e) => GuidanceCard(guidance: e))
              .toList(),
        ),
      ],
    );
  }

  void _filterGuidances(GuidanceType? type) {
    selectedType = type;
    filteredGuidances
      ..clear()
      ..addAll(
        type == null
            ? widget.guidances
            : widget.guidances.where((e) => e.type == type).toList(),
      );
  }
}
