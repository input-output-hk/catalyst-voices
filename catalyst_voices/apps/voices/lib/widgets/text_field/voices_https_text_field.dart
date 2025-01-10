import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesHttpsTextField extends StatefulWidget {
  final ValueChanged<String?>? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoicesTextFieldValidator? validator;
  final bool enabled;

  const VoicesHttpsTextField({
    super.key,
    this.onFieldSubmitted,
    this.focusNode,
    this.enabled = false,
    this.controller,
    this.validator,
  });

  @override
  State<VoicesHttpsTextField> createState() => _VoicesHttpsTextFieldState();
}

class _VoicesHttpsTextFieldState extends State<VoicesHttpsTextField>
    with LaunchUrlMixin {
  TextEditingController? _controller;
  TextEditingController get _effectiveController {
    return widget.controller ?? (_controller ??= TextEditingController());
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? null : _launchUrl,
      child: VoicesTextField(
        controller: _effectiveController,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        decoration: VoicesTextFieldDecoration(
          hintText:
              widget.enabled ? context.l10n.noUrlAdded : context.l10n.addUrl,
          prefixIcon: VoicesAssets.icons.link.buildIcon(),
          showStatusSuffixIcon: widget.enabled,
          suffixIcon: _AdditionalSuffixIcons(
            enabled: widget.enabled,
            controller: _effectiveController,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          fillColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
          filled: true,
        ),
        style: _getTextStyle(context),
        enabled: widget.enabled,
        readOnly: !widget.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    if (widget.enabled) {
      return textTheme.bodyLarge;
    }
    return textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );
  }

  Future<void> _launchUrl() async {
    if (_effectiveController.text.isEmpty) return;

    final url = Uri.tryParse(_effectiveController.text);
    if (url != null) {
      await launchHrefUrl(url);
    }
  }
}

class _AdditionalSuffixIcons extends StatefulWidget {
  final bool enabled;
  final TextEditingController controller;

  const _AdditionalSuffixIcons({
    required this.enabled,
    required this.controller,
  });

  @override
  State<_AdditionalSuffixIcons> createState() => _AdditionalSuffixIconsState();
}

class _AdditionalSuffixIconsState extends State<_AdditionalSuffixIcons>
    with LaunchUrlMixin {
  bool _offstageClearButton = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changeClearButtonVisibility);
  }

  @override
  void didUpdateWidget(covariant _AdditionalSuffixIcons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_changeClearButtonVisibility);
      widget.controller.addListener(_changeClearButtonVisibility);
      _changeClearButtonVisibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled && widget.controller.text.isNotEmpty) {
      return VoicesIconButton(
        onTap: () async {
          await launchHrefUrl(widget.controller.text.getUri());
        },
        child: VoicesAssets.icons.externalLink.buildIcon(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return Offstage(
      offstage: _offstageClearButton,
      child: TextButton(
        onPressed: widget.controller.clear,
        child: Text(context.l10n.clear),
      ),
    );
  }

  void _changeClearButtonVisibility() {
    setState(() {
      _offstageClearButton =
          widget.enabled && widget.controller.text.isNotEmpty;
    });
  }
}
