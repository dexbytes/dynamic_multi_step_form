part of dynamic_json_form;

enum LabelAndOptionsAlignment{vertical, horizontal}
class RadioButtonConfiguration {

  //Label style
  late TextStyle _labelTextStyle =  const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  //Option text style
  late TextStyle _optionTextStyle =  const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  //label alignment with radioButton
  late LabelAndOptionsAlignment _labelAndRadioButtonAlign = LabelAndOptionsAlignment.horizontal;

  //Radio buttons alignment
  late LabelAndOptionsAlignment _radioButtonsAlign = LabelAndOptionsAlignment.horizontal;

  //Colors of active radioButton
  late Color _radioButtonActiveColor = Colors.blue;

  RadioButtonConfiguration({TextStyle? labelTextStyle,TextStyle? optionTextStyle, Color? radioButtonActiveColor,LabelAndOptionsAlignment? labelAndRadioButtonAlign,LabelAndOptionsAlignment? radioButtonsAlign}){
    _labelTextStyle = labelTextStyle ?? _labelTextStyle;
    _labelAndRadioButtonAlign = labelAndRadioButtonAlign ?? _labelAndRadioButtonAlign;
    _radioButtonsAlign = radioButtonsAlign ?? _radioButtonsAlign;
    _optionTextStyle = optionTextStyle ?? _optionTextStyle;
    _radioButtonActiveColor = radioButtonActiveColor ?? _radioButtonActiveColor;
  }

  RadioButtonConfiguration setConfiguration({TextStyle? textStyle,TextStyle? optionTextStyle,
    LabelAndOptionsAlignment? labelAndRadioButtonAlign,
   LabelAndOptionsAlignment? radioButtonsAlign,
    Color? radioButtonActiveColor,
    Widget? rightArrow,InputBorder? border,bool? enableLabel,TextStyle? labelTextStyle,TextStyle? selectedTextStyle,Color? iconEnabledColor,Color? iconDisabledColor,Color? selectedItemHighlightColor,BoxDecoration? buttonDecoration,BoxDecoration? dropdownDecoration,double? iconSize,double? itemHeight,double? buttonHeight,double? buttonWidth,EdgeInsetsGeometry? buttonPadding,EdgeInsetsGeometry? itemPadding,int? buttonElevation,int? dropdownElevation}) {
    return RadioButtonConfiguration(
      labelTextStyle : labelTextStyle ?? _labelTextStyle,
      labelAndRadioButtonAlign : labelAndRadioButtonAlign ?? _labelAndRadioButtonAlign,
      radioButtonsAlign : radioButtonsAlign ?? _radioButtonsAlign,
      optionTextStyle : optionTextStyle ?? _optionTextStyle,
      radioButtonActiveColor : radioButtonActiveColor ?? _radioButtonActiveColor,
    );
  }

  set setLabelTextStyle (TextStyle value){
    _labelTextStyle = value;
  }

  set setLabelAndRadioButtonAlign (LabelAndOptionsAlignment value){
    _labelAndRadioButtonAlign = value;
  }

  set setOptionsTextStyle (TextStyle value){
    _optionTextStyle = value;
  }

}
RadioButtonConfiguration radioButtonConfiguration = RadioButtonConfiguration();

