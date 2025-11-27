import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final class DocumentRefController extends ValueNotifier<DocumentRef?> {
  DocumentRefController([super.value]);
}

class DocumentRefField extends StatefulWidget {
  final DocumentRefController? controller;
  final ValueChanged<DocumentRef?>? onChange;
  final ValueChanged<DocumentRef?>? onSubmitted;

  const DocumentRefField({
    super.key,
    this.controller,
    this.onChange,
    this.onSubmitted,
  });

  @override
  State<DocumentRefField> createState() => _DocumentRefFieldState();
}

class _DocumentRefFieldState extends State<DocumentRefField> {
  DocumentRefController? _controller;
  late final TextEditingController _idController;
  late final TextEditingController _verController;
  late final ValueNotifier<bool> _isLocalController;

  Uuid _id = const Uuid.pure();
  Uuid _ver = const Uuid.pure(isEmptyAllowed: true);
  bool _isLocal = true;

  DocumentRefController get _effectiveController {
    return widget.controller ?? (_controller = DocumentRefController());
  }

  bool get _isValid => _id.isValid && _ver.isValid;

  DocumentRef? get _ref => _isValid
      ? DocumentRef.build(
          id: _id.value,
          ver: _ver.value.isNotEmpty ? _ver.value : null,
          isDraft: _isLocal,
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: _IdTextField(
                  controller: _idController,
                  error: _id.displayError,
                ),
              ),
              Expanded(
                child: _VerTextField(
                  controller: _verController,
                  error: _ver.displayError,
                  onSubmitted: (value) {
                    _syncRefWithParts(ver: value);
                    widget.onSubmitted?.call(_effectiveController.value);
                  },
                ),
              ),
            ],
          ),
          AffixDecorator(
            prefix: const Text('Is Local:'),
            child: VoicesSwitch(
              value: _isLocal,
              onChanged: (value) {
                _isLocalController.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DocumentRefField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(_onRefControllerChanged);
      (widget.controller ?? _controller)?.addListener(_onRefControllerChanged);

      _syncPartsWithRef(_effectiveController.value);
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

    final controller = _effectiveController..addListener(_onRefControllerChanged);
    final ref = controller.value;

    _id = Uuid.pure(value: ref?.id ?? '');
    _ver = Uuid.pure(value: ref?.ver ?? '', isEmptyAllowed: true);
    _isLocal = ref is DraftRef;

    _idController = TextEditingController(text: _id.value)..addListener(_onPartControllerChanged);
    _verController = TextEditingController(text: _ver.value)..addListener(_onPartControllerChanged);
    _isLocalController = ValueNotifier(_isLocal)..addListener(_onPartControllerChanged);
  }

  void _onPartControllerChanged() {
    setState(_syncRefWithParts);
  }

  void _onRefControllerChanged() {
    setState(() {
      _syncPartsWithRef(_effectiveController.value);
    });
  }

  void _syncPartsWithRef(DocumentRef? ref) {
    _id = Uuid.pure(value: ref?.id ?? '');
    _ver = Uuid.pure(value: ref?.ver ?? '', isEmptyAllowed: true);
    _isLocal = ref is DraftRef;

    _idController.removeListener(_onPartControllerChanged);
    _verController.removeListener(_onPartControllerChanged);
    _isLocalController.removeListener(_onPartControllerChanged);

    _idController.text = _id.value;
    _verController.text = _ver.value;
    _isLocalController.value = _isLocal;

    _idController.addListener(_onPartControllerChanged);
    _verController.addListener(_onPartControllerChanged);
    _isLocalController.addListener(_onPartControllerChanged);
  }

  void _syncRefWithParts({
    Uuid? id,
    Uuid? ver,
    bool? isLocal,
  }) {
    _id = id ??= Uuid.dirty(value: _idController.text);
    _ver = ver ??= Uuid.dirty(value: _verController.text, isEmptyAllowed: true);
    _isLocal = isLocal ??= _isLocalController.value;

    final ref = _ref;

    _effectiveController
      ..removeListener(_onRefControllerChanged)
      ..value = ref
      ..addListener(_onRefControllerChanged);
  }
}

class _IdTextField extends StatelessWidget {
  final LocalizedException? error;
  final TextEditingController controller;

  const _IdTextField({
    this.error,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesUuidTextField(
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: 'ID',
        hintText: 'UUID',
        errorText: error?.message(context),
      ),
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
}

class _VerTextField extends StatelessWidget {
  final LocalizedException? error;
  final TextEditingController controller;
  final ValueChanged<Uuid> onSubmitted;

  const _VerTextField({
    this.error,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesUuidTextField(
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: 'Ver',
        hintText: 'UUID',
        errorText: error?.message(context),
      ),
      onFieldSubmitted: (value) {
        onSubmitted(Uuid.dirty(value: value, isEmptyAllowed: true));
      },
    );
  }
}
