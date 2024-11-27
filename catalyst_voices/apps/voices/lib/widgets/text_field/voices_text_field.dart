import 'package:catalyst_voices/widgets/common/resizable_box_parent.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A replacement for [TextField] and [TextFormField]
/// that is pre-configured to use Project Catalyst theming.
///
/// Uses [OutlineInputBorder] instead of the default [UnderlineInputBorder] one.
class VoicesTextField extends StatefulWidget {
  /// [TextField.controller]
  final TextEditingController? controller;

  /// [TextField.focusNode]
  final FocusNode? focusNode;

  /// [TextField.decoration]
  final VoicesTextFieldDecoration? decoration;

  /// [TextField.keyboardType]
  final TextInputType? keyboardType;

  /// [TextField.textInputAction]
  final TextInputAction? textInputAction;

  /// [TextField.textCapitalization]
  final TextCapitalization textCapitalization;

  /// [TextField.style]
  final TextStyle? style;

  /// [TextField.autofocus]
  final bool autofocus;

  /// [TextField.obscureText]
  final bool obscureText;

  /// [TextField.maxLines].
  final int? maxLines;

  /// [TextField.minLines].
  final int? minLines;

  /// [TextField.maxLength].
  final int? maxLength;

  /// [TextField.enabled].
  final bool enabled;

  /// Whether the text field can be resized by the user
  /// in HTML's text area fashion.
  ///
  /// Defaults to true on web and desktop, false otherwise.
  final bool? resizable;

  /// [TextFormField.validator]
  final VoicesTextFieldValidator? validator;

  /// [TextField.onChanged]
  final ValueChanged<String>? onChanged;

  /// [TextField.onSubmitted]
  final ValueChanged<String>? onFieldSubmitted;

  /// [FormField.onSaved]
  final FormFieldSetter<String>? onSaved;

  /// [TextField.inputFormatters]
  final List<TextInputFormatter>? inputFormatters;

  const VoicesTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.autofocus = false,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.resizable,
    // Making it required but nullable because default behaviour is
    // to make some action when user taps enter. Focus next field or anything
    // else.
    required this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
  });

  @override
  State<VoicesTextField> createState() => _VoicesTextFieldState();
}

class _VoicesTextFieldState extends State<VoicesTextField> {
  TextEditingController? _customController;

  VoicesTextFieldValidationResult _validation =
      const VoicesTextFieldValidationResult(status: VoicesTextFieldStatus.none);

  @override
  void initState() {
    super.initState();
    _obtainController().addListener(_onChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _validate(_obtainController().text);
  }

  @override
  void didUpdateWidget(VoicesTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newController = _obtainController();

    // unregister listener from potentially old controllers
    _customController?.removeListener(_onChanged);
    oldWidget.controller?.removeListener(_onChanged);

    // the widget got controller from the parent, lets dispose our own
    if (widget.controller != null) {
      _customController?.dispose();
      _customController = null;
    }

    // register for a new one
    newController.addListener(_onChanged);

    if (oldWidget.decoration?.errorText != widget.decoration?.errorText ||
        oldWidget.validator != widget.validator ||
        oldWidget.controller?.text != newController.text) {
      _validate(newController.text);
    }
  }

  @override
  void dispose() {
    _customController?.dispose();
    _customController = null;
    widget.controller?.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final labelText = widget.decoration?.labelText ?? '';
    final resizable = _isResizable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: widget.enabled
                ? textTheme.titleSmall
                : textTheme.titleSmall!
                    .copyWith(color: theme.colors.textDisabled),
          ),
          const SizedBox(height: 4),
        ],
        ResizableBoxParent(
          resizableHorizontally: resizable,
          resizableVertically: resizable,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.top,
            autofocus: widget.autofocus,
            expands: resizable,
            controller: _obtainController(),
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              filled: widget.decoration?.filled,
              fillColor: widget.decoration?.fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: widget.decoration?.border ??
                  _getBorder(
                    orDefault: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
              enabledBorder: widget.decoration?.enabledBorder ??
                  _getBorder(
                    orDefault: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
              disabledBorder: widget.decoration?.disabledBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              errorBorder: widget.decoration?.errorBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: _getStatusColor(
                        orDefault: theme.colorScheme.error,
                      ),
                    ),
                  ),
              focusedBorder: widget.decoration?.focusedBorder ??
                  _getBorder(
                    orDefault: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              focusedErrorBorder: widget.decoration?.focusedErrorBorder ??
                  _getBorder(
                    orDefault: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              helperText: widget.decoration?.helperText,
              helperStyle: widget.enabled
                  ? textTheme.bodySmall
                  : textTheme.bodySmall!
                      .copyWith(color: theme.colors.textDisabled),
              hintText: widget.decoration?.hintText,
              hintStyle: widget.enabled
                  ? textTheme.bodyLarge
                  : textTheme.bodyLarge!
                      .copyWith(color: theme.colors.textDisabled),
              errorText:
                  widget.decoration?.errorText ?? _validation.errorMessage,
              errorMaxLines: widget.decoration?.errorMaxLines,
              errorStyle: widget.enabled
                  ? textTheme.bodySmall
                  : textTheme.bodySmall!
                      .copyWith(color: theme.colors.textDisabled),
              prefixIcon: _wrapIconIfExists(
                widget.decoration?.prefixIcon,
                const EdgeInsetsDirectional.only(start: 8, end: 4),
              ),
              prefixText: widget.decoration?.prefixText,
              suffixIcon: _wrapIconIfExists(
                widget.decoration?.suffixIcon ?? _getStatusSuffixWidget(),
                const EdgeInsetsDirectional.only(start: 4, end: 8),
              ),
              suffixText: widget.decoration?.suffixText,
              counterText: widget.decoration?.counterText,
              counterStyle: widget.enabled
                  ? textTheme.bodySmall
                  : textTheme.bodySmall!
                      .copyWith(color: theme.colors.textDisabled),
            ),
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style: widget.style,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }

  bool get _isResizable {
    final resizable = widget.resizable ??
        (CatalystPlatform.isWebDesktop || CatalystPlatform.isDesktop);

    // expands property is not supported if any of these are specified,
    // both must be null
    final hasNoLineConstraints =
        widget.maxLines == null && widget.minLines == null;

    return resizable && hasNoLineConstraints;
  }

  InputBorder _getBorder({required InputBorder orDefault}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return orDefault;
      case VoicesTextFieldStatus.success:
      case VoicesTextFieldStatus.warning:
      case VoicesTextFieldStatus.error:
        return OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: _getStatusColor(
              orDefault: Colors.transparent,
            ),
          ),
        );
    }
  }

  Widget? _getStatusSuffixWidget() {
    final showStatusIcon = widget.decoration?.showStatusSuffixIcon ?? true;
    if (!showStatusIcon) {
      return null;
    }

    return getStatusSuffixIcon(
      color: _getStatusColor(orDefault: Colors.transparent),
    );
  }

  Widget? getStatusSuffixIcon({required Color color}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return null;
      case VoicesTextFieldStatus.success:
        return VoicesAssets.icons.checkCircle.buildIcon(color: color);
      case VoicesTextFieldStatus.warning:
        // TODO(dtscalac): this is not the right icon, it should be outlined
        // & rounded, ask designers to provide it and update it
        return Icon(Icons.warning_outlined, color: color);
      case VoicesTextFieldStatus.error:
        return Icon(Icons.error_outline, color: color);
    }
  }

  Widget? _wrapIconIfExists(Widget? child, EdgeInsetsDirectional padding) {
    if (child == null) return null;

    return IconTheme(
      data: IconThemeData(
        size: 24,
        color: Theme.of(context).colors.iconsForeground,
      ),
      child: Padding(
        padding: padding,
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: child,
        ),
      ),
    );
  }

  Color _getStatusColor({required Color orDefault}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return orDefault;
      case VoicesTextFieldStatus.success:
        return Theme.of(context).colors.success!;
      case VoicesTextFieldStatus.warning:
        return Theme.of(context).colors.warning!;
      case VoicesTextFieldStatus.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  TextEditingController _obtainController() {
    final providedController = widget.controller;
    if (providedController != null) {
      return providedController;
    }

    var customController = _customController;
    if (customController == null) {
      customController = TextEditingController();
      _customController = customController;
    }

    return customController;
  }

  void _onChanged() {
    _validate(_obtainController().text);
  }

  void _validate(String value) {
    final errorText = widget.decoration?.errorText;
    if (errorText != null) {
      _onValidationResultChanged(
        VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.error,
          errorMessage: errorText,
        ),
      );
      return;
    }

    final result = widget.validator?.call(value);
    _onValidationResultChanged(
      result ??
          const VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.none,
          ),
    );
  }

  void _onValidationResultChanged(VoicesTextFieldValidationResult validation) {
    if (_validation != validation) {
      setState(() {
        _validation = validation;
      });
    }
  }
}

/// A callback called to validate the input of the [VoicesTextField].
///
/// This callback returns a [VoicesTextFieldValidationResult] which defines
/// both the message to be shown where the [VoicesTextFieldDecoration.errorText]
/// is traditionally shown and as well the status which might decorate
/// the text field with success checkmark or error icon depending on the status.
typedef VoicesTextFieldValidator = VoicesTextFieldValidationResult Function(
  String value,
);

/// The return value of the [VoicesTextField.validator].
class VoicesTextFieldValidationResult with EquatableMixin {
  /// The status of the validation.
  ///
  /// The validation can be either a success, a warning or an error.
  final VoicesTextFieldStatus status;

  /// The error message to be used in case of a [warning] or an [error].
  final String? errorMessage;

  const VoicesTextFieldValidationResult({
    required this.status,
    this.errorMessage,
  }) : assert(
          (status == VoicesTextFieldStatus.warning ||
                  status == VoicesTextFieldStatus.error) ||
              errorMessage == null,
          'errorMessage can be only used for warning or error status',
        );

  @override
  List<Object?> get props => [status, errorMessage];

  /// Returns a successful validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.validator] param:
  ///
  /// ```
  /// validator: VoicesTextFieldValidationResult.success,
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  static VoicesTextFieldValidator success() {
    return (_) => const VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.success,
        );
  }

  /// Returns a warning validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.validator] param:
  ///
  /// ```
  /// validator: VoicesTextFieldValidationResult.warning,
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  static VoicesTextFieldValidator warning([String? message]) {
    return (_) => VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.warning,
          errorMessage: message,
        );
  }

  /// Returns an error validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.validator] param:
  ///
  /// ```
  /// validator: VoicesTextFieldValidationResult.error,
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  static VoicesTextFieldValidator error([String? message]) {
    return (_) => VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.error,
          errorMessage: message,
        );
  }
}

/// Defines the appearance of the [VoicesTextField].
enum VoicesTextFieldStatus {
  /// The text field appears as usual.
  none,

  /// The text field represents a success,
  /// i.e. if the input text is successfully validated.
  success,

  /// The text field represents a warning,
  /// i.e. if the input text is validated with a warning.
  warning,

  /// The text field represents an error,
  /// i.e. if the input text is validated with an error.
  error,
}

/// A replacement for [InputDecoration] to only expose parameters
/// that are supported by [VoicesTextField].
class VoicesTextFieldDecoration {
  /// [InputDecoration.border].
  final InputBorder? border;

  /// [InputDecoration.enabledBorder].
  final InputBorder? enabledBorder;

  /// [InputDecoration.disabledBorder].
  final InputBorder? disabledBorder;

  /// [InputDecoration.errorBorder].
  final InputBorder? errorBorder;

  /// [InputDecoration.focusedBorder].
  final InputBorder? focusedBorder;

  /// [InputDecoration.focusedErrorBorder].
  final InputBorder? focusedErrorBorder;

  /// Similar to the [InputDecoration.labelText] but does not use
  /// the floating behavior and is instead above the text field instead.
  final String? labelText;

  /// [InputDecoration.helperText].
  final String? helperText;

  /// [InputDecoration.hintText].
  final String? hintText;

  /// [InputDecoration.errorText].
  final String? errorText;

  /// [InputDecoration.errorMaxLines].
  final int? errorMaxLines;

  /// [InputDecoration.prefixIcon].
  final Widget? prefixIcon;

  /// [InputDecoration.prefixText].
  final String? prefixText;

  /// [InputDecoration.suffixIcon].
  final Widget? suffixIcon;

  /// [InputDecoration.suffixText].
  final String? suffixText;

  /// [InputDecoration.counterText].
  final String? counterText;

  /// Whether the [VoicesTextField] will automatically
  /// add a status [suffixIcon] based on the results of the validation.
  final bool showStatusSuffixIcon;

  /// [InputDecoration.filled].
  final bool? filled;

  /// [InputDecoration.fillColor].
  final Color? fillColor;

  /// Creates a new text field decoration.
  const VoicesTextFieldDecoration({
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.labelText,
    this.helperText,
    this.hintText,
    this.errorText,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.counterText,
    this.showStatusSuffixIcon = true,
    this.filled = false,
    this.fillColor,
  });
}
