import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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

class _VoicesHttpsTextFieldState extends State<VoicesHttpsTextField> {
  TextEditingController? _controller;
  TextEditingController get _effectiveController {
    return widget.controller ?? (_controller ??= TextEditingController());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      controller: _effectiveController,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      decoration: VoicesTextFieldDecoration(
        hintText:
            widget.enabled ? context.l10n.noUrlAdded : context.l10n.addUrl,
        prefixIcon: VoicesAssets.icons.link.buildIcon(),
        showStatusSuffixIcon: widget.enabled,
        additionalSuffixIcons: _AdditionalSuffixIcons(
          enabled: widget.enabled,
          effectiveController: _effectiveController,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      readOnly: !widget.enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class _AdditionalSuffixIcons extends StatefulWidget {
  final bool enabled;
  final TextEditingController effectiveController;

  const _AdditionalSuffixIcons({
    required this.enabled,
    required this.effectiveController,
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
    widget.effectiveController.addListener(_changeClearButtonVisibility);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled && widget.effectiveController.text.isNotEmpty) {
      return VoicesIconButton(
        onTap: () async {
          await launchHrefUrl(widget.effectiveController.text.getUri());
        },
        child: VoicesAssets.icons.externalLink.buildIcon(),
      );
    }
    return Offstage(
      offstage: _offstageClearButton,
      child: TextButton(
        onPressed: widget.effectiveController.clear,
        child: Text(context.l10n.clear),
      ),
    );
  }

  void _changeClearButtonVisibility() {
    if (widget.enabled && widget.effectiveController.text.isNotEmpty) {
      setState(() {
        _offstageClearButton = false;
      });
    } else {
      setState(() {
        _offstageClearButton = true;
      });
    }
  }
}
