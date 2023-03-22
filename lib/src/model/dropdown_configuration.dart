// import 'package:flutter/material.dart';
part of dynamic_json_form;

class DropdownConfiguration {

  late TextStyle? _textStyle =  const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  late TextStyle? _labelTextStyle =  const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  late TextStyle? _selectedTextStyle =  const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  late Widget _rightArrow = const Icon(
    Icons.arrow_forward_ios_outlined,
  );
  late Color? _iconEnabledColor = Colors.white;
  late Color? _iconDisabledColor = Colors.grey;
  late BoxDecoration? _buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.black26,
    ),
    color: Colors.blueAccent,
  );
  /// The decoration of the dropdown menu
  late BoxDecoration? _dropdownDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.blueAccent.shade100,
  );
  /// The size to use for the drop-down button's icon.
  /// Defaults to 24.0.
  late double _iconSize = 24;
  late double _itemHeight = 35 ;
  /// The height of the button.
  late double? _buttonHeight = 45;
  /// The width of the button
  late double? _buttonWidth = -1;
  /// The inner padding of the Button
  late EdgeInsetsGeometry? _buttonPadding = const EdgeInsets.only(left: 14, right: 14);

  /// The elevation of the Button
  late int? _buttonElevation = 1;
  late int? _dropdownElevation = 5;
  /// The padding of menu items
  late EdgeInsetsGeometry? _itemPadding = const EdgeInsets.only(left: 14, right: 14);
  /// The width of the dropdown menu
  late double? _dropdownWidth = -1;
  late double? _dropdownMaxHeight = 100;
  /// The inner padding of the dropdown menu
  late EdgeInsetsGeometry? _dropdownPadding;
  /// The highlight color of the current selected item
  late Color? _selectedItemHighlightColor;

  DropdownConfiguration({TextStyle? textStyle,Widget? rightArrow,InputBorder? border,bool? enableLabel,TextStyle? labelTextStyle,TextStyle? selectedTextStyle,Color? iconEnabledColor,Color? iconDisabledColor,Color? selectedItemHighlightColor,BoxDecoration? buttonDecoration,BoxDecoration? dropdownDecoration,double? iconSize,double? itemHeight,double? buttonHeight,double? buttonWidth,EdgeInsetsGeometry? buttonPadding,EdgeInsetsGeometry? itemPadding,int? buttonElevation,int? dropdownElevation});

  DropdownConfiguration setConfiguration({TextStyle? textStyle,Widget? rightArrow,InputBorder? border,bool? enableLabel,TextStyle? labelTextStyle,TextStyle? selectedTextStyle,Color? iconEnabledColor,Color? iconDisabledColor,Color? selectedItemHighlightColor,BoxDecoration? buttonDecoration,BoxDecoration? dropdownDecoration,double? iconSize,double? itemHeight,double? buttonHeight,double? buttonWidth,EdgeInsetsGeometry? buttonPadding,EdgeInsetsGeometry? itemPadding,int? buttonElevation,int? dropdownElevation}) {
    return DropdownConfiguration(
        textStyle : textStyle ?? _textStyle,
        rightArrow : rightArrow ?? _rightArrow,
        labelTextStyle : labelTextStyle ?? _labelTextStyle,
      selectedTextStyle : selectedTextStyle ?? _selectedTextStyle,
      iconEnabledColor : iconEnabledColor ?? _iconEnabledColor,
      iconDisabledColor : iconDisabledColor ?? _iconDisabledColor,
      buttonDecoration : buttonDecoration ?? _buttonDecoration,
      dropdownDecoration : dropdownDecoration ?? _dropdownDecoration,
      iconSize : iconSize ?? _iconSize,
      itemHeight : itemHeight ?? _itemHeight,
      buttonHeight : buttonHeight ?? _buttonHeight,
      buttonWidth : buttonWidth ?? _buttonWidth,
      buttonPadding : buttonPadding ?? _buttonPadding,
      itemPadding : itemPadding ?? _itemPadding,
      buttonElevation : buttonElevation ?? _buttonElevation,
      dropdownElevation : dropdownElevation ?? _dropdownElevation,
      selectedItemHighlightColor : selectedItemHighlightColor ?? _selectedItemHighlightColor,
    );
}

  set setTextStyle (TextStyle value){
    _textStyle = value;
  }
  set setLabelTextStyle (TextStyle value){
    _labelTextStyle = value;
  }
  set setSelectedTextStyle (TextStyle value){
    _selectedTextStyle = value;
  }
  set setRightArrow (Widget value){
    _rightArrow = value;
  }
  set setIconEnabledColor (Color value){
    _iconEnabledColor = value;
  }
  set setIconDisabledColor (Color value){
    _iconDisabledColor = value;
  }
  set setSelectedItemHighlightColor (Color value){
    _selectedItemHighlightColor = value;
  }
  set setButtonDecoration (BoxDecoration value){
    _buttonDecoration = value;
  }
  set setDropdownDecoration (BoxDecoration value){
    _dropdownDecoration = value;
  }
  set setIconSize (double value){
    _iconSize = value;
  }
  set setItemHeight (double value){
    _itemHeight = value;
  }
  set setButtonHeight (double value){
    _buttonHeight = value;
  }
  set setButtonWidth (double value){
    _buttonWidth = value;
  }
  set setButtonPadding (EdgeInsetsGeometry value){
    _buttonPadding = value;
  }
  set setItemPadding (EdgeInsetsGeometry value){
    _itemPadding = value;
  }
  set setButtonElevation (int value){
    _buttonElevation = value;
  }
  set setDropdownElevation (int value){
    _dropdownElevation = value;
  }

}
DropdownConfiguration dropdownConfiguration = DropdownConfiguration();

