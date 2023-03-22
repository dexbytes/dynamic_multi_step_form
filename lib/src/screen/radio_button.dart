part of dynamic_json_form;

class RadioButton extends StatefulWidget {
  final List<RadioButtonOptions>? optionList;
  final bool autoValidate;
  final Map<String,dynamic> jsonData;

  final RadioButtonConfiguration? viewConfiguration;
  final Function (String fieldKey,String fieldValue) onChangeValue ;

  const RadioButton({Key? key,required this.jsonData,required this.onChangeValue,
    this.optionList = const [],
    this.viewConfiguration, required this.autoValidate
  }) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState(optionList: this.optionList,autoValidate:autoValidate,jsonData: jsonData,onChangeValue: onChangeValue,viewConfiguration:viewConfiguration);

}

class _RadioButtonState extends State<RadioButton> {
  List<RadioButtonOptions>? optionList = [];
  RadioButtonModel? radioButtonModel;
  Map<String, dynamic> jsonData;
  RadioButtonConfiguration? viewConfiguration;
  String fieldKey = "";
  String label = "";
  bool enableLabel = true;
  String placeholder = "";
  String value = "";
  RadioButtonOptions _initialValue = RadioButtonOptions();
  String? selectedOption = '';
  bool autoValidate = false;



  Function (String fieldKey, String fieldValue) onChangeValue;

  _RadioButtonState(
      {required this.jsonData, this.optionList, required this.onChangeValue, this.viewConfiguration, this.autoValidate = false}) {
    radioButtonModel ??= responseParser.radioButtonFormFiledParsing(
        jsonData: jsonData, updateCommon: true);
    setValues(radioButtonModel, jsonData);
  }

  @override
  void didUpdateWidget(oldWidget) {
    autoValidate = widget.autoValidate;
    super.didUpdateWidget(oldWidget);
  }


  //Initial value set
  void setValues(RadioButtonModel? radioButtonModel,
      Map<String, dynamic> jsonData) {
    viewConfiguration = viewConfiguration ??
        ConfigurationSetting.instance._radioButtonConfiguration;

    if (radioButtonModel != null) {
      try {
        enableLabel = jsonData['elementConfig']['enableLabel'];
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      if (radioButtonModel.elementConfig != null) {
        fieldKey = radioButtonModel.elementConfig!.name!;
        label = radioButtonModel.elementConfig!.label!;

        value = radioButtonModel.value ?? "";
        String tempVal = radioButtonModel.elementConfig!.initialValue ?? '';

        if (radioButtonModel.elementConfig!.options!.isNotEmpty) {
          optionList = radioButtonModel.elementConfig!
              .options!
              .map((e) =>
              RadioButtonOptions(value: e.value, displayValue: e.displayValue))
              .toList();
          optionList!.map((e) {
            if (tempVal
                .toString()
                .trim()
                .isNotEmpty) {
              if (e.value == tempVal) {
                selectedOption = tempVal;
                _initialValue = e;
              }
            }
          }).toList();
        }
        onChangeValue.call(fieldKey, selectedOption!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var radioButtonAlignment = viewConfiguration!._radioButtonsAlign ==
        LabelAndOptionsAlignment.horizontal ? Axis.horizontal : Axis.vertical;

    //Label
    Widget label = Text(radioButtonModel!.elementConfig!.label ?? '',
        style: viewConfiguration!._labelTextStyle);

    //Create group of radio buttons
    Widget radioButtons = RadioGroup<String>.builder(
      direction: radioButtonAlignment,
      groupValue: _initialValue,
      spaceBetween: 30,
      horizontalAlignment: MainAxisAlignment.start,
      onChanged: (selectedValue) =>
          setState(() {
            _initialValue = selectedValue as RadioButtonOptions;
            selectedOption = selectedValue.value!.toString();
            onChangeValue.call(fieldKey, selectedOption!);
          }),
      items: optionList ?? [],
      itemBuilder: (item) => RadioButtonBuilder(item.displayValue ?? ""),
      activeColor: viewConfiguration!._radioButtonActiveColor,
      textStyle: viewConfiguration!._optionTextStyle,
    );

      Widget errorMessage = (selectedOption != null && selectedOption!.toString().trim().isNotEmpty)?Container():
      Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 2),
        child:Text(radioButtonModel!.validation!.errorMessage!.required.toString(),style: const TextStyle(color:  Color(0xFFD32F2F),fontSize: 12),));


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelAndOptionsAlignment.vertical ==
                  viewConfiguration!._labelAndRadioButtonAlign ?
              //Vertical alignment of radio buttons with label
              Row(
                children: [
                  Flexible(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      label,
                      const SizedBox(height: 3,),
                      radioButtons,
                    ],))
                ],
              ) :
              //Horizontal alignment of radio buttons with label
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: label,
                  ),
                  const SizedBox(width: 15,),
                  Expanded(child: radioButtons,)
                ],),
              const SizedBox(height: 5,),
              autoValidate ? errorMessage : Container()
            ],
          );

  }
}

enum RadioButtonTextPosition { right, left, }
class RadioButtonBuilder<T> {
  final String description;
  final RadioButtonTextPosition? textPosition;
  RadioButtonBuilder(
      this.description, {
        this.textPosition,
      });
}

class RadioGroup<T> extends StatelessWidget {
  /// Creates a [RadioButton] group
  ///
  /// The [groupValue] is the selected value.
  /// The [items] are elements to contruct the group
  /// [onChanged] will called every time a radio is selected. The clouser return the selected item.
  /// [direction] most be horizontal or vertial.
  /// [spaceBetween] works only when [direction] is [Axis.vertical] and ignored when [Axis.horizontal].
  /// and represent the space between elements
  /// [horizontalAlignment] works only when [direction] is [Axis.horizontal] and ignored when [Axis.vertical].
  final RadioButtonOptions groupValue;
  final List<RadioButtonOptions> items;
  final RadioButtonBuilder Function(RadioButtonOptions value) itemBuilder;
  final void Function(RadioButtonOptions?)? onChanged;
  final Axis direction;
  final double spaceBetween;
  final MainAxisAlignment horizontalAlignment;
  final Color? activeColor;
  final TextStyle? textStyle;

  const RadioGroup.builder({
    required this.groupValue,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
    this.direction = Axis.vertical,
    this.spaceBetween = 20,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.activeColor,
    this.textStyle,
  });

  List<Widget> get _group => items.map(
        (item) {
      final radioButtonBuilder = itemBuilder(item);
      return SizedBox(
          height: direction == Axis.vertical ? spaceBetween : 30.0,
          child: RadioButtonWidget(
            description: radioButtonBuilder.description,
            value: item,
            groupValue: groupValue,
            onChanged: (option){
              onChanged?.call(option as RadioButtonOptions);
            },
            textStyle: textStyle,
            textPosition: radioButtonBuilder.textPosition ??
                RadioButtonTextPosition.right,
            activeColor: activeColor,
          )
      );
    },
  ).toList();

  @override
  Widget build(BuildContext context) => direction == Axis.vertical
      ? Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _group,
  ) : Wrap(children:_group
  );
}

class RadioButtonWidget<T> extends StatelessWidget {
  final String description;
  final T value;
  final T groupValue;
  final void Function(T?)? onChanged;
  final RadioButtonTextPosition textPosition;
  final Color? activeColor;
  final TextStyle? textStyle;

  const RadioButtonWidget({
    Key? key,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.textPosition = RadioButtonTextPosition.right,
    this.activeColor,
    this.textStyle,
  }): super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      if (onChanged != null) {
        onChanged!(value);
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: textPosition == RadioButtonTextPosition.right
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        textPosition == RadioButtonTextPosition.left
            ? Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            description,
            style: textStyle,
            textAlign: TextAlign.left,
          ),
        )
            : Container(),


          Radio<T>(
            visualDensity: VisualDensity.standard,
            groupValue: groupValue,
            onChanged: onChanged,
            value: value,
            activeColor: activeColor,
            //  splashRadius: 10.0,
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),

        textPosition == RadioButtonTextPosition.right
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            description,
            style: textStyle,
            textAlign: TextAlign.right,
          ),
        )
            : Container(),
      ],
    ),
  );
}