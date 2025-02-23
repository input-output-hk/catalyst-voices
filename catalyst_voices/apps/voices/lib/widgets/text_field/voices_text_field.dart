import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/common/resizable_box_parent.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A callback called to validate the input of the [VoicesTextField].
///
/// This callback returns a [VoicesTextFieldValidationResult] which defines
/// both the message to be shown where the [VoicesTextFieldDecoration.errorText]
/// is traditionally shown and as well the status which might decorate
/// the text field with success checkmark or error icon depending on the status.
typedef VoicesTextFieldValidator = VoicesTextFieldValidationResult Function(
  String value,
);

/// A replacement for [TextField] and [TextFormField]
/// that is pre-configured to use Project Catalyst theming.
///
/// Uses [OutlineInputBorder] instead of the default [UnderlineInputBorder] one.
class VoicesTextField extends VoicesFormField<String> {
  final String? initialText;

  /// [TextField.controller]
  final TextEditingController? controller;

  /// [TextField.statesController]
  final WidgetStatesController? statesController;

  /// [TextField.focusNode]
  final FocusNode? focusNode;

  /// [TextField.decoration]
  final VoicesTextFieldDecoration? decoration;

  /// [VoicesTextField.autofocus].
  final bool autofocus;

  /// [TextField.keyboardType]
  final TextInputType? keyboardType;

  /// [TextField.textInputAction]
  final TextInputAction? textInputAction;

  /// [TextField.textCapitalization]
  final TextCapitalization textCapitalization;

  /// [TextField.style]
  final TextStyle? style;

  /// [TextField.obscureText]
  final bool obscureText;

  /// [TextField.maxLines].
  final int? maxLines;

  /// [TextField.minLines].
  final int? minLines;

  /// [TextField.maxLength].
  final int? maxLength;

  /// [TextField.readOnly].
  final bool readOnly;

  /// [TextField.ignorePointers].
  final bool? ignorePointers;

  /// Whether the text field can be resized by the user
  /// in HTML's text area fashion.
  ///
  /// Defaults to true on web and desktop, false otherwise.
  final bool? resizableVertically;

  /// Whether the text field can be resized by the user
  /// in HTML's text area fashion.
  ///
  /// Defaults to false on all platforms.
  final bool resizableHorizontally;

  /// A replacement for [TextFormField.validator]
  final VoicesTextFieldValidator? textValidator;

  /// [TextField.onSubmitted]
  final ValueChanged<String>? onFieldSubmitted;

  /// [TextField.onEditingComplete]
  final VoidCallback? onEditingComplete;

  /// [TextField.inputFormatters]
  final List<TextInputFormatter>? inputFormatters;

  /// [TextField.maxLengthEnforcement]
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// [TextField.mouseCursor]
  final MouseCursor? mouseCursor;

  VoicesTextField({
    super.key,
    super.enabled = true,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.onChanged,
    this.initialText,
    this.controller,
    this.statesController,
    this.focusNode,
    this.decoration,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.ignorePointers,
    this.textValidator,
    this.resizableVertically,
    this.resizableHorizontally = false,
    // Making it required but nullable because default behaviour is
    // to make some action when user taps enter. Focus next field or anything
    // else.
    required this.onFieldSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.maxLengthEnforcement,
    this.mouseCursor,
  }) : super(
          value: controller?.text ?? initialText,
          validator: (value) {
            final errorText = decoration?.errorText;
            if (errorText != null) {
              return errorText;
            } else {
              final result = textValidator?.call(value ?? '');
              return result?.errorMessage;
            }
          },
          builder: (field) {
            final context = field.context;
            final state = field as VoicesTextFieldState;
            final theme = Theme.of(context);
            final textTheme = theme.textTheme;

            final labelText = decoration?.labelText ?? '';
            final resizableVertically = state._isResizableVertically;
            final resizableHorizontally = state._isResizableHorizontally;

            void onChangedHandler(String? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelText.isNotEmpty) ...[
                  Text(
                    labelText,
                    style: enabled
                        ? textTheme.titleSmall
                        : textTheme.titleSmall!
                            .copyWith(color: theme.colors.textDisabled),
                  ),
                  const SizedBox(height: 4),
                ],
                ResizableBoxParent(
                  resizableHorizontally: resizableHorizontally,
                  resizableVertically: resizableVertically,
                  minHeight: maxLines == null ? 65 : 48,
                  iconBottomSpacing: maxLines == null ? 18 : 0,
                  child: TextField(
                    key: const Key('VoicesTextField'),
                    textAlignVertical: TextAlignVertical.top,
                    autofocus: autofocus,
                    expands: resizableVertically,
                    controller: state._obtainController(),
                    statesController: statesController,
                    focusNode: focusNode,
                    onSubmitted: onFieldSubmitted,
                    onEditingComplete: onEditingComplete,
                    inputFormatters: inputFormatters,
                    decoration: state._buildDecoration(),
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    textCapitalization: textCapitalization,
                    style: style,
                    obscureText: obscureText,
                    maxLines: maxLines,
                    minLines: minLines,
                    maxLength: maxLength,
                    maxLengthEnforcement: maxLengthEnforcement,
                    enabled: enabled,
                    readOnly: readOnly,
                    ignorePointers: ignorePointers,
                    onChanged: onChangedHandler,
                    mouseCursor: mouseCursor,
                  ),
                ),
              ],
            );
          },
        );

  @override
  VoicesFormFieldState<String> createState() => VoicesTextFieldState();
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

  /// [InputDecoration.helper].
  final Widget? helper;

  /// [InputDecoration.helperText].
  final String? helperText;

  /// [InputDecoration.hintText].
  final String? hintText;

  /// [InputDecoration.hintStyle].
  final TextStyle? hintStyle;

  /// [InputDecoration.errorText].
  final String? errorText;

  /// [InputDecoration.errorStyle]
  final TextStyle? errorStyle;

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

  /// The border radius for all borders of the text field.
  /// If not specified, no radius will be applied.
  final BorderRadius? borderRadius;

  /// Creates a new text field decoration.
  const VoicesTextFieldDecoration({
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.labelText,
    this.helper,
    this.helperText,
    this.hintText,
    this.hintStyle,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.counterText,
    this.showStatusSuffixIcon = true,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
  });
}

class VoicesTextFieldState extends VoicesFormFieldState<String> {
  TextEditingController? _customController;

  VoicesTextFieldValidationResult _validation =
      const VoicesTextFieldValidationResult.none();

  @override
  VoicesTextField get widget => super.widget as VoicesTextField;

  bool get _isResizableByDefault {
    return CatalystPlatform.isWebDesktop || CatalystPlatform.isDesktop;
  }

  bool get _isResizableHorizontally {
    return widget.resizableHorizontally;
  }

  bool get _isResizableVertically {
    final resizable = widget.resizableVertically ?? _isResizableByDefault;

    // expands property is not supported if any of these are specified,
    // both must be null
    final hasNoLineConstraints =
        widget.maxLines == null && widget.minLines == null;

    return resizable && hasNoLineConstraints;
  }

  @override
  Widget build(BuildContext context) {
    // Validating in build(), similar workaround is done in the
    // original FormField build method to make sure validation
    // errors are shown when needed.
    if (widget.enabled) {
      _validateIfValidationModeAllows(_obtainController().text);
    }

    return super.build(context);
  }

  /// Clears the text field.
  void clear() {
    didChange(null);
    widget.onChanged?.call(null);
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    final controller = _obtainController();
    if (controller.text != value) {
      controller.textWithSelection = value ?? '';
    }
  }

  @override
  void didUpdateWidget(VoicesTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newController = _obtainController();

    // unregister listener from potentially old controllers
    _customController?.removeListener(_handleControllerChanged);
    oldWidget.controller?.removeListener(_handleControllerChanged);

    // the widget got controller from the parent, lets dispose our own
    if (widget.controller != null) {
      _customController?.dispose();
      _customController = null;
    }

    // register for a new one
    newController.addListener(_handleControllerChanged);

    if (oldWidget.controller?.text != newController.text) {
      setValue(newController.text);
    }
  }

  @override
  void dispose() {
    _customController?.dispose();
    _customController = null;
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  Widget? getStatusSuffixIcon({required Color color}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return null;
      case VoicesTextFieldStatus.success:
        return VoicesAssets.icons.checkCircle.buildIcon(
          color: color,
          fit: BoxFit.scaleDown,
        );
      case VoicesTextFieldStatus.warning:
        // TODO(dtscalac): this is not the right icon, it should be outlined
        // & rounded, ask designers to provide it and update it
        return Icon(Icons.warning_outlined, color: color);
      case VoicesTextFieldStatus.error:
        return Icon(Icons.error_outline, color: color);
    }
  }

  @override
  void initState() {
    super.initState();

    final text = widget.initialText ?? widget.controller?.text ?? '';
    setValue(text);

    _obtainController()
      ..textWithSelection = text
      ..addListener(_handleControllerChanged);
  }

  @override
  void reset() {
    // Set the controller value before calling super.reset() to let
    // _handleControllerChanged suppress the change.
    _validation = const VoicesTextFieldValidationResult.none();
    _obtainController().text = widget.initialValue ?? '';
    super.reset();
    widget.onChanged?.call(_obtainController().text);
  }

  @override
  bool validate() {
    // Not calling setState() from here, the super.validate() does it.
    _validate(_obtainController().text);

    return super.validate();
  }

  InputDecoration _buildDecoration() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;
    final colorScheme = theme.colorScheme;
    final borderRadius = widget.decoration?.borderRadius;

    return InputDecoration(
      filled: widget.decoration?.filled,
      fillColor: widget.decoration?.fillColor,
      // Note. prefixText is not visible when field is not focused without
      // this.
      // Should be removed once this is resolved
      // https://github.com/flutter/flutter/issues/64552#issuecomment-2074034179
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: widget.decoration?.border ??
          _getBorder(
            orDefault: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
      enabledBorder: widget.decoration?.enabledBorder ??
          _getBorder(
            orDefault: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
      disabledBorder: widget.decoration?.disabledBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(
              color: colorScheme.outline,
            ),
          ),
      errorBorder: widget.decoration?.errorBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
            borderSide: BorderSide(
              width: 2,
              color: _getStatusColor(
                orDefault: colorScheme.error,
              ),
            ),
          ),
      focusedBorder: widget.decoration?.focusedBorder ??
          _getBorder(
            orDefault: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(
                width: 2,
                color: colorScheme.primary,
              ),
            ),
          ),
      focusedErrorBorder: widget.decoration?.focusedErrorBorder ??
          _getBorder(
            orDefault: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(
                width: 2,
                color: colorScheme.error,
              ),
            ),
          ),
      helper: widget.decoration?.helper != null
          ? DefaultTextStyle(
              style: widget.enabled
                  ? textTheme.bodySmall!
                  : textTheme.bodySmall!.copyWith(color: colors.textDisabled),
              child: widget.decoration!.helper!,
            )
          : null,
      helperText: widget.decoration?.helperText,
      helperStyle: widget.enabled
          ? textTheme.bodySmall
          : textTheme.bodySmall!.copyWith(color: colors.textDisabled),
      hintText: widget.decoration?.hintText,
      hintStyle: _getHintStyle(
        textTheme,
        theme,
        orDefault: textTheme.bodyLarge!.copyWith(color: colors.textDisabled),
      ),
      errorText: widget.decoration?.errorText ?? _validation.errorMessage,
      errorMaxLines: widget.decoration?.errorMaxLines,
      errorStyle: _getErrorStyle(textTheme, theme),
      prefixIcon: _wrapIconIfExists(
        widget.decoration?.prefixIcon,
        const EdgeInsetsDirectional.only(start: 8, end: 4),
      ),
      prefixText: widget.decoration?.prefixText,
      prefixStyle: WidgetStateTextStyle.resolveWith((states) {
        var textStyle = textTheme.bodyLarge ?? const TextStyle();

        if (!states.contains(WidgetState.focused) &&
            _obtainController().text.isEmpty) {
          textStyle = textStyle.copyWith(color: colors.textDisabled);
        }

        return textStyle;
      }),
      suffixIcon: _wrapSuffixIfExists(
        widget.decoration?.suffixIcon,
        const EdgeInsetsDirectional.only(start: 4, end: 8),
      ),
      suffixText: widget.decoration?.suffixText,
      counterText: widget.decoration?.counterText,
      counterStyle: widget.enabled
          ? textTheme.bodySmall
          : textTheme.bodySmall!.copyWith(color: colors.textDisabled),
    );
  }

  InputBorder _getBorder({required InputBorder orDefault}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return orDefault;
      case VoicesTextFieldStatus.success:
      case VoicesTextFieldStatus.warning:
      case VoicesTextFieldStatus.error:
        return OutlineInputBorder(
          borderRadius: widget.decoration?.borderRadius ?? BorderRadius.zero,
          borderSide: BorderSide(
            width: 2,
            color: _getStatusColor(
              orDefault: Colors.transparent,
            ),
          ),
        );
    }
  }

  TextStyle? _getErrorStyle(TextTheme textTheme, ThemeData theme) {
    if (widget.decoration?.errorStyle != null) {
      return widget.decoration?.errorStyle;
    }

    return widget.enabled
        ? textTheme.bodySmall!.copyWith(color: theme.colorScheme.error)
        : textTheme.bodySmall!.copyWith(color: theme.colors.textDisabled);
  }

  TextStyle? _getHintStyle(
    TextTheme textTheme,
    ThemeData theme, {
    TextStyle? orDefault,
  }) =>
      widget.decoration?.hintStyle ?? orDefault;

  Color _getStatusColor({required Color orDefault}) {
    switch (_validation.status) {
      case VoicesTextFieldStatus.none:
        return orDefault;
      case VoicesTextFieldStatus.success:
        return Theme.of(context).colors.success;
      case VoicesTextFieldStatus.warning:
        return Theme.of(context).colors.warning;
      case VoicesTextFieldStatus.error:
        return widget.enabled
            ? Theme.of(context).colorScheme.error
            : Colors.transparent;
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

  void _handleControllerChanged() {
    final text = _obtainController().text;
    if (value != text) {
      setValue(text);
    }
  }

  TextEditingController _obtainController() {
    final providedController = widget.controller;
    if (providedController != null) {
      return providedController;
    }

    var customController = _customController;
    if (customController == null) {
      final textValue =
          TextEditingValueExt.collapsedAtEndOf(widget.initialText ?? '');

      customController = TextEditingController.fromValue(textValue);
      _customController = customController;
    }

    return customController;
  }

  void _validate(String? value) {
    final result = widget.textValidator?.call(value ?? '');
    _validation = result ?? const VoicesTextFieldValidationResult.none();
  }

  void _validateIfValidationModeAllows(String? value) {
    switch (widget.autovalidateMode) {
      case AutovalidateMode.disabled:
      case AutovalidateMode.onUnfocus:
        _validation = const VoicesTextFieldValidationResult.none();
      case AutovalidateMode.always:
        _validate(value);
      case AutovalidateMode.onUserInteraction:
        if (hasInteractedByUser) {
          _validate(value);
        }
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

  Widget? _wrapSuffixIfExists(Widget? child, EdgeInsetsDirectional padding) {
    final statusSuffixWidget = _getStatusSuffixWidget();
    if (child == null) {
      return statusSuffixWidget;
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              size: 24,
              color: Theme.of(context).colors.iconsForeground,
            ),
            child: Align(
              widthFactor: 1,
              heightFactor: 1,
              child: child,
            ),
          ),
          if (statusSuffixWidget != null) ...[
            const SizedBox(width: 2),
            statusSuffixWidget,
          ],
        ],
      ),
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

/// The return value of the [VoicesTextField.textValidator].
class VoicesTextFieldValidationResult with EquatableMixin {
  /// The status of the validation.
  ///
  /// The validation can be either a success, a warning or an error.
  final VoicesTextFieldStatus status;

  /// The error message to be used in case of a [VoicesTextFieldStatus.warning]
  /// or an [VoicesTextFieldStatus.error].
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

  /// Returns an error validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.textValidator] param:
  ///
  /// ```
  ///   validator: (value) {
  ///       return const VoicesTextFieldValidationResult.error();
  ///   },
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  const VoicesTextFieldValidationResult.error([String? message])
      : this(
          status: VoicesTextFieldStatus.error,
          errorMessage: message,
        );

  const VoicesTextFieldValidationResult.none()
      : this(
          status: VoicesTextFieldStatus.none,
        );

  /// Returns a successful validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.textValidator] param:
  ///
  /// ```
  ///   validator: (value) {
  ///       return const VoicesTextFieldValidationResult.success();
  ///   },
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  const VoicesTextFieldValidationResult.success()
      : this(
          status: VoicesTextFieldStatus.success,
        );

  /// Returns a warning validation result.
  ///
  /// The method was designed to be used as
  /// [VoicesTextField.textValidator] param:
  ///
  /// ```
  ///   validator: (value) {
  ///       return const VoicesTextFieldValidationResult.warning();
  ///   },
  /// ```
  ///
  /// in cases where the text field state is known in advance
  /// and dynamic validation is not needed.
  const VoicesTextFieldValidationResult.warning([String? message])
      : this(
          status: VoicesTextFieldStatus.warning,
          errorMessage: message,
        );

  @override
  List<Object?> get props => [status, errorMessage];
}
