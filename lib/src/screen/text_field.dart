part of dynamic_multi_step_form;

// enum formFieldType {text,name,email,tel,url,number,textMultiline}
class TextFieldView extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final String? nextFieldKey;
  final TextFieldConfiguration? viewConfiguration;
  final Function(String fieldKey, String fieldValue) onChangeValue;
  const TextFieldView(
      {Key? key,
      required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""})
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _TextFieldsState createState() => _TextFieldsState(
      jsonData: jsonData,
      onChangeValue: onChangeValue,
      viewConfiguration: viewConfiguration,
      nextFieldKey: nextFieldKey);
}

class _TextFieldsState extends State<TextFieldView> {
  String fieldKey = "";
  String? nextFieldKey = "";
  bool obscureText = true;
  String formFieldType = "text";
  String textCapitalizeStr = "none";

  Map<String, dynamic> jsonData;
  final TextEditingController? _nameController = TextEditingController();
  TextFieldModel? textFieldModel;
  ConfigurationSetting configurationSetting = ConfigurationSetting.instance;
  TextFieldConfiguration? viewConfiguration;
  ViewConfig? viewConfig;
  Function(String fieldKey, String fieldValue) onChangeValue;
  StreamController<bool> get _fieldStreamControl => StreamController<bool>();

  OverlayEntry? overlayEntry;
  Stream get onVariableChanged => _fieldStreamControl.stream;
  late FocusNode currentFocusNode;
  late FocusNode nextFocusNode;
  bool checkValidOnChange = false;
  bool checkValid = true;
  bool checkValidOnSubmit = false;
  bool isDoneOver = false;
  double textFieldHeight = 50;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  _TextFieldsState(
      {required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""}) {
    textFieldModel ??= responseParser.textFormFiledParsing(
        jsonData: jsonData, updateCommon: true);
    if (textFieldModel != null) {
      _nameController!.text = textFieldModel!.value ?? "";

      if (textFieldModel!.elementConfig != null) {
        textCapitalizeStr =
            textFieldModel!.elementConfig!.textCapitalization ?? "none";
        formFieldType = textFieldModel!.elementConfig!.type ?? "text";
        formFieldType = formFieldType.toLowerCase();
        fieldKey = textFieldModel!.elementConfig!.name!;
        onChangeValue.call(fieldKey, "");
        checkValidOnChange = textFieldModel!.onchange ?? false;
        checkValid = textFieldModel!.valid ?? false;
        autovalidateMode = _autoValidate();
        if (formFieldType != "password") {
          obscureText = false;
        }

        currentFocusNode =
            (responseParser.getFieldFocusNode.containsKey(fieldKey)
                ? responseParser.getFieldFocusNode[fieldKey]
                : FocusNode())!;
        nextFocusNode =
            (responseParser.getFieldFocusNode.containsKey(nextFieldKey)
                ? responseParser.getFieldFocusNode[nextFieldKey]
                : FocusNode())!;

        viewConfig = ViewConfig(
            viewConfiguration: viewConfiguration,
            nameController: _nameController!,
            textFieldModel: textFieldModel!,
            formFieldType: formFieldType,
            obscureTextState: obscureText,
            obscureTextStateCallBack: (value) {
              obscureText = value;
              _fieldStreamControl.sink.add(obscureText);
            },
            textFieldCallBack: () {
              pickDate(context);
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
  TextInputType keyBoardType({required String formFieldType}) {
    TextInputType keyBoardType = TextInputType.text;
    switch (formFieldType) {
      case 'text':
        keyBoardType = TextInputType.text;
        break;
      case 'password':
        keyBoardType = TextInputType.text;
        obscureText = true;
        break;
      case 'name':
        keyBoardType = TextInputType.name;
        break;
      case 'email':
        keyBoardType = TextInputType.emailAddress;
        break;
      case 'tel':
        isDoneOver = true;
        keyBoardType = TextInputType.phone;

        break;
      case 'url':
        keyBoardType = TextInputType.url;
        break;
      case 'number':
        isDoneOver = true;
        keyBoardType = TextInputType.number;
        break;
      case 'date':
        isDoneOver = true;
        keyBoardType = TextInputType.number;
        break;
      case 'text_multiline':
        isDoneOver = true;
        keyBoardType = TextInputType.multiline;
        break;
    }
    // keyBoardType = TextInputType.text;
    return keyBoardType;
  }

  //Get TextCapitalization
  TextCapitalization textCapitalize({required String textCapitalizeStr}) {
    TextCapitalization textCapitalization = TextCapitalization.none;
    switch (textCapitalizeStr.toLowerCase()) {
      case 'sentences':
        textCapitalization = TextCapitalization.sentences;
        obscureText = true;
        break;
      case 'characters':
        textCapitalization = TextCapitalization.characters;
        break;
      case 'words':
        textCapitalization = TextCapitalization.words;
        break;
    }
    return textCapitalization;
  }

  List<TextInputFormatter>? inputFormatter({required String formFieldType}) {
    String keyText = textFieldModel!.elementConfig!.keyboardRejex!;
    // String keyText = "^[a-zA-Z '-]+";
    List<TextInputFormatter>? filter = [];
    if (keyText.isNotEmpty) {
      filter = [];
      filter.add(FilteringTextInputFormatter.allow(RegExp(keyText)));
      //return filter;
    }
    String formFieldTypeTemp = formFieldType.toLowerCase();
    //Not apply regex in this case
    if (formFieldTypeTemp == "email" || formFieldTypeTemp == "password") {
      filter = [];
    }
    return filter;
  }

//Get minLine of input field
  int? minLine() {
    int minLine = textFieldModel!.elementConfig!.minLine!;
    //We are restrict input field must min 1 line not less not much in below case
    if (obscureText ||
        configurationSetting.singleLineInputFields
            .contains(formFieldType.toLowerCase())) {
      minLine = 1;
    }
    return minLine;
  }

//Get maxLine of input field
  int? maxLine() {
    int maxLine = textFieldModel!.elementConfig!.maxLine!;
    //We are restrict input field must min 1 line not less not much in below case
    if (obscureText ||
        configurationSetting.singleLineInputFields
            .contains(formFieldType.toLowerCase())) {
      maxLine = 1;
    }
    return maxLine;
  }

  Widget fieldHelpText() {
    if (textFieldModel!.help != null &&
        textFieldModel!.help!.text!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
        child: Row(
          children: [
            Text(
              textFieldModel!.help!.text!,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  VerticalDirection fieldHelpPosition() {
    if (textFieldModel!.help != null && textFieldModel!.help!.text!.isEmpty) {
      return VerticalDirection.up;
    }
    return VerticalDirection.down;
  }

  //for ios done button callback
  onPressCallback() {
    removeOverlay();
    FocusScope.of(context).requestFocus(FocusNode());
    if (mounted &&
        _nameController != null &&
        _nameController!.text.isNotEmpty &&
        checkValid) {
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

  _autoValidate() {
    if (checkValidOnChange) {
      return AutovalidateMode.onUserInteraction;
    } else if (checkValid) {
      return AutovalidateMode.disabled;
    }
    return AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    //Check if data not pars properly
    if (fieldKey.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: fieldHelpPosition(),
      children: [
        StreamBuilder(
          stream: onVariableChanged,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              obscureText = snapshot.data;
            }
            return SizedBox(
              // height:textFieldHeight,
              child: TextFormField(
                focusNode: currentFocusNode, strutStyle: const StrutStyle(),
                readOnly: textFieldModel!.validation!.isReadOnly!,
                enabled: !textFieldModel!.validation!.isDisabled!,
                controller: _nameController,
                cursorColor:
                    viewConfig!.viewConfiguration?._cursorColor ?? Colors.blue,
                textInputAction: TextInputAction.done,
                maxLength: textFieldModel!
                    .validation!.maxLength, //It is the length of char
                maxLines: maxLine(),
                minLines: minLine(),
                textCapitalization:
                    textCapitalize(textCapitalizeStr: textCapitalizeStr),
                decoration: viewConfig!.getInputDecoration(),
                obscureText: obscureText,
                keyboardType: keyBoardType(formFieldType: formFieldType),
                inputFormatters: inputFormatter(formFieldType: formFieldType),
                validator: (value) {
                  if (value!.isEmpty && !checkValid) {
                    return null;
                  } else if (value.isNotEmpty &&
                      !checkValid &&
                      !checkValidOnChange) {
                    return null;
                  }
                  return commonValidation.checkValidation(
                      enteredValue: value,
                      validationStr: textFieldModel!.validationStr!,
                      formFieldType: formFieldType);
                },
                onChanged: (value) {
                  if (mounted) {
                    onChangeValue.call(fieldKey, value);
                    String? validate = commonValidation.checkValidation(
                        enteredValue: value,
                        validationStr: textFieldModel!.validationStr!,
                        formFieldType: formFieldType);
                    debugPrint("$validate");
                    // if(validate !=null ){
                    //   textFieldHeight = 80;
                    // }else{
                    //   textFieldHeight = 50;
                    // }
                  }
                },
                onSaved: (value) {
                  //Check all validation on submit
                  /*if((!checkValidOnChange && checkValid)){
                setState(() {
                  checkValidOnSubmit = true;
                });
                _formFieldKey.currentState!.validate();
              }*/
                  //Check validation on submit and will not submit data on server
                  if ((value!.isNotEmpty && checkValid)) {
                    /*setState(() {
                  checkValidOnSubmit = true;
                  autovalidateMode = _autoValidate(checkValidOnSubmit : true);
                });*/
                    // _formFieldKey.currentState!.validate();
                  } else if ((checkValid)) {
                    /*setState(() {
                  checkValidOnSubmit = true;
                  autovalidateMode = _autoValidate(checkValidOnSubmit : true);
                });*/

                    // _formFieldKey.currentState!.validate();
                  }
                  //Check validation on submit and will not submit data on server
                  /*else if((value.isNotEmpty && !checkValidOnChange && !checkValid)){
                setState(() {
                  checkValidOnSubmit = true;
                });
                _formFieldKey.currentState!.validate();
              }*/
                },
                onFieldSubmitted: (value) {
                  if ((value.isNotEmpty && checkValid)) {
                    setState(() {
                      checkValidOnChange = true;
                      autovalidateMode = _autoValidate();
                    });

                    moveToNextField(value);
                  }
                },
                autovalidateMode: autovalidateMode,
              ),
            );
          },
        ),
        fieldHelpText(),
      ],
    );
  }

  void moveToNextField(String value) {
    if (commonValidation.checkValidation(
            enteredValue: value,
            validationStr: textFieldModel!.validationStr!,
            formFieldType: formFieldType) ==
        null) {
      nextFocusNode.requestFocus();
    }
  }

  //Date of birth
  void pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        fieldLabelText: "DOB",
        initialDate: DateTime(DateTime.now().year - 10),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year),
        confirmText: "Ok",
        builder: (context, child) {
          return Theme(
              child: child!,
              data: ThemeData().copyWith(
                  // brightness:!isDarkMode? Brightness.light:Brightness.dark,
                  colorScheme: const ColorScheme.dark(
                      /*primary: appColors.buttonColor2,
                      onSurface: appColors.calendarSurfacebgColorBlack,
                      onPrimary: appColors.calendarColorWhite,
                      surface:appColors.buttonColor2,*/
                      brightness: Brightness.light),
                  dialogBackgroundColor: Colors.white));
        });

    if (newDate == null) return;
    _nameController!.text =
        packageUtil.getText("dd MMMM, yyyy", newDate).toString();
    /*setState(() {
      date = newDate;
      nameController?.text = getText().toString();
      widget.selectedValue?.call(date);
    });*/
    // setState(() => date = newDate
    // );
  }
}

class ViewConfig {
  TextFieldConfiguration? viewConfiguration;
  String formFieldType;
  TextFieldModel textFieldModel;
  TextEditingController nameController;
  bool? obscureTextState;
  Function(bool)? obscureTextStateCallBack;
  Function()? textFieldCallBack;
  ViewConfig(
      {required this.nameController,
      required this.formFieldType,
      required this.textFieldModel,
      this.obscureTextState = true,
      this.obscureTextStateCallBack,
      this.textFieldCallBack,
      this.viewConfiguration}) {
    viewConfiguration = viewConfiguration ??
        ConfigurationSetting.instance._textFieldConfiguration;
  }

  //Color cursorColor = cursorColor ??Colors.red;
  InputDecoration _getTextDecoration() {
    bool enableLabel = viewConfiguration!._enableLabel;
    if (textFieldModel.elementConfig!.enableLabel != null) {
      enableLabel = textFieldModel.elementConfig!.enableLabel!;
    }

    return InputDecoration(
        contentPadding: viewConfiguration!._contentPadding,
        border: viewConfiguration!._border,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        //isDense:true,
        labelStyle: viewConfiguration!._labelStyle,
        errorStyle: viewConfiguration!._errorStyle,
        counterStyle: viewConfiguration!._counterStyle,
        suffixStyle: viewConfiguration!._suffixStyle,
        prefixStyle: viewConfiguration!._prefixStyle,
        focusedBorder: viewConfiguration!._focusedBorder,
        //suffixText: viewConfiguration!._suffixText,
        //prefixText: viewConfiguration!._prefixText,
        // prefixIcon: ,
        // suffix: ,
        // suffixIconColor: ,
        // counter: ,
        prefix: viewConfiguration!._prefix,
        alignLabelWithHint: true,
        filled: viewConfiguration!._filled,
        fillColor: viewConfiguration!._fillColor,

        /*   errorBorder: viewConfiguration!._errorBorder,
        focusedErrorBorder: viewConfiguration!._errorBorder,*/
        enabledBorder: viewConfiguration!._border,
        hintText: textFieldModel.elementConfig!.placeholder ?? "",
        hintStyle: viewConfiguration!._hintStyle,
        label: !enableLabel
            ? null
            : textFieldModel.elementConfig!.label != null &&
                    textFieldModel.elementConfig!.label!.isNotEmpty
                ? Text(
                    textFieldModel.elementConfig!.label!,
                    style: viewConfiguration!._textStyle,
                  )
                : null,
        suffixIcon: null,
        counterText: "",
        errorMaxLines: 3);
  }

  getInputDecoration() {
    InputDecoration inputDecoration = _getTextDecoration();
    Widget? suffixIcon;
    if (textFieldModel.elementConfig != null) {
      if (textFieldModel.elementConfig!.resetIcon!) {
        suffixIcon = SuffixCloseIcon(
          iconColor: viewConfiguration?._suffixIconColor,
          textController: nameController,
          iconClicked: () {
            nameController.text = "";
          },
        );
      }
    }
    inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);

    switch (formFieldType) {
      case 'text':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'password':
        {
          inputDecoration = inputDecoration.copyWith(
              suffixIcon: textFieldModel.elementConfig!.resetIcon!
                  ? SuffixVisibilityIcon(
                      initialValue: obscureTextState,
                      iconClicked: (bool visibleStatus) {
                        try {
                          obscureTextStateCallBack?.call(visibleStatus);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                    )
                  : null);
        }
        break;
      case 'name':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'email':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'tel':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'date':
        inputDecoration = inputDecoration.copyWith(
            suffixIcon: textFieldModel.elementConfig!.resetIcon!
                ? SuffixCalendarIcon(
                    iconClicked: (bool visibleStatus) {
                      try {
                        textFieldCallBack?.call();
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                  )
                : null);
        break;
      case 'url':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'number':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
      case 'text_multiline':
        inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
        break;
    }

    return inputDecoration;
  }
}

class ActionConfig {}
