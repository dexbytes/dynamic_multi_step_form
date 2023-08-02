// import 'package:flutter/material.dart';
part of dynamic_multi_step_form;

/// DropdownConfiguration model
class DropdownConfiguration {
  late TextStyle? _textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xffAEAEAE),
  );

  late TextStyle? _labelTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  late TextStyle? _selectedTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xffAEAEAE),
  );
  late Widget _rightArrow = const Icon(
    Icons.arrow_forward_ios_outlined,
  );
  late Color? _iconEnabledColor = Colors.black;
  late Color? _iconDisabledColor = Colors.grey;
  late BoxDecoration? _buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Color(0xffAEAEAE),
    ),
    color: Colors.white,
  );

  /// The decoration of the dropdown menu
  late BoxDecoration? _dropdownDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Color(0xFFFFFFFF),
  );

  /// The size to use for the drop-down button's icon.
  /// Defaults to 24.0.
  late double _iconSize = 24;
  late double _itemHeight = 35;

  /// The height of the button.
  late double? _buttonHeight = 45;

  /// The width of the button
  late double? _buttonWidth = -1;

  /// The inner padding of the Button
  late EdgeInsetsGeometry? _buttonPadding =
      const EdgeInsets.only(left: 14, right: 14);

  /// The elevation of the Button
  late int? _buttonElevation = 0;
  late int? _dropdownElevation = 5;

  /// The padding of menu items
  late EdgeInsetsGeometry? _itemPadding =
      const EdgeInsets.only(left: 14, right: 14);
  late double? _dropdownMaxHeight = 500;

  /// The highlight color of the current selected item
  late Color? _selectedItemHighlightColor = Colors.grey;

  late Widget? _bottomSheetSelectIconView =
      Icon(Icons.check_circle_sharp, color: Colors.green);

  DropdownConfiguration(
      {TextStyle? textStyle,
      Widget? rightArrow,
      InputBorder? border,
      bool? enableLabel,
      TextStyle? labelTextStyle,
      TextStyle? selectedTextStyle,
      Color? iconEnabledColor,
      Color? iconDisabledColor,
      Color? selectedItemHighlightColor,
      BoxDecoration? buttonDecoration,
      BoxDecoration? dropdownDecoration,
      double? iconSize,
      double? itemHeight,
      double? buttonHeight,
      double? buttonWidth,
      EdgeInsetsGeometry? buttonPadding,
      EdgeInsetsGeometry? itemPadding,
      int? buttonElevation,
      Widget? bottomSheetSelectIconView,
      int? dropdownElevation}) {
    _textStyle = textStyle ?? _textStyle;
    _rightArrow = rightArrow ?? _rightArrow;
    _labelTextStyle = labelTextStyle ?? _labelTextStyle;
    _selectedTextStyle = selectedTextStyle ?? _selectedTextStyle;
    _iconEnabledColor = iconEnabledColor ?? _iconEnabledColor;
    _iconDisabledColor = iconDisabledColor ?? _iconDisabledColor;
    _buttonDecoration = buttonDecoration ?? _buttonDecoration;
    _dropdownDecoration = dropdownDecoration ?? _dropdownDecoration;
    _iconSize = iconSize ?? _iconSize;
    _itemHeight = itemHeight ?? _itemHeight;
    _buttonHeight = buttonHeight ?? _buttonHeight;
    _buttonWidth = buttonWidth ?? _buttonWidth;
    _buttonPadding = buttonPadding ?? _buttonPadding;
    _itemPadding = itemPadding ?? _itemPadding;
    _buttonElevation = buttonElevation ?? _buttonElevation;
    _dropdownElevation = dropdownElevation ?? _dropdownElevation;
    _selectedItemHighlightColor =
        selectedItemHighlightColor ?? _selectedItemHighlightColor;
    _bottomSheetSelectIconView =
        bottomSheetSelectIconView ?? _bottomSheetSelectIconView;
  }

  /* DropdownConfiguration setConfiguration(
      {TextStyle? textStyle,
      Widget? rightArrow,
      InputBorder? border,
      bool? enableLabel,
      TextStyle? labelTextStyle,
      TextStyle? selectedTextStyle,
      Color? iconEnabledColor,
      Color? iconDisabledColor,
      Color? selectedItemHighlightColor,
      BoxDecoration? buttonDecoration,
      BoxDecoration? dropdownDecoration,
      double? iconSize,
      double? itemHeight,
      double? buttonHeight,
      double? buttonWidth,
      EdgeInsetsGeometry? buttonPadding,
      EdgeInsetsGeometry? itemPadding,
      int? buttonElevation,
      int? dropdownElevation}) {
    return DropdownConfiguration(
      textStyle: textStyle ?? _textStyle,
      rightArrow: rightArrow ?? _rightArrow,
      labelTextStyle: labelTextStyle ?? _labelTextStyle,
      selectedTextStyle: selectedTextStyle ?? _selectedTextStyle,
      iconEnabledColor: iconEnabledColor ?? _iconEnabledColor,
      iconDisabledColor: iconDisabledColor ?? _iconDisabledColor,
      buttonDecoration: buttonDecoration ?? _buttonDecoration,
      dropdownDecoration: dropdownDecoration ?? _dropdownDecoration,
      iconSize: iconSize ?? _iconSize,
      itemHeight: itemHeight ?? _itemHeight,
      buttonHeight: buttonHeight ?? _buttonHeight,
      buttonWidth: buttonWidth ?? _buttonWidth,
      buttonPadding: buttonPadding ?? _buttonPadding,
      itemPadding: itemPadding ?? _itemPadding,
      buttonElevation: buttonElevation ?? _buttonElevation,
      dropdownElevation: dropdownElevation ?? _dropdownElevation,
      selectedItemHighlightColor:
          selectedItemHighlightColor ?? _selectedItemHighlightColor,
    );
  }*/

  set setTextStyle(TextStyle value) {
    _textStyle = value;
  }

  set setLabelTextStyle(TextStyle value) {
    _labelTextStyle = value;
  }

  set setSelectedTextStyle(TextStyle value) {
    _selectedTextStyle = value;
  }

  set setRightArrow(Widget value) {
    _rightArrow = value;
  }

  set setIconEnabledColor(Color value) {
    _iconEnabledColor = value;
  }

  set setIconDisabledColor(Color value) {
    _iconDisabledColor = value;
  }

  set setSelectedItemHighlightColor(Color value) {
    _selectedItemHighlightColor = value;
  }

  set setButtonDecoration(BoxDecoration value) {
    _buttonDecoration = value;
  }

  set setDropdownDecoration(BoxDecoration value) {
    _dropdownDecoration = value;
  }

  set setIconSize(double value) {
    _iconSize = value;
  }

  set setItemHeight(double value) {
    _itemHeight = value;
  }

  set setButtonHeight(double value) {
    _buttonHeight = value;
  }

  set setButtonWidth(double value) {
    _buttonWidth = value;
  }

  set setButtonPadding(EdgeInsetsGeometry value) {
    _buttonPadding = value;
  }

  set setItemPadding(EdgeInsetsGeometry value) {
    _itemPadding = value;
  }

  set setButtonElevation(int value) {
    _buttonElevation = value;
  }

  set setDropdownElevation(int value) {
    _dropdownElevation = value;
  }
}

DropdownConfiguration dropdownConfiguration = DropdownConfiguration();
