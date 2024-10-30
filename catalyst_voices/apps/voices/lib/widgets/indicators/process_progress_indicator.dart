import 'package:catalyst_voices/widgets/separators/voices_vertical_divider.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A class representing a step in a progress indicator.
///
/// Generic type [T] represents the value associated with the step.
class ProcessProgressStep<T extends Object> {
  /// The value associated with the step.
  final T value;

  /// The name of the step.
  final String name;

  ProcessProgressStep({
    required this.value,
    required this.name,
  });
}

/// A widget that displays a progress indicator for a series of steps.
///
/// Generic type [T] represents the value associated with each step.
///
/// Example usage:
/// ```dart
/// ProcessProgressIndicator<int>(
///   steps: [
///     ProcessProgressStep(value: 1, name: 'Step 1'),
///     ProcessProgressStep(value: 2, name: 'Step 2'),
///     ProcessProgressStep(value: 3, name: 'Step 3'),
///   ],
///   completed: {1, 2},
///   current: 2,
/// )
/// ```
class ProcessProgressIndicator<T extends Object> extends StatelessWidget {
  /// The list of steps in the indicator.
  final List<ProcessProgressStep<T>> steps;

  /// The set of completed steps.
  final Set<T> completed;

  /// The current step.
  final T? current;

  const ProcessProgressIndicator({
    super.key,
    required this.steps,
    this.completed = const {},
    this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.mapIndexed(
        (index, step) {
          final isFirst = index == 0;
          final isLast = index == steps.length - 1;
          final isCompleted = completed.contains(step.value);
          final isCurrent = current == step.value;

          final type = isLast
              ? _StepIndicatorType.completes
              : _StepIndicatorType.standard;
          final status = isCompleted
              ? _StepIndicatorStatus.completed
              : isCurrent
                  ? _StepIndicatorStatus.current
                  : _StepIndicatorStatus.upcoming;

          return _StepRow(
            key: ValueKey('Step${step.value}RowKey'),
            name: step.name,
            type: type,
            status: status,
            neighborhood: (previous: !isFirst, next: !isLast),
          );
        },
      ).toList(),
    );
  }
}

enum _StepIndicatorType {
  standard,
  completes;

  bool get isStandard => this == _StepIndicatorType.standard;

  bool get doesCompletes => this == _StepIndicatorType.completes;
}

enum _StepIndicatorStatus {
  completed,
  current,
  upcoming;

  bool get isCompleted => this == _StepIndicatorStatus.completed;

  bool get isCurrent => this == _StepIndicatorStatus.current;

  bool get isUpcoming => this == _StepIndicatorStatus.upcoming;
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    super.key,
    required this.name,
    required this.type,
    required this.status,
    required this.neighborhood,
  });

  final String name;
  final _StepIndicatorType type;
  final _StepIndicatorStatus status;
  final ({bool previous, bool next}) neighborhood;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: !neighborhood.previous || !neighborhood.next
          ? const BoxConstraints.tightFor(height: 60)
          : const BoxConstraints.tightFor(height: 50),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepStatusIndicatorContainer(
            isExpanded: type.doesCompletes,
            neighborhood: neighborhood,
            child: _StepStatusIndicator(
              type: type,
              status: status,
            ),
          ),
          _StepNameTextContainer(
            name,
            type: type,
            status: status,
            neighborhood: neighborhood,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _StepNameTextContainer extends StatelessWidget {
  const _StepNameTextContainer(
    this.data, {
    required this.type,
    required this.status,
    required this.neighborhood,
  });

  final String data;
  final _StepIndicatorType type;
  final _StepIndicatorStatus status;
  final ({bool previous, bool next}) neighborhood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Container(
      padding: !neighborhood.previous
          ? const EdgeInsets.only(top: 14)
          : !neighborhood.next
              ? const EdgeInsets.only(bottom: 10)
              : null,
      alignment: !neighborhood.previous
          ? Alignment.topCenter
          : !neighborhood.next
              ? Alignment.bottomCenter
              : Alignment.center,
      child: Text(
        data,
        style: switch (status) {
          _StepIndicatorStatus.current =>
            textTheme.titleSmall?.copyWith(color: colors.textOnPrimary),
          _StepIndicatorStatus.completed when type.doesCompletes =>
            textTheme.titleSmall?.copyWith(color: colors.success),
          _StepIndicatorStatus.completed ||
          _StepIndicatorStatus.upcoming =>
            textTheme.bodyMedium?.copyWith(color: colors.textOnPrimary),
        },
      ),
    );
  }
}

class _StepStatusIndicatorContainer extends StatelessWidget {
  final bool isExpanded;
  final ({bool previous, bool next}) neighborhood;
  final Widget child;

  const _StepStatusIndicatorContainer({
    this.isExpanded = false,
    required this.neighborhood,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = isExpanded
        ? const EdgeInsets.only(left: 4, right: 10)
        : const EdgeInsets.only(left: 10, right: 16);

    if (!neighborhood.previous) {
      padding = padding.add(const EdgeInsets.only(top: 10));
    }

    return Container(
      constraints: const BoxConstraints.tightFor(width: 56),
      padding: padding,
      alignment: Alignment.center,
      child: Column(
        children: [
          if (neighborhood.previous)
            const Expanded(child: VoicesVerticalDivider()),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50, maxWidth: 60),
            child: child,
          ),
          if (neighborhood.next) const Expanded(child: VoicesVerticalDivider()),
        ],
      ),
    );
  }
}

class _StepStatusIndicator extends StatelessWidget {
  final _StepIndicatorType type;
  final _StepIndicatorStatus status;

  const _StepStatusIndicator({
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: BoxConstraints.tight(_buildSize()),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: status.isCompleted
            ? Theme.of(context).colors.successContainer
            : null,
        border: _buildBorder(context),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: switch (type) {
        _StepIndicatorType.standard when status.isCurrent =>
          const _CurrentStepDot(),
        _StepIndicatorType.standard when status.isCompleted =>
          const _StepIcon(),
        _StepIndicatorType.completes when status.isCompleted =>
          const _StepIcon(showFlag: true),
        _StepIndicatorType.completes =>
          const _StepIcon(showFlag: true, isCompleted: false),
        _StepIndicatorType.standard => null,
      },
    );
  }

  Size _buildSize() {
    return switch (type) {
      _StepIndicatorType.standard => status == _StepIndicatorStatus.current
          ? const Size.square(24)
          : const Size.square(30),
      _StepIndicatorType.completes => const Size.square(40),
    };
  }

  BoxBorder? _buildBorder(BuildContext context) {
    if (status.isCompleted) {
      return null;
    }

    return switch (type) {
      _StepIndicatorType.standard => Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      _StepIndicatorType.completes => Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: status.isCurrent ? 2 : 1,
        ),
    };
  }
}

class _CurrentStepDot extends StatelessWidget {
  const _CurrentStepDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size.square(10)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  final bool showFlag;
  final bool isCompleted;

  const _StepIcon({
    this.showFlag = false,
    this.isCompleted = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: isCompleted
            ? Theme.of(context).colors.iconsSuccess
            : Theme.of(context).colors.iconsForeground,
      ),
      child:
          showFlag ? const Icon(Icons.flag_outlined) : const Icon(Icons.check),
    );
  }
}
