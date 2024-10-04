// ignore_for_file: prefer_asserts_with_message

import 'package:catalyst_voices/widgets/menu/voices_node_menu.dart';
import 'package:flutter/material.dart';

typedef CampaignControllerBuilder = CampaignController Function(Object id);

final class CampaignControllerStateData extends VoicesNodeMenuStateData {
  const CampaignControllerStateData({
    super.selectedItemId,
    super.isExpanded,
  });
}

/// Direct extension of [VoicesNodeMenuController].
/// Probably we'll need extend controller with additional fields.
final class CampaignController extends VoicesNodeMenuController {
  CampaignController(CampaignControllerStateData super._value);
}

/// Keeps together [CampaignControllerStateData] tied to ids.
class CampaignControllerScope extends StatefulWidget {
  final CampaignControllerBuilder builder;
  final Widget child;

  const CampaignControllerScope({
    super.key,
    required this.builder,
    required this.child,
  });

  /// The closes instance of [CampaignControllerScope]
  /// that encloses the given context, or null if none found.
  ///
  /// Uses [builder] with given [id] to build [CampaignController]
  /// if none already created for this [id].
  static CampaignController? maybeOf(
    BuildContext context, {
    required Object id,
  }) {
    return context
        .findAncestorStateOfType<_CampaignControllerScopeState>()
        ?._getSegmentController(id);
  }

  /// Wrapper on [maybeOf] but forcing null unwrapping.
  static CampaignController of(
    BuildContext context, {
    required Object id,
  }) {
    final controller = maybeOf(context, id: id);

    assert(
      controller != null,
      'Unable to find CampaignControllerScope as parent widget',
    );

    return controller!;
  }

  @override
  State<CampaignControllerScope> createState() {
    return _CampaignControllerScopeState();
  }
}

class _CampaignControllerScopeState extends State<CampaignControllerScope> {
  final _cache = <Object, CampaignController>{};

  bool _debugDisposed = false;

  static bool _debugAssertNotDisposed(
    _CampaignControllerScopeState screenState,
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

  CampaignController _getSegmentController(Object segmentId) {
    _debugAssertNotDisposed(this);

    return _cache.putIfAbsent(
      segmentId,
      () => widget.builder(segmentId),
    );
  }
}
