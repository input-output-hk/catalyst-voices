import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesHttpsTextField extends StatefulWidget {
  final ValueChanged<String?>? onFieldSubmitted;
  final TextEditingController? controller;
  final VoicesTextFieldValidator? validator;
  final bool readOnly;
  const VoicesHttpsTextField({
    super.key,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.controller,
    this.validator,
  });

  @override
  State<VoicesHttpsTextField> createState() => _VoicesHttpsTextFieldState();
}

class _VoicesHttpsTextFieldState extends State<VoicesHttpsTextField> {
  late final TextEditingController _textEditingController;

  TextEditingController? _controller;
  TextEditingController get _effectiveController {
    return widget.controller ?? (_controller ??= TextEditingController());
  }

  bool _offstageClearButton = true;

  @override
  void initState() {
    super.initState();

    _effectiveController.addListener(_changeClearButtonVisibility);
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onFieldSubmitted = widget.onFieldSubmitted;
    return VoicesTextField(
      controller: _effectiveController,
      onFieldSubmitted: onFieldSubmitted,
      validator: widget.validator,
      decoration: VoicesTextFieldDecoration(
        hintText: widget.readOnly ? 'No URL added' : 'Add URL',
        prefixIcon: VoicesAssets.icons.link.buildIcon(),
        showStatusSuffixIcon: !widget.readOnly,
        additionalSuffixIcons: Offstage(
          offstage: _offstageClearButton,
          child: TextButton(
            onPressed: () => _effectiveController.clear(),
            child: const Text('Clear'),
          ),
        ),
      ),
      readOnly: widget.readOnly,
      enabled: !widget.readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  void _changeClearButtonVisibility() {
    if (!widget.readOnly && _effectiveController.text.isNotEmpty) {
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
