import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

/// A child builder that builds a widget depending on the [data] of type [T].
typedef ResultChildBuilder<T> = Widget Function(BuildContext context, T data);

/// A builder that builds different children depending
/// on the state of the [result].
///
/// If [result] is [Success] then [successBuilder] is used.
/// If [result] is [Failure] then [failureBuilder] is used.
/// If [Result] is `null` then [loadingBuilder] is used.
///
/// The builder implements a [minLoadingDuration] which will delay
/// [Success] or [Failure] state so that the [loadingBuilder] child is shown
/// no shorter than the [minLoadingDuration].
///
/// This prevents showing the loading state a split second before going
/// to the next state.
class ResultBuilder<S, F> extends StatefulWidget {
  final Result<S, F>? result;
  final ResultChildBuilder<S> successBuilder;
  final ResultChildBuilder<F> failureBuilder;
  final WidgetBuilder loadingBuilder;
  final Duration minLoadingDuration;

  const ResultBuilder({
    super.key,
    this.result,
    required this.successBuilder,
    required this.failureBuilder,
    required this.loadingBuilder,
    this.minLoadingDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ResultBuilder<S, F>> createState() => _ResultBuilderState<S, F>();
}

class _ResultBuilderState<S, F> extends State<ResultBuilder<S, F>> {
  Result<S, F>? _result;
  late DateTime _resultUpdatedAt;
  Timer? _updateResultTimer;

  @override
  void initState() {
    super.initState();

    _updateResult(widget.result);
  }

  @override
  void didUpdateWidget(ResultBuilder<S, F> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _cancelResultUpdate();

    if (_result == null && widget.result != null) {
      if (_wasLoadingShownLongEnough()) {
        _updateResult(widget.result);
      } else {
        _scheduleResultUpdate();
      }
    } else {
      _updateResult(widget.result);
    }
  }

  @override
  void dispose() {
    _updateResultTimer?.cancel();
    super.dispose();
  }

  bool _wasLoadingShownLongEnough() {
    final now = DateTimeExt.now();
    final duration = now.difference(_resultUpdatedAt);
    return duration >= widget.minLoadingDuration;
  }

  void _scheduleResultUpdate() {
    final now = DateTimeExt.now();
    final duration = now.difference(_resultUpdatedAt);
    if (duration >= widget.minLoadingDuration) {
      _updateResult(widget.result);
    } else {
      _updateResultTimer = Timer(
        duration,
        () => _updateResult(widget.result),
      );
    }
  }

  void _cancelResultUpdate() {
    _updateResultTimer?.cancel();
    _updateResultTimer = null;
  }

  void _updateResult(Result<S, F>? result) {
    if (mounted) {
      setState(() {
        _result = result;
        _resultUpdatedAt = DateTimeExt.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_result) {
      Success(:final value) => widget.successBuilder(context, value),
      Failure(:final value) => widget.failureBuilder(context, value),
      _ => widget.loadingBuilder(context),
    };
  }
}
