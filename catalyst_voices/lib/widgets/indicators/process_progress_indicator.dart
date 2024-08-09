import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ProcessProgressStep<T extends Object> {
  final T value;
  final String name;

  ProcessProgressStep({
    required this.value,
    required this.name,
  });
}

enum _StepIndicatorType {
  standard,
  completes;

  bool get isStandard => this == _StepIndicatorType.standard;

  bool get isCompleted => this == _StepIndicatorType.completes;
}

enum _StepIndicatorStatus {
  completed,
  current,
  upcoming;

  bool get isCompleted => this == _StepIndicatorStatus.completed;

  bool get isCurrent => this == _StepIndicatorStatus.current;

  bool get isUpcoming => this == _StepIndicatorStatus.upcoming;
}

class ProcessProgressIndicator<T extends Object> extends StatelessWidget {
  final List<ProcessProgressStep<T>> steps;
  final Set<T> completed;
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
      constraints: BoxConstraints.tightFor(
        height: !neighborhood.previous || !neighborhood.next ? 60 : 50,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepStatusIndicatorContainer(
            isExpanded: type == _StepIndicatorType.completes,
            neighborhood: neighborhood,
            child: _StepStatusIndicator(
              type: type,
              status: status,
            ),
          ),
          _StepNameText(
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

class _StepNameText extends StatelessWidget {
  const _StepNameText(
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
          _StepIndicatorStatus.current => theme.textTheme.titleSmall
              ?.copyWith(color: theme.colors.textOnPrimary),
          _StepIndicatorStatus.completed when type.isCompleted =>
            theme.textTheme.titleSmall?.copyWith(color: theme.colors.success),
          _StepIndicatorStatus.completed ||
          _StepIndicatorStatus.upcoming =>
            theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colors.textOnPrimary),
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
          // TODO(damian): Use VoicesDivider when available
          if (neighborhood.previous) const Expanded(child: VerticalDivider()),

          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50, maxWidth: 60),
            child: child,
          ),
          if (neighborhood.next) const Expanded(child: VerticalDivider()),
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
