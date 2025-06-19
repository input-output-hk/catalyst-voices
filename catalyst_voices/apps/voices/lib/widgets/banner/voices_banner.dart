import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesBanner extends StatefulWidget {
  final VoicesBannerType type;
  final VoidCallback? onClose;
  final Widget child;

  const VoicesBanner({
    super.key,
    this.type = VoicesBannerType.info,
    this.onClose,
    required this.child,
  });

  @override
  State<VoicesBanner> createState() => _VoicesBannerState();
}

enum VoicesBannerType {
  info;

  const VoicesBannerType();

  SvgGenImage get icon {
    return switch (this) {
      VoicesBannerType.info => VoicesAssets.icons.informationCircle,
    };
  }

  Color color(BuildContext context) {
    return switch (this) {
      VoicesBannerType.info => context.colors.primaryContainer,
    };
  }
}

class _VoicesBannerState extends State<VoicesBanner> {
  bool _isClosed = false;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _isClosed,
      child: Container(
        color: widget.type.color(context),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AffixDecorator(
              prefix: widget.type.icon.buildIcon(size: 18),
              child: widget.child,
            ),
            GestureDetector(
              onTap: _onClose,
              child: VoicesAssets.icons.x.buildIcon(size: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _onClose() {
    setState(() {
      _isClosed = true;
    });
    _onClose.call();
  }
}
