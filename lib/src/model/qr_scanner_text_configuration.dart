// import 'package:flutter/material.dart';
part of dynamic_multi_step_form;

/// QrScannerTextFieldConfiguration model
class QrScannerTextFieldConfiguration {
  /// The shape of the border to draw around the decoration's container.
  ///
  /// If [border] is a [WidgetStateUnderlineInputBorder]
  /// or [WidgetStateOutlineInputBorder], then the effective border can depend on
  /// the [WidgetState.focused] state, i.e. if the [TextField] is focused or not.
  ///
  /// If [border] derives from [InputBorder] the border's [InputBorder.borderSide],
  /// i.e. the border's color and width, will be overridden to reflect the input
  /// decorator's state. Only the border's shape is used. If custom  [BorderSide]
  /// values are desired for  a given state, all four borders – [errorBorder],
  /// [focusedBorder], [enabledBorder], [disabledBorder] – must be set.
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [InputDecoration.icon] and above the widgets that contain
  /// [InputDecoration.helperText], [InputDecoration.errorText], and
  /// [InputDecoration.counterText].
  ///
  /// The border's bounds, i.e. the value of `border.getOuterPath()`, define
  /// the area to be filled.
  ///
  /// This property is only used when the appropriate one of [errorBorder],
  /// [focusedBorder], [focusedErrorBorder], [disabledBorder], or [enabledBorder]
  /// is not specified. This border's [InputBorder.borderSide] property is
  /// configured by the InputDecorator, depending on the values of
  /// [InputDecoration.errorText], [InputDecoration.enabled],
  /// [InputDecorator.isFocused] and the current [Theme].
  ///
  /// Typically one of [UnderlineInputBorder] or [OutlineInputBorder].
  /// If null, InputDecorator's default is `const UnderlineInputBorder()`.
  ///
  /// See also:
  ///
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [UnderlineInputBorder], which draws a horizontal line at the
  ///    bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  late InputBorder? _border = const OutlineInputBorder();
  late InputBorder? _focusedBorder = const OutlineInputBorder();
  late TextStyle? _textStyle = const TextStyle();
  late TextStyle? _hintStyle = const TextStyle();
  late TextStyle? _labelStyle = const TextStyle();
  late TextStyle? _errorStyle = const TextStyle();
  late TextStyle? _prefixStyle = const TextStyle();
  late TextStyle? _counterStyle = const TextStyle();
  late TextStyle? _suffixStyle = const TextStyle();
  late String _suffixText = '';
  late Widget _prefix = Container();
  late Widget? _suffixScannerIcon = Icon(
    Icons.document_scanner_sharp,
    color: Colors.red,
    size: 25,
  );
  late EdgeInsets _padding = const EdgeInsets.only(left: 5, bottom: 5);
  late bool _enableLabel = true;
  late bool _filled = true;
  late Color _fillColor = Colors.transparent;
  late Color _cursorColor = Colors.red;
  late Color _suffixIconColor = Colors.red;
  late EdgeInsets _contentPadding = const EdgeInsets.all(12);
  late FloatingLabelBehavior _floatingLabelBehavior =
      FloatingLabelBehavior.never;

  QrScannerTextFieldConfiguration({
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    TextStyle? prefixStyle,
    TextStyle? counterStyle,
    TextStyle? suffixStyle,
    String? suffixText,
    // String? prefixText,
    InputBorder? border,
    InputBorder? focusedBorder,
    bool? enableLabel,
    bool? filled,
    Color? fillColor,
    Color? suffixIconColor,
    Color? cursorColor,
    Widget? prefix,
    Widget? suffixScannerIcon,
    EdgeInsets? contentPadding,
    EdgeInsets? padding,
    FloatingLabelBehavior? floatingLabelBehavior,
  }) {
    _fillColor = fillColor ?? _fillColor;
    _cursorColor = cursorColor ?? _cursorColor;
    _suffixIconColor = suffixIconColor ?? _suffixIconColor;
    _filled = filled ?? _filled;
    _prefix = prefix ?? _prefix;
    _suffixScannerIcon = suffixScannerIcon ?? _suffixScannerIcon;
    _suffixText = suffixText ?? _suffixText;
    //_prefixText = prefixText ?? _prefixText;
    _enableLabel = enableLabel ?? _enableLabel;
    _hintStyle = hintStyle ?? _hintStyle;
    _textStyle = textStyle ?? _textStyle;
    _labelStyle = labelStyle ?? _labelStyle;
    _errorStyle = errorStyle ?? _errorStyle;
    _prefixStyle = prefixStyle ?? _prefixStyle;
    _counterStyle = counterStyle ?? _counterStyle;
    _suffixStyle = suffixStyle ?? _suffixStyle;
    _border = border ?? _border;
    _focusedBorder = focusedBorder ?? _focusedBorder;
    _contentPadding = contentPadding ?? _contentPadding;
    _padding = padding ?? _padding;
    _floatingLabelBehavior = floatingLabelBehavior ?? _floatingLabelBehavior;
  }

  QrScannerTextFieldConfiguration setConfiguration({
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    TextStyle? prefixStyle,
    TextStyle? counterStyle,
    TextStyle? suffixStyle,
    //  String? prefixText,
    InputBorder? border,
    InputBorder? focusedBorder,
    bool? enableLabel,
    bool? filled,
    Color? fillColor,
    Color? cursorColor,
    Color? suffixIconColor,
    Widget? prefix,
    Widget? suffixScannerIcon,
    EdgeInsets? contentPadding,
    EdgeInsets? padding,
    FloatingLabelBehavior? floatingLabelBehavior,
  }) {
    return QrScannerTextFieldConfiguration(
        textStyle: textStyle ?? _textStyle,
        hintStyle: hintStyle ?? _hintStyle,
        labelStyle: labelStyle ?? _labelStyle,
        prefixStyle: prefixStyle ?? _prefixStyle,
        errorStyle: errorStyle ?? _errorStyle,
        counterStyle: counterStyle ?? _counterStyle,
        suffixStyle: suffixStyle ?? _suffixStyle,
        prefix: prefix ?? _prefix,
        suffixScannerIcon: suffixScannerIcon ?? _suffixScannerIcon,
        border: border ?? _border,
        //prefixText : prefixText ?? _prefixText,
        padding: padding ?? _padding,
        focusedBorder: focusedBorder ?? _focusedBorder,
        fillColor: fillColor ?? _fillColor,
        suffixIconColor: suffixIconColor ?? _suffixIconColor,
        cursorColor: cursorColor ?? _cursorColor,
        filled: filled ?? _filled,
        enableLabel: enableLabel ?? _enableLabel,
        contentPadding: contentPadding ?? _contentPadding,
        floatingLabelBehavior: floatingLabelBehavior ?? _floatingLabelBehavior);
  }

  set setSuffixScannerIcon(value) {
    _suffixScannerIcon = value;
  }

  set setBorder(value) {
    _border = value;
  }

  set setTextStyle(value) {
    _textStyle = value;
  }

  set setHintStyle(value) {
    _hintStyle = value;
  }

  set setEnableLabel(value) {
    _enableLabel = value;
  }
}

QrScannerTextFieldConfiguration qrScannerTextFieldConfiguration =
    QrScannerTextFieldConfiguration();
