import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' as vm;
import 'package:flutter/material.dart';

const _uuidVersion = 7;

final class DocumentRefController extends ValueNotifier<DocumentRef?> {
  DocumentRefController([super.value]);
}

class DocumentRefField extends StatefulWidget {
  final DocumentRefController? controller;
  final ValueChanged<DocumentRef>? onChange;

  const DocumentRefField({
    super.key,
    this.controller,
    this.onChange,
  });

  @override
  State<DocumentRefField> createState() => _DocumentRefFieldState();
}

class _DocumentRefFieldState extends State<DocumentRefField> {
  DocumentRefController? _controller;
  late final TextEditingController _idController;
  late final TextEditingController _verController;
  late final ValueNotifier<bool> _isLocalController;

  vm.Uuid _id = const vm.Uuid.pure(version: _uuidVersion);
  vm.Uuid _ver = const vm.Uuid.pure(version: _uuidVersion);

  DocumentRefController get _effectiveController {
    return widget.controller ?? (_controller = DocumentRefController());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        _IdTextField(),
        _VerTextField(),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant DocumentRefField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(_onRefChanged);
      (widget.controller ?? _controller)?.addListener(_onRefChanged);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    _idController.dispose();
    _verController.dispose();
    _isLocalController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final controller = _effectiveController..addListener(_onRefChanged);
    final ref = controller.value;

    _id = vm.Uuid.pure(value: ref?.id ?? '', version: _uuidVersion);
    _ver = vm.Uuid.pure(value: ref?.version ?? '', version: _uuidVersion);

    _idController = TextEditingController(text: _id.value)..addListener(_syncParts);
    _verController = TextEditingController(text: _ver.value)..addListener(_syncParts);
    _isLocalController = ValueNotifier(ref is DraftRef)..addListener(_syncParts);
  }

  void _onRefChanged() {}

  void _syncParts() {
    final id = _idController.text;
    final ver = _verController.text;
    final isLocal = _isLocalController.value;
  }
}

class _IdTextField extends StatelessWidget {
  const _IdTextField();

  @override
  Widget build(BuildContext context) {
    return VoicesUuidTextField(
      onFieldSubmitted: (value) {
        //
      },
    );
  }
}

class _VerTextField extends StatelessWidget {
  const _VerTextField();

  @override
  Widget build(BuildContext context) {
    return VoicesUuidTextField(
      onFieldSubmitted: (value) {
        //
      },
    );
  }
}
