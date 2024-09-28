import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A callback that generates a new [Future] of type [T].
typedef VoicesFutureProvider<T extends Object> = Future<T> Function();

/// A callback that builds a widget from a [T] value.
///
/// Call [onRetry] if your data state contains
/// the retry button, it will reload the widget.
typedef VoicesFutureDataBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  VoidCallback onRetry,
);

/// A callback that builds a widget in an error state.
///
/// Call [onRetry] if your error state contains
/// the retry button, it will reload the widget.
typedef VoicesFutureErrorBuilder = Widget Function(
  BuildContext context,
  Object? error,
  VoidCallback onRetry,
);

/// A [FutureBuilder] which simplifies handling a [Future] gently.
class VoicesFutureBuilder<T extends Object> extends StatefulWidget {
  /// The future provider, make sure to return a fresh future
  /// each time it is called, the widget takes care of caching
  /// the future internally.
  final VoicesFutureProvider<T> future;

  /// The builder called to build a child
  /// when the [future] finishes successfully.
  final VoicesFutureDataBuilder<T> dataBuilder;

  /// The builder called to build a child
  /// when the [future] finishes with an error.
  ///
  /// If not provided then [VoicesErrorIndicator] is used instead.
  final VoicesFutureErrorBuilder errorBuilder;

  /// The builder called to build a child
  /// when the [future] hasn't finished yet.
  ///
  /// If not provided then a centered [VoicesCircularProgressIndicator]
  /// is used instead.
  final WidgetBuilder loaderBuilder;

  /// The minimum duration during which the loader state is shown.
  ///
  /// It is useful to delay a future which finishes in a split second
  /// as this results in jumpy UI, not giving the user enough time to see
  /// the loader state before data or error states are shown.
  ///
  /// Pass [Duration.zero] to disable it.
  final Duration minimumDelay;

  const VoicesFutureBuilder({
    super.key,
    required this.future,
    required this.dataBuilder,
    this.errorBuilder = _defaultErrorBuilder,
    this.loaderBuilder = _defaultLoaderBuilder,
    this.minimumDelay = const Duration(milliseconds: 300),
  });

  @override
  State<VoicesFutureBuilder> createState() => _VoicesFutureBuilderState<T>();
}

class _VoicesFutureBuilderState<T extends Object>
    extends State<VoicesFutureBuilder<T>> {
  Future<T>? _future;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    _future = _makeDelayedFuture();
  }

  @override
  void dispose() {
    _future = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(VoicesFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.future != oldWidget.future) {
      // ignore: discarded_futures
      _future = _makeDelayedFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder(context, snapshot.error, _onRetry);
        }

        final data = snapshot.data;
        if (data == null) {
          return widget.loaderBuilder(context);
        }

        return widget.dataBuilder(context, data, _onRetry);
      },
    );
  }

  void _onRetry() {
    setState(() {
      // ignore: discarded_futures
      _future = _makeDelayedFuture();
    });
  }

  Future<T> _makeDelayedFuture() async {
    return widget.future().withMinimumDelay(widget.minimumDelay);
  }
}

Widget _defaultErrorBuilder(
  BuildContext context,
  Object? error,
  VoidCallback onRetry,
) {
  return _Error(onRetry: onRetry);
}

Widget _defaultLoaderBuilder(BuildContext context) {
  return const _Loader();
}

class _Error extends StatelessWidget {
  final VoidCallback onRetry;

  const _Error({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return VoicesErrorIndicator(
      message: context.l10n.somethingWentWrong,
      onRetry: onRetry,
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Center(child: VoicesCircularProgressIndicator());
  }
}
