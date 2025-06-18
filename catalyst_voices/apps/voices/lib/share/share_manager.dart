import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/widgets.dart';

class DefaultShareManager extends StatelessWidget {
  final Widget child;

  const DefaultShareManager({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _ShareManagerScope(
      manager: Dependencies.instance.get<ShareManager>(),
      child: child,
    );
  }
}

final class DelegatingShareManager implements ShareManager {
  final ShareService delegate;

  const DelegatingShareManager(this.delegate);

  @override
  Uri becomeReviewer() => delegate.becomeReviewer();

  @override
  Uri resolveProposalUrl({required DocumentRef ref}) => delegate.resolveProposalUrl(ref: ref);

  @override
  Future<void> share(ShareData data, {required ShareChannel channel}) {
    return delegate.share(data, channel: channel);
  }
}

abstract interface class ShareManager implements ShareService {
  const factory ShareManager(ShareService delegate) = DelegatingShareManager;

  static ShareManager? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ShareManagerScope>()?._shareManager;
  }

  static ShareManager of(BuildContext context) {
    final manager = maybeOf(context);
    assert(
      manager != null,
      'Default ShareManger was not found. '
      'Make sure to add DelegatingShareManager in widget tree',
    );
    return manager!;
  }
}

class _ShareManagerScope extends InheritedWidget {
  final ShareManager _shareManager;

  const _ShareManagerScope({
    required ShareManager manager,
    required super.child,
  }) : _shareManager = manager;

  @override
  bool updateShouldNotify(covariant _ShareManagerScope oldWidget) {
    return _shareManager != oldWidget._shareManager;
  }
}
