import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class FeatureFlagsCard extends StatelessWidget {
  const FeatureFlagsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoCard(
      title: Text('Feature Flags'),
      children: [_FeatureFlagsTable()],
    );
  }
}

class _FeatureFlagsTable extends StatelessWidget {
  const _FeatureFlagsTable();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<FeatureFlagsCubit, FeatureFlagsState>(
      builder: (context, state) {
        return Table(
          border: TableBorder.all(color: colors.outlineBorder),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(color: colors.onSurfaceNeutralOpaqueLv1),
              children: const [
                _HeaderTableCell(title: 'Feature'),
                _HeaderTableCell(title: 'Effective (Source)'),
                _HeaderTableCell(title: 'User Override'),
              ],
            ),
            // Features flags rows
            ...state.features.values.map((info) {
              return TableRow(
                decoration: info.isAvailable
                    ? null
                    : BoxDecoration(color: colors.onSurfaceNeutralOpaqueLv1),
                children: [
                  _FeatureTableCell(info),
                  _FeatureFlagValueTableCell(info),
                  _UserOverrideTableCell(info),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

class _FeatureFlagValueTableCell extends StatelessWidget {
  final FeatureFlagInfo featureFlagInfo;

  const _FeatureFlagValueTableCell(this.featureFlagInfo);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final colors = context.colors;
    final isEnabled = featureFlagInfo.enabled;
    final isAvailable = featureFlagInfo.isAvailable;
    final sourceName = featureFlagInfo.sourceType.name;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isAvailable
              ? (isEnabled ? colors.successContainer : colors.errorContainer)
              : colors.onSurfaceNeutralOpaqueLv2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$isEnabled ($sourceName)',
          style: textTheme.bodyMedium?.copyWith(
            color: isAvailable
                ? (isEnabled ? colors.onSuccessContainer : colors.onErrorContainer)
                : colors.textDisabled,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FeatureTableCell extends StatelessWidget {
  final FeatureFlagInfo featureFlagInfo;

  const _FeatureTableCell(this.featureFlagInfo);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final colors = context.colors;
    final feature = featureFlagInfo.feature;
    final isAvailable = featureFlagInfo.isAvailable;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature.type.name,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isAvailable ? colors.textPrimary : colors.textDisabled,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            feature.description,
            style: textTheme.bodySmall?.copyWith(
              color: isAvailable
                  ? colors.textPrimary.withValues(alpha: 0.7)
                  : colors.textDisabled.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTableCell extends StatelessWidget {
  final String title;

  const _HeaderTableCell({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UserOverrideTableCell extends StatelessWidget {
  final FeatureFlagInfo featureFlagInfo;

  const _UserOverrideTableCell(this.featureFlagInfo);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final feature = featureFlagInfo.feature;
    final isAvailable = featureFlagInfo.isAvailable;
    final cubit = context.read<FeatureFlagsCubit>();
    final userOverrideValue = isAvailable ? cubit.getUserOverride(feature) : null;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _mapCheckboxValue(userOverrideValue),
            tristate: true,
            onChanged: isAvailable
                ? (value) => cubit.setUserOverride(feature, value: _mapCheckboxValue(value))
                : null,
          ),
          Text(
            userOverrideValue.toString(),
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: isAvailable ? colors.textPrimary : colors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  /// Map [value] to get checkbox state
  /// value == true   => checked
  /// value == false  => dash
  /// value == null   => unchecked
  bool? _mapCheckboxValue(bool? value) {
    return switch (value) {
      null => false,
      true => true,
      false => null,
    };
  }
}
