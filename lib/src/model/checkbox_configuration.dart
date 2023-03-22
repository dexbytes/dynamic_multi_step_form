part of dynamic_json_form;

//enum LabelAndOptionsAlignment{vertical, horizontal}
class CheckBoxConfiguration {

  //Label style
  late TextStyle _labelTextStyle =  const TextStyle();

  //Option text style
  late TextStyle _optionTextStyle =  const TextStyle();

  //label alignment with checkboxes
  late LabelAndOptionsAlignment _labelAndRadioButtonAlign = LabelAndOptionsAlignment.horizontal;

  //Checkbox alignment
  late LabelAndOptionsAlignment _optionsAlign = LabelAndOptionsAlignment.horizontal;

  //Colors of active checkboxes
  late Color _checkboxActiveColor = Colors.blue;

  CheckBoxConfiguration({TextStyle? labelTextStyle,TextStyle? optionTextStyle, Color? checkboxActiveColor, LabelAndOptionsAlignment? labelAndRadioButtonAlign,LabelAndOptionsAlignment? optionsAlign}){
    _labelTextStyle = labelTextStyle ?? _labelTextStyle;
    _labelAndRadioButtonAlign = labelAndRadioButtonAlign ?? _labelAndRadioButtonAlign;
    _optionsAlign = optionsAlign ?? _optionsAlign;
    _optionTextStyle = optionTextStyle ?? _optionTextStyle;
    _checkboxActiveColor = checkboxActiveColor ?? _checkboxActiveColor;
  }

  CheckBoxConfiguration setConfiguration({
    TextStyle? textStyle,
    TextStyle? optionTextStyle,
    Color? checkboxActiveColor,
    LabelAndOptionsAlignment? labelAndRadioButtonAlign,
   LabelAndOptionsAlignment? optionsAlign,
    Widget? rightArrow,InputBorder? border,bool? enableLabel,TextStyle? labelTextStyle,TextStyle? selectedTextStyle,Color? iconEnabledColor,Color? iconDisabledColor,Color? selectedItemHighlightColor,BoxDecoration? buttonDecoration,BoxDecoration? dropdownDecoration,double? iconSize,double? itemHeight,double? buttonHeight,double? buttonWidth,EdgeInsetsGeometry? buttonPadding,EdgeInsetsGeometry? itemPadding,int? buttonElevation,int? dropdownElevation}) {
    return CheckBoxConfiguration(
      labelTextStyle : labelTextStyle ?? _labelTextStyle,
      labelAndRadioButtonAlign : labelAndRadioButtonAlign ?? _labelAndRadioButtonAlign,
      optionsAlign : optionsAlign ?? _optionsAlign,
      optionTextStyle : optionTextStyle ?? _optionTextStyle,
      checkboxActiveColor : checkboxActiveColor ?? _checkboxActiveColor,
    );
  }

  set setLabelTextStyle (TextStyle value){
    _labelTextStyle = value;
  }

  set setLabelAndOptionAlignment (LabelAndOptionsAlignment value){
    _labelAndRadioButtonAlign = value;
  }
  
  set setLabelAndRadioButtonAlign (LabelAndOptionsAlignment value){
    _optionsAlign = value;
  }

  set setOptionsTextStyle (TextStyle value){
    _optionTextStyle = value;
  }

  set checkBoxActiveColor (Color value){
    _checkboxActiveColor = value;
  }


}
CheckBoxConfiguration checkBoxConfiguration = CheckBoxConfiguration();

