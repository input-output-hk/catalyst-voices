// ignore_for_file: prefer_asserts_with_message

import 'package:catalyst_voices/widgets/menu/voices_node_menu.dart';
import 'package:flutter/material.dart';

typedef ProposalControllerBuilder = ProposalController Function(Object id);

final class ProposalControllerStateData extends VoicesNodeMenuStateData {
  const ProposalControllerStateData({
    super.selectedItemId,
    super.isExpanded,
  });
}

/// Direct extension of [VoicesNodeMenuController].
/// Probably we'll need extend controller with additional fields.
final class ProposalController extends VoicesNodeMenuController {
  ProposalController(ProposalControllerStateData super._value);
}

/// Keeps together [ProposalControllerStateData] tied to ids.
class ProposalControllerScope extends StatefulWidget {
  final ProposalControllerBuilder builder;
  final Widget child;

  const ProposalControllerScope({
    super.key,
    required this.builder,
    required this.child,
  });

  /// The closes instance of [ProposalControllerScope]
  /// that encloses the given context, or null if none found.
  ///
  /// Uses [builder] with given [id] to build [ProposalController]
  /// if none already created for this [id].
  static ProposalController? maybeOf(
    BuildContext context, {
    required Object id,
  }) {
    return context
        .findAncestorStateOfType<_ProposalControllerScopeState>()
        ?._getSegmentController(id);
  }

  /// Wrapper on [maybeOf] but forcing null unwrapping.
  static ProposalController of(
    BuildContext context, {
    required Object id,
  }) {
    final controller = maybeOf(context, id: id);

    assert(
      controller != null,
      'Unable to find ProposalControllerScope as parent widget',
    );

    return controller!;
  }

  @override
  State<ProposalControllerScope> createState() {
    return _ProposalControllerScopeState();
  }
}

class _ProposalControllerScopeState extends State<ProposalControllerScope> {
  final _cache = <Object, ProposalController>{};

  bool _debugDisposed = false;

  static bool _debugAssertNotDisposed(
    _ProposalControllerScopeState screenState,
  ) {
    assert(() {
      if (screenState._debugDisposed) {
        throw FlutterError(
          'A ${screenState.runtimeType} was used after being disposed.\n'
          'Once you have called dispose() on a ${screenState.runtimeType}, it '
          'can no longer be used.',
        );
      }
      return true;
    }());
    return true;
  }

  @override
  void dispose() {
    assert(_debugAssertNotDisposed(this));
    assert(() {
      _debugDisposed = true;
      return true;
    }());

    final controllers = List.of(_cache.values);
    for (final controller in controllers) {
      controller.dispose();
    }
    _cache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  ProposalController _getSegmentController(Object segmentId) {
    _debugAssertNotDisposed(this);

    return _cache.putIfAbsent(
      segmentId,
      () => widget.builder(segmentId),
    );
  }
}
