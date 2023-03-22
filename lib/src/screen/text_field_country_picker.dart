part of dynamic_json_form;
// enum formFieldType {text,name,email,tel,url,number,textMultiline}
class TextFieldCountryPickerView extends StatefulWidget {
  final Map<String,dynamic> jsonData;
  final String? nextFieldKey;
  final TelTextFieldConfiguration? viewConfiguration;
  final Function (String fieldKey,Map<String,String> fieldValue) onChangeValue ;
   const TextFieldCountryPickerView({Key? key, required this.jsonData,required this.onChangeValue,this.viewConfiguration,this.nextFieldKey = ""}) : super(key: key);
  @override
  _TextFieldCountryPickerState createState() => _TextFieldCountryPickerState(jsonData: jsonData,onChangeValue: onChangeValue,viewConfiguration: viewConfiguration,nextFieldKey:nextFieldKey!);
}
class _TextFieldCountryPickerState extends State<TextFieldCountryPickerView> {
  String fieldKey = "";
  String nextFieldKey = "";
  bool obscureText = false;
  String formFieldType = "text";
  final _formTelFieldKey = GlobalKey<FormState>();
  Map<String,dynamic> jsonData;
  final TextEditingController? _nameController =  TextEditingController();
  TextFieldModel? textFieldModel;
  ConfigurationSetting configurationSetting = ConfigurationSetting.instance;
  TelTextFieldConfiguration? viewConfiguration;
  CountryPickerViewConfig? viewConfig;
  Function (String fieldKey,Map<String,String> fieldValue) onChangeValue ;
  final StreamController<bool> _fieldStreamControl = StreamController<bool>();

  OverlayEntry? overlayEntry;
  Stream get onVariableChanged => _fieldStreamControl.stream;
  late FocusNode currentFocusNode;
  late FocusNode nextFocusNode;
  bool checkValidOnChange = false;
  bool checkValid = true;
  bool checkValidOnSubmit = false;
  bool isDoneOver = false;
  late MediaQueryData queryData;
  bool isCountryCode = false;
  List enabledCountries =  ["Sa","In"];
  String selectedCountryCode = '';
  String enteredNumber = '';
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  _TextFieldCountryPickerState({required this.jsonData,required this.onChangeValue,this.viewConfiguration,this.nextFieldKey = ""}){
    textFieldModel ??= responseParser.textFormFiledParsing(jsonData: jsonData,updateCommon: true);

    if(textFieldModel!=null){
      _nameController!.text = textFieldModel!.value??"";
      autovalidateMode = _autoValidate();
      if(textFieldModel!.elementConfig!=null){
        formFieldType = textFieldModel!.elementConfig!.type??"text";
        formFieldType  = formFieldType.toLowerCase();
        fieldKey = textFieldModel!.elementConfig!.name!;

        checkValidOnChange = textFieldModel!.onchange??false;
        checkValid = textFieldModel!.valid??false;

        //Country code required condition
        if(jsonData['elementConfig'].containsKey('isCountryCode') && jsonData['elementConfig']['isCountryCode']){
          isCountryCode = jsonData['elementConfig']['isCountryCode'];

          if(jsonData['elementConfig'].containsKey('enabledCountries')) {
            enabledCountries = jsonData['elementConfig']['enabledCountries'];
            selectedCountryCode = enabledCountries.isNotEmpty?enabledCountries[0]:"";
          }
        }

        onChangeValue.call(fieldKey,getData(enteredNumber.trim(),selectedCountryCode));

        currentFocusNode = (responseParser.getFieldFocusNode.containsKey(fieldKey)? responseParser.getFieldFocusNode[fieldKey]:FocusNode())!;nextFocusNode = (responseParser.getFieldFocusNode.containsKey(nextFieldKey)? responseParser.getFieldFocusNode[nextFieldKey]:FocusNode())!;

        viewConfig = CountryPickerViewConfig(isCountryCode: isCountryCode,enabledCountries: enabledCountries,viewConfiguration: viewConfiguration,nameController: _nameController!,textFieldModel: textFieldModel!, formFieldType: formFieldType,obscureTextState: obscureText,obscureTextStateCallBack: (value){
          obscureText = value;
          _fieldStreamControl.sink.add(obscureText);
        },countryCodeCallBack: (value){
          selectedCountryCode = value;
          onChangeValue.call(fieldKey,getData(enteredNumber.trim(),selectedCountryCode));
        });
      }
    }

  }

  @override
  void initState() {
    super.initState();
    currentFocusNode.addListener(() {
      if (isDoneOver && (Platform.isIOS)) {
        bool hasFocus = currentFocusNode.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      }
    });
   // _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    super.dispose();
  }

  //Get Keyboard type according to input type
  TextInputType keyBoardType({required String formFieldType}){
    TextInputType keyBoardType = TextInputType.text;
    switch(formFieldType){
        case 'text':
        keyBoardType = TextInputType.text;
        break ;
        case 'password':
        keyBoardType = TextInputType.text;
        obscureText = true;
        break ;
        case 'name':
        keyBoardType = TextInputType.name;
        break ;
        case 'email':
        keyBoardType = TextInputType.emailAddress;
        break ;
        case 'tel':
        isDoneOver = true;
        keyBoardType = TextInputType.phone;

        break ;
        case 'url':
        keyBoardType = TextInputType.url;
        break ;
        case 'number':
        isDoneOver = true;
        keyBoardType = TextInputType.number;
        break ;
        case 'text_multiline':
        isDoneOver = true;
        keyBoardType = TextInputType.multiline;
        break ;
    }
   // keyBoardType = TextInputType.text;

    return keyBoardType;
}

  List<TextInputFormatter>? inputFormatter(){
    //String keyText = textFieldModel!.validation!.rejex!;
    String keyText = textFieldModel!.elementConfig!.keyboardRejex!;
    // if(formFieldType.toLowerCase()=="tel"){
    //  // keyText = r'[0-9]';
    // }
    List<TextInputFormatter>? filter = [];
    if(keyText.isNotEmpty){
      filter = [];
      //filter.add(FilteringTextInputFormatter.digitsOnly);
      filter.add(FilteringTextInputFormatter.allow(RegExp(keyText)));
      filter.add(FilteringTextInputFormatter.deny('+'));
      return filter;
    }
    return filter;
}

//Get minLine of input field
  int? minLine(){
    int minLine = textFieldModel!.elementConfig!.minLine!;
    //We are restrict input field must min 1 line not less not much in below case
    if(obscureText || configurationSetting.singleLineInputFields.contains(formFieldType.toLowerCase())){
      minLine = 1;
    }
    return minLine;
}

//Get maxLine of input field
  int? maxLine(){
    int maxLine = textFieldModel!.elementConfig!.maxLine!;
    //We are restrict input field must min 1 line not less not much in below case
    if(obscureText || configurationSetting.singleLineInputFields.contains(formFieldType.toLowerCase())){
      maxLine = 1;
    }
    return maxLine;
}


  Widget fieldHelpText(){
    if(textFieldModel!.help!=null && textFieldModel!.help!.text!.isNotEmpty){
      return Padding(
        padding: const EdgeInsets.only(top: 5.0,bottom: 5),
        child: Row(
          children: [
            Text(textFieldModel!.help!.text!,textAlign: TextAlign.left,),
          ],
        ),
      );
    }
    return Container();
}
  VerticalDirection fieldHelpPosition(){
    if(textFieldModel!.help!=null && textFieldModel!.help!.text!.isEmpty){
      return VerticalDirection.up;
    }
    return VerticalDirection.down;
  }

  //for ios done button callback
  onPressCallback() {
    removeOverlay();
    FocusScope.of(context).requestFocus(new FocusNode());
    if(mounted && _nameController!=null && _nameController!.text.isNotEmpty && checkValid){
      setState(() {
        checkValidOnChange = true;
        autovalidateMode = _autoValidate();
      });

      moveToNextField(_nameController!.text.toString());

    }
  }
  //for keyboard done button
  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context)!;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView(
            onPressCallback: onPressCallback,
            buttonName: "Done",
          ));
    });

    overlayState.insert(overlayEntry!);
  }
  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  _autoValidate({bool checkValidOnSubmit = false}){
    if(checkValidOnChange){
      return AutovalidateMode.onUserInteraction;
    }
    else if(checkValid) {
      return AutovalidateMode.disabled;
    }
    return AutovalidateMode.disabled;

  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    //Check if data not pars properly
    if(fieldKey.isEmpty){
      return const SizedBox(height: 0,width: 0,);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: fieldHelpPosition(),
      children: [
      StreamBuilder(
      stream: onVariableChanged,builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          obscureText = snapshot.data;
        }
        return TextFormField(
        key: _formTelFieldKey,focusNode: currentFocusNode,strutStyle:StrutStyle(),
        readOnly: textFieldModel!.validation!.isReadOnly!,
        enabled: !textFieldModel!.validation!.isDisabled!,
        controller: _nameController,
        textInputAction: TextInputAction.done,
        maxLength: textFieldModel!.validation!.maxLength,   //It is the length of char
        maxLines: maxLine(),
        minLines: minLine(),
        decoration: viewConfig!.getInputDecoration(),obscureText: obscureText,
        keyboardType: keyBoardType(formFieldType: formFieldType),
        inputFormatters: inputFormatter(),
        validator: (value){
          if(value!.isEmpty && !checkValid){
            return null;
          }
          else if(value.isNotEmpty && !checkValid && !checkValidOnChange){
            return null;
          }
          return commonValidation.checkValidation(enteredValue:value,validationStr: textFieldModel!.validationStr!,formFieldType:formFieldType);

        }
      ,onChanged: (value){
            if(mounted){
              enteredNumber = value;
              onChangeValue.call(fieldKey,getData(enteredNumber.trim(),selectedCountryCode));
            }
        },
          onSaved: (value){
            //Check validation on submit and will not submit data on server
             if((value!.isNotEmpty && checkValid)){
             /* setState(() {
                checkValidOnSubmit = true;
                autovalidateMode = _autoValidate(checkValidOnSubmit:true);
              });*/
             // _formTelFieldKey.currentState!.validate();
            }
             else if((checkValid)){
               /*setState(() {
                 checkValidOnSubmit = true;
                 autovalidateMode = _autoValidate(checkValidOnSubmit:true);
               });*/
               // _formFieldKey.currentState!.validate();
             }
            /*else if (checkValidOnSubmit){
              setState(() {
                checkValidOnSubmit = true;
              });
              _formTelFieldKey.currentState!.validate();
            }*/
          },
          onFieldSubmitted:(value){
            if((value.isNotEmpty && checkValid)){
              setState(() {
                checkValidOnChange = true;
                autovalidateMode = _autoValidate();
              });
            }

            moveToNextField(value);
          },
          autovalidateMode: autovalidateMode,
        );
  },),
        fieldHelpText(),

      ],
    );
  }

  Map<String, String> getData(String tel, String selectedCountryCode) {
    return {fieldKey:tel,"code":selectedCountryCode};
  }

  void moveToNextField(String value) {
    if(nextFocusNode!=null && commonValidation.checkValidation(enteredValue:value,validationStr: textFieldModel!.validationStr!,formFieldType:formFieldType) == null){
      nextFocusNode.requestFocus();
    }
  }
}
class CountryPickerViewConfig{
  TelTextFieldConfiguration? viewConfiguration;
  String formFieldType;
  TextFieldModel textFieldModel;
  TextEditingController nameController;
  bool? obscureTextState;
  Function(bool)? obscureTextStateCallBack;
  Function(String)? countryCodeCallBack;
  bool isCountryCode;
  List enabledCountries;
  CountryPickerViewConfig({this.isCountryCode = false,this.enabledCountries = const [],required this.nameController,required this.formFieldType,required this.textFieldModel,this.obscureTextState = true,this.obscureTextStateCallBack,this.viewConfiguration,required this.countryCodeCallBack}) {
  viewConfiguration  = viewConfiguration ?? ConfigurationSetting.instance._telTextFieldConfiguration;

  }

  InputDecoration _getTextDecoration (){
    bool enableLabel = viewConfiguration!._enableLabel;
    if(textFieldModel.elementConfig!.enableLabel != null){
      enableLabel = textFieldModel.elementConfig!.enableLabel!;
    }
    return InputDecoration(
        contentPadding: viewConfiguration!._contentPadding,
        border: viewConfiguration!._border,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense:true,
        labelStyle: viewConfiguration!._labelStyle,
        errorStyle:  viewConfiguration!._errorStyle,
        counterStyle: viewConfiguration!._counterStyle,
        suffixStyle: viewConfiguration!._suffixStyle,
        prefixStyle: viewConfiguration!._prefixStyle,
        focusedBorder: viewConfiguration!._focusedBorder,
        // suffixText: ,
        // prefixText: ,
        // prefixIcon: ,
        // suffix: ,
        // suffixIconColor: ,
        // counter: ,
        // prefix: ,
        alignLabelWithHint: true,
        filled: viewConfiguration!._filled,
        fillColor: viewConfiguration!._fillColor,

        /*   errorBorder: viewConfiguration!._errorBorder,
        focusedErrorBorder: viewConfiguration!._errorBorder,*/
        enabledBorder: viewConfiguration!._border,
        hintText: textFieldModel.elementConfig!.placeholder??"",hintStyle: viewConfiguration!._hintStyle,
        label: !enableLabel?null:textFieldModel.elementConfig!.label !=null && textFieldModel.elementConfig!.label!.isNotEmpty?Text(textFieldModel.elementConfig!.label!,style: viewConfiguration!._textStyle,):null,suffixIcon: null,counterText: "",errorMaxLines: 3
    );
  }

  getInputDecoration(){
    InputDecoration inputDecoration = _getTextDecoration();
    Widget? suffixIcon;
    Widget? prefixCountryView;
    if(textFieldModel.elementConfig!=null){
      if(textFieldModel.elementConfig!.resetIcon!){
        suffixIcon = SuffixCloseIcon(iconColor:viewConfiguration?._suffixIconColor,textController: nameController,iconClicked: (){
          nameController.text = "";
        },);
      }

      if(isCountryCode && enabledCountries.isNotEmpty){
        prefixCountryView =
            CountryPicker(
              margin: const EdgeInsets.only(left: 0,right: 0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 0,
                  top: 0,
                  bottom: 5,
                  right: 0
              ),
              initialSelection: enabledCountries[0].toString(),
              onChanged: (value){
              countryCodeCallBack!.call(value.dialCode.toString());
                if (kDebugMode) {
                  print("$value");
                }
                //countryCode = value.dialCode!;
              },
              onInit: (value){
                if (kDebugMode) {
                  print("$value");
                }
              countryCodeCallBack!.call(value!.dialCode.toString());
                //countryCode = value!.dialCode!;
              },
            );
      }
    }
    inputDecoration =  inputDecoration.copyWith(suffixIcon: suffixIcon);
    inputDecoration =  inputDecoration.copyWith(prefixIcon: prefixCountryView);

    switch(formFieldType){
      case 'password':{
        inputDecoration =  inputDecoration.copyWith(suffixIcon: textFieldModel.elementConfig!.resetIcon!?SuffixVisibilityIcon(initialValue: obscureTextState,iconClicked: (bool visibleStatus){
          try {
            obscureTextStateCallBack?.call(visibleStatus);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },):null);
      }
      break ;
      case 'tel':
        inputDecoration =  inputDecoration.copyWith(suffixIcon: suffixIcon);
        break ;
      }

    return inputDecoration;
  }
}
class CountryPicker extends StatelessWidget {
  final String? text;
  final String? initialSelection;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry dividerPadding;
  final void Function(CountryCode)?  onChanged;
  final void Function(CountryCode?)?  onInit;
  final List<String> countryFilter;

  const CountryPicker(
      {Key? key,
        this.text,
        this.textStyle,
        this.margin = EdgeInsets.zero,
        this.padding = EdgeInsets.zero,
        this.dividerPadding = const EdgeInsets.symmetric(horizontal: 21),
        this.initialSelection,
        this.onChanged,
        this.onInit,
        this.countryFilter =  const ['Sa','In'],
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return

      Container(
        margin: margin,
        child: Stack(
          children: [
            Padding(
              padding: dividerPadding,
              child: VerticalDivider(
                width: 10,
                thickness: 1,
                endIndent: 0,
                indent: 0,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            CountryCodePicker(
                searchDecoration: InputDecoration(
                    contentPadding:  const EdgeInsets.all(10),
                    prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                    hintText: "Search country code",
                    hintStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,//Color(0xff828588),
                    ),
                    fillColor:Colors.grey.withOpacity(0.1),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const  BorderSide(width: 0.1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder:OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(12))
                ),
                dialogSize: Size(queryData.size.width/1.15,queryData.size.height/3.8),
                padding: padding,
                backgroundColor: Colors.transparent,
                countryFilter: countryFilter,
                initialSelection: initialSelection,
                showCountryOnly: false,
                showFlag: true,
                flagWidth: 20,
                showFlagDialog: false,
                showOnlyCountryWhenClosed: false,
                dialogBackgroundColor:Colors.white,
                dialogTextStyle: const TextStyle(
                    fontSize: 16,
                    color:Colors.black),
                closeIcon: const Icon(Icons.clear,size: 26,color:Colors.black),
                hideSearch: true,
                hideMainText: false,
                textStyle: const TextStyle(fontSize: 14,color:Colors.black),
                onChanged: onChanged,
                onInit:onInit
              // flagWidth: ,
            ),
          ],
        ),
      );
  }
}
/*class ActionConfig{

}*/

