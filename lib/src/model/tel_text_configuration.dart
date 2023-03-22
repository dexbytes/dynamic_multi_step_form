// import 'package:flutter/material.dart';
part of dynamic_json_form;

class TelTextFieldConfiguration {
  /// The shape of the border to draw around the decoration's container.
  ///
  /// If [border] is a [MaterialStateUnderlineInputBorder]
  /// or [MaterialStateOutlineInputBorder], then the effective border can depend on
  /// the [MaterialState.focused] state, i.e. if the [TextField] is focused or not.
  ///
  /// If [border] derives from [InputBorder] the border's [InputBorder.borderSide],
  /// i.e. the border's color and width, will be overridden to reflect the input
  /// decorator's state. Only the border's shape is used. If custom  [BorderSide]
  /// values are desired for  a given state, all four borders – [errorBorder],
  /// [focusedBorder], [enabledBorder], [disabledBorder] – must be set.
  ///
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
  late InputBorder? _border =  const OutlineInputBorder();
  late InputBorder? _focusedBorder =  const OutlineInputBorder();
  //late InputBorder? _errorBorder =  const OutlineInputBorder();
  late TextStyle? _textStyle =  const TextStyle();
  late TextStyle? _hintStyle =  const TextStyle();
  late TextStyle? _labelStyle =  const TextStyle();
  late TextStyle? _errorStyle =  const TextStyle();
  late TextStyle? _prefixStyle =  const TextStyle();
  late TextStyle? _counterStyle =  const TextStyle();
  late TextStyle? _suffixStyle =  const TextStyle();
  late StrutStyle? _strutStyle =  const StrutStyle();
  late TextDirection? _textDirection = TextDirection.ltr;
  late TextAlign? _textAlign = TextAlign.start;
  late TextAlignVertical? _textAlignVertical = TextAlignVertical.center;
  late bool _enableLabel = true;
  late bool _filled = true;
  late Color _fillColor = Colors.transparent;
  late Color _cursorColor = Colors.red;
  late Color _suffixIconColor = Colors.red;
  late EdgeInsets _contentPadding =  const EdgeInsets.all(16);
  late FloatingLabelBehavior _floatingLabelBehavior = FloatingLabelBehavior.never;


  TelTextFieldConfiguration({TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    TextStyle? prefixStyle,
    TextStyle? counterStyle,
    TextStyle? suffixStyle,
    InputBorder? border,
    InputBorder? focusedBorder,
    bool? enableLabel,
    bool? filled,
    Color? fillColor,
    Color? suffixIconColor,
    Color? cursorColor,
    EdgeInsets? contentPadding,
    FloatingLabelBehavior? floatingLabelBehavior,

  }) {
    _fillColor = fillColor ?? _fillColor;
    _cursorColor = cursorColor ?? _cursorColor;
    _suffixIconColor = suffixIconColor ?? _suffixIconColor;
    _filled = filled ?? _filled;
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
    _floatingLabelBehavior = floatingLabelBehavior ?? _floatingLabelBehavior;
  }

  TextFieldConfiguration setConfiguration({TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    TextStyle? prefixStyle,
    TextStyle? counterStyle,
    TextStyle? suffixStyle,
    InputBorder? border,
    InputBorder? focusedBorder,
    bool? enableLabel,
    bool? filled,
    Color? fillColor,
    Color? cursorColor,
    Color? suffixIconColor,
    EdgeInsets? contentPadding,
    FloatingLabelBehavior? floatingLabelBehavior,
  }) {
    return TextFieldConfiguration(
        textStyle : textStyle ?? _textStyle,
        hintStyle : hintStyle ?? _hintStyle,
        labelStyle : labelStyle ?? _labelStyle,
        prefixStyle : prefixStyle ?? _prefixStyle,
        errorStyle : errorStyle ?? _errorStyle,
        counterStyle : counterStyle ?? _counterStyle,
        suffixStyle : suffixStyle ?? _suffixStyle,
        border : border ?? _border,
        focusedBorder : focusedBorder ?? _focusedBorder,
        fillColor : fillColor ?? _fillColor,
        suffixIconColor : suffixIconColor ?? _suffixIconColor,
        cursorColor : cursorColor ?? _cursorColor,
        filled: filled??_filled,
        enableLabel : enableLabel ?? _enableLabel,
        contentPadding : contentPadding ?? _contentPadding,
        floatingLabelBehavior : floatingLabelBehavior ?? _floatingLabelBehavior
    );
  }
  set setBorder (value){
    _border = value;
  }

  set setTextStyle (value){
    _textStyle = value;
  }
  set setHintStyle (value){
    _hintStyle = value;
  }
  set setStrutStyle (value){
    _strutStyle = value;
  }
  set setTextDirection (value){
    _textDirection = value;
  }
  set setEnableLabel (value){
    _enableLabel = value;
  }
}
TelTextFieldConfiguration telTextFieldConfiguration = TelTextFieldConfiguration();

