part of dynamic_multi_step_form;

/// Custom TextField view
class QrScannerTextFieldView extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final String? nextFieldKey;
  final QrScannerTextFieldConfiguration? viewConfiguration;
  final Function(String fieldKey, String fieldValue) onChangeValue;

  const QrScannerTextFieldView(
      {Key? key,
      required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""})
      : super(key: key);

  @override
  _QrScannerTextFieldsState createState() => _QrScannerTextFieldsState(
      jsonData: jsonData,
      onChangeValue: onChangeValue,
      viewConfiguration: viewConfiguration,
      nextFieldKey: nextFieldKey);
}

class _QrScannerTextFieldsState extends State<QrScannerTextFieldView> {
  String fieldKey = "";
  String? nextFieldKey = "";
  bool obscureText = true;
  String formFieldType = "text";
  String textCapitalizeStr = "none";
  String textInputAction = "none";
  String placeHolderLabel = "";

  Map<String, dynamic> jsonData;
  final TextEditingController? _nameController = TextEditingController();
  QrScannerTextFieldModel? textFieldModel;
  ConfigurationSetting configurationSetting = ConfigurationSetting.instance;
  QrScannerTextFieldConfiguration? viewConfiguration;
  QrScannerViewConfig? viewConfig;
  Function(String fieldKey, String fieldValue) onChangeValue;

  final StreamController<bool> _fieldStreamControl = StreamController<bool>();

  OverlayEntry? overlayEntry;

  Stream get onVariableChanged => _fieldStreamControl.stream;
  late FocusNode currentFocusNode;
  late FocusNode nextFocusNode;
  bool checkValidOnChange = false;
  bool checkValid = true;
  bool isPickFromCalendar = true;
  bool checkValidOnSubmit = false;
  bool isDoneOver = false;
  double textFieldHeight = 50;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _QrScannerTextFieldsState(
      {required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""}) {
    textFieldModel ??= responseParser.qrScannerTextFormFiledParsing(
        jsonData: jsonData, updateCommon: true);
    if (textFieldModel != null) {
      _nameController!.text = textFieldModel!.value ?? "";

      if (textFieldModel!.elementConfig != null) {
        textCapitalizeStr =
            textFieldModel!.elementConfig!.textCapitalization ?? "none";
        textInputAction =
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

        if (formFieldType == 'date') {
          if (textFieldModel!.value != null &&
              textFieldModel!.value!.toString().trim().isNotEmpty) {
            _nameController!.text = packageUtil
                .getText(
                    "dd MMMM, yyyy",
                    commonValidation.getTimeFromTimeStamp(
                        dateTimeStamp: textFieldModel!.value))
                .toString();
            onChangeValue.call(fieldKey, textFieldModel!.value.toString());
          }
        }

        currentFocusNode =
            (responseParser.getFieldFocusNode.containsKey(fieldKey)
                ? responseParser.getFieldFocusNode[fieldKey]
                : FocusNode())!;
        nextFocusNode =
            (responseParser.getFieldFocusNode.containsKey(nextFieldKey)
                ? responseParser.getFieldFocusNode[nextFieldKey]
                : FocusNode())!;

        viewConfig = QrScannerViewConfig(
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
              if (formFieldType == 'date' &&
                  !(textFieldModel!.validation!.isReadOnly!)) {
                pickDate(context,
                    firstDateTS: textFieldModel!.elementConfig!.firstDate,
                    initialDateTS: textFieldModel!.elementConfig!.initialDate,
                    lastDateTS: textFieldModel!.elementConfig!.lastDate);
              }
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
    _fieldStreamControl.close();
    super.dispose();
  }

  ///Get Keyboard type according to input type
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

    /// keyBoardType = TextInputType.text;
    return keyBoardType;
  }

  ///Get TextCapitalization
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

  TextInputAction inputTextAction({required String textInputAction}) {
    TextInputAction textInputAction = TextInputAction.next;
    switch (textCapitalizeStr.toLowerCase()) {
      case 'done':
        textInputAction = TextInputAction.done;
        break;
      case 'go':
        textInputAction = TextInputAction.go;
        break;
      case 'newline':
        textInputAction = TextInputAction.newline;
        break;
      case 'send':
        textInputAction = TextInputAction.send;
        break;
    }
    return textInputAction;
  }

  getDateFormatter({dateFormat = "mm/dd/yy"}) {
    switch (dateFormat.toString().toLowerCase()) {
      case "mm/dd/yy":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xx', separator: '/', maxLength: 8);

      case "dd/mm/yy":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xx', separator: '/', maxLength: 8);

      case "yy/mm/dd":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xx', separator: '/', maxLength: 8);

      case "mm-dd-yy":
        return QrMaskedTextInputFormatter(
            mask: 'xx-xx-xx', separator: '-', maxLength: 8);

      case "dd-mm-yy":
        return QrMaskedTextInputFormatter(
            mask: 'xx-xx-xx', separator: '-', maxLength: 8);

      case "yy-mm-dd":
        return QrMaskedTextInputFormatter(
            mask: 'xx-xx-xx', separator: '-', maxLength: 8);

      case "mm/dd/yyyy":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xxxx', separator: '/', maxLength: 10);

      case "dd/mm/yyyy":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xxxx', separator: '/', maxLength: 10);

      case "yyyy/mm/dd":
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xx', separator: '/', maxLength: 10);

      case "mm-dd-yyyy":
        return QrMaskedTextInputFormatter(
            mask: 'xx-xx-xxxx', separator: '-', maxLength: 10);

      case "dd-mm-yyyy":
        return QrMaskedTextInputFormatter(
            mask: 'xx-xx-xxxx', separator: '-', maxLength: 10);

      case "yyyy-mm-dd":
        return QrMaskedTextInputFormatter(
            mask: 'xxxx-xx-xx', separator: '-', maxLength: 10);

      default:
        return QrMaskedTextInputFormatter(
            mask: 'xx/xx/xxxx', separator: '/', maxLength: 10);
    }
  }

  List<TextInputFormatter>? inputFormatter({required String formFieldType}) {
    String keyText = textFieldModel!.elementConfig!.keyboardRejex!;

    /// String keyText = "^[a-zA-Z '-]+";
    List<TextInputFormatter>? filter = [];
    if (keyText.isNotEmpty) {
      filter = [];
      filter.add(FilteringTextInputFormatter.allow(RegExp(keyText)));
      //return filter;
    }
    String formFieldTypeTemp = formFieldType.toLowerCase();

    ///Not apply regex in this case
    if (formFieldTypeTemp == "email" || formFieldTypeTemp == "password") {
      filter = [];
    }

    ///Not apply regex in this case
    else if (formFieldTypeTemp == "date" && !isPickFromCalendar) {
      String dateFormat = textFieldModel!.elementConfig!.dateFormat!;
      filter = [];
      filter.add(
        getDateFormatter(dateFormat: dateFormat),
      );
    }
    return filter;
  }

  ///Get minLine of input field
  int? minLine() {
    int minLine = textFieldModel!.elementConfig!.minLine!;

    ///We are restrict input field must min 1 line not less not much in below case
    if (obscureText ||
        configurationSetting.singleLineInputFields
            .contains(formFieldType.toLowerCase())) {
      minLine = 1;
    }
    return minLine;
  }

  ///Get maxLine of input field
  int? maxLine() {
    int maxLine = textFieldModel!.elementConfig!.maxLine!;

    ///We are restrict input field must min 1 line not less not much in below case
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

  ///for ios done button callback
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

  ///for keyboard done button
  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
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
    ///Check if data not pars properly
    if (fieldKey.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }

    // if (formFieldType == "date") {
    //   isPickFromCalendar = textFieldModel!.elementConfig!.pickDateFromCalender??true;
    // }
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !textFieldModel!.elementConfig!.enableLabel! ||
                          textFieldModel!
                              .elementConfig!.placeHolderLabel!.isEmpty
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: viewConfig!.viewConfiguration!._padding,
                              child: Text(
                                textFieldModel!
                                    .elementConfig!.placeHolderLabel!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff494949),
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                  TextFormField(
                    focusNode: currentFocusNode,
                    //strutStyle:StrutStyle(),
                    readOnly: (formFieldType == "date" && isPickFromCalendar)
                        ? true
                        : textFieldModel!.validation!.isReadOnly!,
                    enabled: !textFieldModel!.validation!.isDisabled!,
                    onTap: () {
                      if (formFieldType == 'date' &&
                          !(textFieldModel!.validation!.isReadOnly!) &&
                          isPickFromCalendar) {
                        pickDate(context,
                            firstDateTS:
                                textFieldModel!.elementConfig!.firstDate,
                            initialDateTS:
                                textFieldModel!.elementConfig!.initialDate,
                            lastDateTS:
                                textFieldModel!.elementConfig!.lastDate);
                      }
                    },
                    controller: _nameController,
                    cursorColor: viewConfig!.viewConfiguration?._cursorColor ??
                        Colors.blue,
                    textInputAction:
                        inputTextAction(textInputAction: textInputAction),
                    maxLength: textFieldModel!.validation!.maxLength,

                    ///It is the length of char
                    maxLines: maxLine(),
                    minLines: minLine(),
                    textCapitalization:
                        textCapitalize(textCapitalizeStr: textCapitalizeStr),
                    decoration: viewConfig!.getInputDecoration(context),
                    obscureText: obscureText,
                    keyboardType: keyBoardType(formFieldType: formFieldType),
                    inputFormatters:
                        inputFormatter(formFieldType: formFieldType),
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
                        commonValidation.checkValidation(
                            enteredValue: value,
                            validationStr: textFieldModel!.validationStr!,
                            formFieldType: formFieldType);

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
                ],
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

  ///Date of birth
  void pickDate(BuildContext context,
      {firstDateTS, lastDateTS, initialDateTS}) async {
    ///get date from timestamp
    DateTime firstDate = commonValidation.getTimeFromTimeStamp(
        dateTimeStamp: firstDateTS, date: DateTime(DateTime.now().year - 100));
    DateTime lastDate = commonValidation.getTimeFromTimeStamp(
        dateTimeStamp: lastDateTS, date: DateTime(DateTime.now().year));
    DateTime tempDate = commonValidation.getTimeFromTimeStamp(
        dateTimeStamp: initialDateTS, date: DateTime(DateTime.now().year - 10));
    DateTime initialDate = DateTime(DateTime.now().year - 10);

    ///check initial date, it must be after first date and before last date
    try {
      if ((firstDate.isBefore(tempDate) ||
              firstDate.isAtSameMomentAs(tempDate)) &&
          (tempDate.isBefore(lastDate) ||
              lastDate.isAtSameMomentAs(tempDate))) {
        initialDate = tempDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    ///check first date and last date
    try {
      if (lastDate.isBefore(firstDate) || firstDate.isAfter(lastDate)) {
        firstDate = DateTime(DateTime.now().year - 100);
        lastDate = DateTime.now();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    final newDate = await showDatePicker(
        context: context,
        fieldLabelText: "DOB",
        initialDate: initialDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: firstDate,
        lastDate: lastDate,
        confirmText: "OK",
        builder: (context, child) {
          return Theme(
              child: child!,
              data: ThemeData().copyWith(
                  // brightness:!isDarkMode? Brightness.light:Brightness.dark,
                  colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF090C30),
                      onSurface: Color(0xFF090C30),
                      onPrimary: Colors.white,
                      // surface:Colors.green,
                      brightness: Brightness.light),
                  dialogBackgroundColor: Colors.white));
        });

    if (newDate == null) return;
    _nameController!.text =
        packageUtil.getText("dd MMMM, yyyy", newDate).toString();
    onChangeValue.call(fieldKey, newDate.millisecondsSinceEpoch.toString());
  }
}

class QrScannerViewConfig {
  QrScannerTextFieldConfiguration? viewConfiguration;
  String formFieldType;
  QrScannerTextFieldModel textFieldModel;
  TextEditingController nameController;
  bool? obscureTextState;
  bool? enableLabel = false;
  Function(bool)? obscureTextStateCallBack;
  Function()? textFieldCallBack;

  QrScannerViewConfig(
      {required this.nameController,
      required this.formFieldType,
      required this.textFieldModel,
      this.obscureTextState = true,
      this.obscureTextStateCallBack,
      this.textFieldCallBack,
      this.viewConfiguration}) {
    viewConfiguration = viewConfiguration ??
        ConfigurationSetting.instance._qrScannerTextFieldConfiguration;
  }

  ///Color cursorColor = cursorColor ??Colors.red;
  InputDecoration _getTextDecoration() {
    enableLabel = viewConfiguration!._enableLabel;
    if (textFieldModel.elementConfig!.enableLabel != null) {
      enableLabel = textFieldModel.elementConfig!.enableLabel!;
    }

    return InputDecoration(
        contentPadding: viewConfiguration!._contentPadding,
        border: viewConfiguration!._border,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: viewConfiguration!._labelStyle,
        errorStyle: viewConfiguration!._errorStyle,
        counterStyle: viewConfiguration!._counterStyle,
        suffixStyle: viewConfiguration!._suffixStyle,
        prefixStyle: viewConfiguration!._prefixStyle,
        focusedBorder: viewConfiguration!._focusedBorder,
        alignLabelWithHint: true,
        filled: viewConfiguration!._filled,
        fillColor: viewConfiguration!._fillColor,
        isDense: true,
        /*   errorBorder: viewConfiguration!._errorBorder,
        focusedErrorBorder: viewConfiguration!._errorBorder,*/
        enabledBorder: viewConfiguration!._border,
        hintText: textFieldModel.elementConfig!.placeholder ?? "",
        hintStyle: viewConfiguration!._hintStyle,
        label: !enableLabel!
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
        errorMaxLines: 1);
  }

  getInputDecoration(BuildContext context) {
    InputDecoration inputDecoration = _getTextDecoration();
    Widget? suffixIcon;
    if (textFieldModel.elementConfig != null) {
      if (textFieldModel.elementConfig!.resetIcon!) {
        suffixIcon = SuffixScannerIcon(
          iconColor: viewConfiguration?._suffixIconColor,
          qrScannerIconColor: viewConfiguration?._suffixIconColor,
          qrScannerIconWidget: viewConfiguration?._suffixScannerIcon,
          textController: nameController,
          iconClicked: () {
            nameController.text = "";
          },
          qrScannerIconClicked: () {
            bool isQrCode =     textFieldModel.elementConfig!.isQrCodeScanner!;
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => ScannerView(isQrCode),
            ))
                .then((value) {
              try {
                if (value != null && value.toString().isNotEmpty) {
                  nameController.text = value.toString().trim();
                }
              } catch (e) {
                print(e);
              }
            });
            // nameController.text = "";
          },
        );
      }
    }
    inputDecoration = inputDecoration.copyWith(suffixIcon: suffixIcon);
    return inputDecoration;
  }
}

class QrScannerActionConfig {}

class QrMaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  final int maxLength;

  QrMaskedTextInputFormatter({
    required this.mask,
    required this.separator,
    required this.maxLength,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length >= 0 && newValue.text.length <= maxLength) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        } else {
          return newValue;
        }
      }
      return newValue;
    }
    return oldValue;
  }
}

class QrScannerCardNumberFormatter extends TextInputFormatter {
  final String separator;
  final int? maxLength;

  int separatorCount = 0;

  QrScannerCardNumberFormatter({
    required this.separator,
    this.maxLength,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length >= 0) {
      if (newValue.text.length > oldValue.text.length) {
        List str = newValue.text.toString().split("-");
        if (kDebugMode) {
          print("str length : ${str.length}");
        }

        if (newValue.text.length >= 4 &&
            newValue.text.length <= 15 &&
            (newValue.text.length - (str.length - 1)) % 4 == 0) {
          return TextEditingValue(
            text: '${newValue.text}$separator',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
        return newValue;
      }
      return newValue;
    }
    return oldValue;
  }
}

class ScannerView extends StatefulWidget {
  final bool isQrCode;
  ScannerView (this.isQrCode);
  @override
  _ScannerViewState createState() => _ScannerViewState();
}
class _ScannerViewState extends State<ScannerView> {
  String _scanBarcode = 'Unknown';
  bool? isClosed = false;
  BuildContext? contextTemp;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), (){
      if(widget.isQrCode){
        scanQR();
      }
      else {
        scanBarcodeNormal();
      }
    });
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      if(_scanBarcode=="-1"){
        _scanBarcode = "";
      }
    });
    try {
      if (!isClosed!) {
            // widget.scannedValueCallBack.call(result!.code!);
            isClosed = true;
            Navigator.pop(contextTemp!, _scanBarcode.trim());
          }
    } catch (e) {
      print(e);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      if(_scanBarcode=="-1"){
        _scanBarcode = "";
      }
    });
    try {
      if (!isClosed!) {
        // widget.scannedValueCallBack.call(result!.code!);
        isClosed = true;
        Navigator.pop(contextTemp!, _scanBarcode.trim());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    contextTemp = context;
    return MaterialApp(
        home:
        Scaffold(
            appBar: AppBar(title: const Text('Barcode scan'),automaticallyImplyLeading: false,),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       /* ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),*/
                        Text('$_scanBarcode\n',
                            style: TextStyle(fontSize: 10))
                      ]));
            })));
  }
}