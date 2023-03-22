part of dynamic_json_form;

class CheckBoxWidget extends StatefulWidget {
  final List<Options> optionList;
  final Map<String,dynamic> jsonData;
  final bool autoValidate;
  final CheckBoxConfiguration? viewConfiguration;
  final Function (String fieldKey,List<String> fieldValue) onChangeValue ;

  const CheckBoxWidget({Key? key,required this.jsonData,required this.onChangeValue,
    this.optionList = const [],
    this.viewConfiguration, required this.autoValidate
  }) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState(optionList: this.optionList,autoValidate:autoValidate,jsonData: jsonData,onChangeValue: onChangeValue,
      viewConfiguration:viewConfiguration);
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  List<Options> optionList = [];
  CheckboxModel? checkBoxModel;
  Map<String, dynamic> jsonData;
  CheckBoxConfiguration? viewConfiguration;
  String fieldKey = "";
  String label = "";
  bool enableLabel = true;
  String value = "";
  List<String>? selectedOption = [];
  bool autoValidate = false;

  Function (String fieldKey,List<String> fieldValue) onChangeValue ;
  Options _intialValue = Options();

  _CheckBoxWidgetState({required this.jsonData,required this.optionList,required this.onChangeValue,this.autoValidate = false,this.viewConfiguration}) {
    checkBoxModel ??= responseParser.checkBoxFormFiledParsing(jsonData: jsonData, updateCommon: true);
    setValues(checkBoxModel,jsonData);

  }

  @override
  void didUpdateWidget(oldWidget) {
    autoValidate = widget.autoValidate;
    super.didUpdateWidget(oldWidget);
  }

  //Initial value set
  void setValues(CheckboxModel? radioButtonModel, Map<String, dynamic> jsonData) {

    viewConfiguration  = viewConfiguration ?? ConfigurationSetting.instance._checkBoxConfiguration;

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
        value = radioButtonModel.value??"";

        if (radioButtonModel.elementConfig!.options!.isNotEmpty) {
          optionList = radioButtonModel.elementConfig!.options!.map((e) => Options(value: e.value,displayValue: e.displayValue,checked: e.checked)).toList();

          //Add already selected items
          optionList.map((Options e){
            if(e.checked!){
              selectedOption!.add(e.value!.toString());
            }
          }).toList();
          onChangeValue.call(fieldKey,selectedOption!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var checkBoxAlignment = viewConfiguration!._optionsAlign == LabelAndOptionsAlignment.horizontal?Axis.horizontal:Axis.vertical;

    //Label
    Widget label =  Text(checkBoxModel!.elementConfig!.label??'',style: viewConfiguration!._labelTextStyle,  strutStyle: StrutStyle(),);

    //ErrorMessage
    Widget errorMessage = (selectedOption != null && selectedOption!.isNotEmpty)?Container():
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 2),
      child:Text(checkBoxModel!.validation!.errorMessage!.required.toString()??'',style: const TextStyle(color:  Color(0xFFD32F2F),fontSize: 12)),);


    //Create checkbox list
    Widget checkBoxOptions = CheckBoxGroup<String>.builder(
      direction: checkBoxAlignment,
      groupValue: _intialValue,
      textStyle: viewConfiguration!._optionTextStyle,
      spacebetween: 30,
      horizontalAlignment: MainAxisAlignment.start,
      onChanged: (selectedValue) => setState(() {
        if (selectedValue != null) {
          _intialValue = selectedValue as Options;
          if(selectedOption!.contains(selectedValue.value)){
                    selectedOption!.remove(selectedValue.value!.toString());
                  }else{
                    selectedOption!.add(selectedValue.value!.toString());
                  }
        }
        onChangeValue.call(fieldKey,selectedOption!);
      }),
      items: optionList,
      itemBuilder: (item) => RadioButtonBuilder(item.displayValue??''),
      activeColor: viewConfiguration!._checkboxActiveColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    LabelAndOptionsAlignment.vertical == viewConfiguration!._labelAndRadioButtonAlign?
      //Vertical alignment of checkboxes with label
      Row(
      children: [
      Flexible( child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        label,
        const SizedBox(height: 3,),
        checkBoxOptions
      ],))
    ],
    ):
    //Horizontal alignment of checkboxes with label
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Padding(
    padding: const EdgeInsets.only(top:5.0),
    child: label,
    ),
    const SizedBox(width: 15,),
    Expanded(child: checkBoxOptions,)
    ],),
    const SizedBox(height: 5,),
    autoValidate ? errorMessage : Container()
      ],
    );
  }
}


class CheckBoxGroup<T> extends StatelessWidget {
  /// Creates a [RadioButton] group
  ///
  /// The [groupValue] is the selected value.
  /// The [items] are elements to contruct the group
  /// [onChanged] will called every time a radio is selected. The clouser return the selected item.
  /// [direction] most be horizontal or vertial.
  /// [spacebetween] works only when [direction] is [Axis.vertical] and ignored when [Axis.horizontal].
  /// and represent the space between elements
  /// [horizontalAlignment] works only when [direction] is [Axis.horizontal] and ignored when [Axis.vertical].
  final Options groupValue;
  final List<Options> items;
  final RadioButtonBuilder Function(Options value) itemBuilder;
  final void Function(Options?)? onChanged;
  final Axis direction;
  final double spacebetween;
  final MainAxisAlignment horizontalAlignment;
  final Color? activeColor;
  final TextStyle? textStyle;

  const CheckBoxGroup.builder({
    required this.groupValue,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
    this.direction = Axis.vertical,
    this.spacebetween = 20,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.activeColor,
    this.textStyle,
  });

  List<Widget> get _group => this.items.map(
        (Options item) {
      final radioButtonBuilder = this.itemBuilder(item);

      return Container(
          height: this.direction == Axis.vertical ? this.spacebetween : 30.0,
          child: CheckBoxWithText(
            description: radioButtonBuilder.description,
            value: item,
            groupValue: this.groupValue,
            onChanged: (option){
                this.onChanged?.call(option as Options);
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
  Widget build(BuildContext context) => direction == Axis.vertical ? Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _group,
  ) : Wrap(children:_group);
}

// Check box with option name
class CheckBoxWithText<T> extends StatelessWidget {
  final String description;
  final Options value;
  final T groupValue;
  final void Function(Options?)? onChanged;
  final RadioButtonTextPosition textPosition;
  final Color? activeColor;
  final TextStyle? textStyle;

  const CheckBoxWithText({
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
        value.checked = !value.checked!;
        onChanged!(value);
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: this.textPosition == RadioButtonTextPosition.right
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        this.textPosition == RadioButtonTextPosition.left
            ? Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            this.description,
            style: this.textStyle,
            strutStyle: StrutStyle(),
            textAlign: TextAlign.left,
          ),
        )
            : Container(),

       CheckBoxCustom(
            checkStatus: value.checked,
  activeColor:activeColor,
            onClicked: (value1){
              value.checked = value1;
              if (this.onChanged != null) {
                this.onChanged!(value);
              }
            },
          ),

        this.textPosition == RadioButtonTextPosition.right
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            this.description,
            style: this.textStyle,
            textAlign: TextAlign.right,
            strutStyle: StrutStyle(),
          ),
        )
            : Container(),
      ],
    ),
  );
}

//Check box
class CheckBoxCustom extends StatefulWidget {
  final bool? checkStatus;
  final Color? activeColor;
  final Function(bool)? onClicked;

  const CheckBoxCustom({Key? key,this.checkStatus = false,this.onClicked,this.activeColor}) : super(key: key);

  @override
  _CheckBoxCustomState createState() => _CheckBoxCustomState(checkStatus: checkStatus,onClicked: onClicked,activeColor:activeColor);
}

class _CheckBoxCustomState extends State<CheckBoxCustom> {
  bool? checkStatus;
  Color? activeColor;
  Function(bool)? onClicked;

  _CheckBoxCustomState({this.checkStatus = false, this.onClicked, this.activeColor});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CheckBoxCustom oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.checkStatus != null) {
        checkStatus = widget.checkStatus;
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Checkbox(
        //checkColor: activeColor,
        activeColor: activeColor,
        value: checkStatus, onChanged: (value) {
      debugPrint("$value");
      setState(() {
        checkStatus = value;
      });
      onClicked?.call(checkStatus!);
    });
  }
}