part of dynamic_multi_step_form;

/// Single form view
class SingleForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<String, dynamic>? filledFormData;
  final int index;
  final Function(int, Map<String, dynamic>)? nextPageButtonClick;
  final Function(int, Map<String, dynamic>)? finalSubmitCallBack;
  final Function(Widget)? nextPageButton;
  final Function(Widget)? priPageButton;
  final Alignment? submitButtonAlignment;
  final GlobalKey<SingleFormState>? singleFormKey;

  const SingleForm(
      {Key? key,
      this.submitButtonAlignment,
      required this.formData,
      this.nextPageButtonClick,
      this.filledFormData,
      this.finalSubmitCallBack,
      this.nextPageButton,
      this.priPageButton,
      this.index = 0,
      this.singleFormKey})
      : super(key: singleFormKey);

  @override
  State<SingleForm> createState() =>
      SingleFormState(index: index, formData: formData,filledFormData:this.filledFormData);
}

class SingleFormState extends State<SingleForm> {
  ///We will include the entered values in the map from field on submit click
  Map<String, dynamic> formSubmitData = <String, dynamic>{};
  Map<String, dynamic> autoValidateFieldList = <String, bool>{};
  List<String> fieldsForValidate = [];
  var _formKey;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final StreamController<bool> _fieldStreamControl =
      StreamController<bool>.broadcast();

  Stream get onAutoValidateChanged => _fieldStreamControl.stream;

  Stream get onVariableChanged =>
      DataRefreshStream.instance.getFormFieldsStream.stream;
  Widget? formSubmitButton;
  List<dynamic>? formFieldList;
  Map<String, dynamic> formData;
  String formName = "";
  String? title = "";
  String description = "";
  Map<String, dynamic> formInformation = {};
  Map<String, dynamic>? filledFormData;
  SingleFormState({int index = 0, required this.formData,this.filledFormData}) {
    Map<String, dynamic>? formSubmitFinalSingleData =  setFormData();
    formFieldList = formData['formFields'];
    if(formSubmitFinalSingleData!=null && formSubmitFinalSingleData.isNotEmpty){
      List<dynamic>? formFieldListTemp = formFieldList!.map((e) {
        dynamic valueData = e;
        try {
          String key = valueData["elementConfig"]["name"];
          String? fieldType = valueData["elementConfig"]["type"];
          String? valueLocal = formSubmitFinalSingleData[key];
          if(valueLocal!=null){
                    if(fieldType!=null && fieldType == "date"){
                      // valueData['value'] = dateToTimeStamp(dateVal: valueLocal);
                    }
                    else{
                      valueData['value'] = valueLocal;
                    }
                  }
          print("$valueLocal ewqwddqwdqw      qwdqwdwqd $valueData");
        } catch (e) {
          print(e);
        }
        return valueData;
      }).toList();
      formFieldList = formFieldListTemp ;
    }
    try {
      formName = formData['formName'];
      title = formData['title'];
      description = formData['description'];
      formInformation = {
        "formName": formName,
        "title": title,
        "description": description
      };
    } catch (e) {
      print(e);
    }
    _formKey = GlobalKey<FormState>(debugLabel: "$index");
    autovalidateMode = _autoValidate();
  }

  @override
  void dispose() {
    _fieldStreamControl.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SingleForm oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setFormData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: onVariableChanged,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Padding(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                title != null && title!.trim().isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title!,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xff222222),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Form(
                    key: _formKey,
                    autovalidateMode: autovalidateMode,
                    child: formFieldListView(formFieldList: formFieldList!)),
                formSubmitButton != null
                    ? formSubmitButton!
                    : const SizedBox(height: 0)
              ],
            ),
          );
        });
  }

  ///Get form value
  Map<String, dynamic>? getFormData() {
    setState(() {
      autovalidateMode = _autoValidate(checkValidOnSubmit: true);
    });
    if (_formKey.currentState!.validate()) {
      return formSubmitData;
    }
    return null;
  }

  ///Set form value
  Map<String, dynamic>? setFormData() {
    try {
      int currentPageIndex =  responseParser.getCurrentFormNumber;
      // print("$currentPageIndex");
      Map<String, dynamic> _formSubmitFinalData = responseParser.getFilledFormsData;
      if(_formSubmitFinalData.isNotEmpty){
        Map<String, dynamic> formSubmitFinalSingleData = _formSubmitFinalData["$currentPageIndex"];
        // print("$currentPageIndex");
        return formSubmitFinalSingleData;
      }
      return null;
    } catch (e) {
      print(e);
    }
  return null;
  }

  _autoValidate({bool checkValidOnSubmit = false}) {
    /*if(checkValidOnChange){
      return AutovalidateMode.onUserInteraction;
    }
    else */
    if (checkValidOnSubmit) {
      if (fieldsForValidate.isNotEmpty) {
        fieldsForValidate.map((e) {
          if (formSubmitData.containsKey(e)) {
            if (formSubmitData[e] == null || formSubmitData[e] == '') {
              setState(() {
                autoValidateFieldList[e] = true;
              });
              _fieldStreamControl.sink.add(autoValidateFieldList[e]);
            }
          }
        }).toList();
      }
      return AutovalidateMode.onUserInteraction;
    }
    return AutovalidateMode.disabled;
  }

  ///Check Form field value
  bool validateFields() {
    setState(() {
      autovalidateMode = _autoValidate(checkValidOnSubmit: true);
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  ///Filter form field according type from json and return view
  Widget _getFormField(
      {required Map<String, dynamic> data, Map<String, dynamic>? nextData}) {
    String nextFieldKey = "";
    String currentElementKey = "";
    String currentElementType = "";
    bool isCurrentFieldRequired = false;

    if (data.containsKey("elementType") && data["elementType"].isNotEmpty) {
      currentElementType = data["elementType"].toString().toLowerCase();
      currentElementKey = data["elementConfig"]['name'];
    }
    if (data.containsKey("validation") && data["validation"] != null) {
      isCurrentFieldRequired = data["validation"]['required'] ?? false;
    }

    if (nextData != null &&
        nextData.isNotEmpty &&
        nextData.containsKey("elementType") &&
        nextData["elementType"].isNotEmpty) {
      String nextElementType = "";
      nextElementType = nextData["elementType"].toString().toLowerCase();
      if (nextElementType != currentElementType) {
        nextElementType = "";
      } else {
        nextFieldKey = nextData["elementConfig"]['name'];
      }
    }
    if (currentElementType.isNotEmpty) {
      autoValidateFieldList[currentElementKey] = false;
      if (currentElementType != "input" && isCurrentFieldRequired) {
        fieldsForValidate.add(currentElementKey);
      }
      switch (currentElementType) {
        case "input":
          responseParser.setFieldFocusNode = currentElementKey;
          if (nextFieldKey.isNotEmpty) {
            responseParser.setFieldFocusNode = nextFieldKey;
          }

          ///Open mobile field
          if (data.containsKey("elementConfig") &&
              data["elementConfig"].containsKey("type") &&
              data["elementConfig"]["type"].toString().toLowerCase() == "tel") {
            return TextFieldCountryPickerView(
                jsonData: data,
                onChangeValue: (String fieldKey, Map<String, String> value) {
                  /// open this code for country code
                  // formSubmitData[fieldKey] = value;
                },
                onChangeValue2: (String fieldKey, String value) {
                  formSubmitData[fieldKey] = value;
                },
                nextFieldKey: nextFieldKey);
          }
          return TextFieldView(
              jsonData: data,
              onChangeValue: (String fieldKey, String value) {
                formSubmitData[fieldKey] = value;
              },
              nextFieldKey: nextFieldKey);

        case "input_qr_scanner":
          responseParser.setFieldFocusNode = currentElementKey;
          if (nextFieldKey.isNotEmpty) {
            responseParser.setFieldFocusNode = nextFieldKey;
          }
          return QrScannerTextFieldView(
              jsonData: data,
              onChangeValue: (String fieldKey, String value) {
                formSubmitData[fieldKey] = value;
              },
              nextFieldKey: nextFieldKey);

        case "upload_image":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return UploadImageView(
                    jsonData: data,
                    onChangeValue: (String fieldKey, String value) {
                      formSubmitData[fieldKey] = value;
                    },
                    nextFieldKey: nextFieldKey);
              });

        case "select":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return DropDown(
                    jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue2: (String fieldKey, String value) {
                      formSubmitData[fieldKey] = value;
                    },
                    onChangeValue: (String fieldKey, List<String> value) {
                      // open this code value list
                      // formSubmitData[fieldKey] = value;
                    }

                    );
              });

        case "radio":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return RadioButton(
                    jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue: (String fieldKey, String value) {
                      formSubmitData[fieldKey] = value;
                    });
              });

        case "checkbox":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return CheckBoxWidget(
                    jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue: (String fieldKey, List<String> value) {
                      formSubmitData[fieldKey] = value;
                    });
              });

        case "button":
          {
            /* widget.nextPageButton?.call(FormButtonWidget(jsonData: data,
                  onChangeValue: (String fieldKey, List<String> value){
                    print(">>Submit 1 >> ${responseParser.getTotalFormsCount}");
                    if(responseParser.getTotalFormsCount> responseParser.getCurrentFormNumber){
                      if(validateFields()){
                        var data =  getFormData();
                        if(data!.isNotEmpty){
                          setState(() {
                            responseParser.setCurrentFormNumber = responseParser.getCurrentFormNumber+1;
                          });
                        }
                      }
                      widget.nextPageButtonClick?.call(responseParser.getCurrentFormNumber);
                      print(">>Submit 2 >> ${responseParser.getCurrentFormNumber}");
                    }
                    else {
                      if(validateFields()){
                        var data =  getFormData();
                        if(data!.isNotEmpty){
                          // widget.finalSubmitCallBack?.call(formSubmitData);
                        }
                      }
                    }
                    // formSubmitData[fieldKey] = value;
                  }));
              widget.priPageButton?.call( responseParser.getCurrentFormNumber>0?FormButtonWidget(jsonData: data,
                  onChangeValue: (String fieldKey, List<String> value){
                    print(">>Pre 1 >> ${responseParser.getCurrentFormNumber}");
                    if(responseParser.getCurrentFormNumber>0){
                      print(">>Pre 2 >> ${responseParser.getCurrentFormNumber}");
                      setState(() {
                        responseParser.setCurrentFormNumber = responseParser.getCurrentFormNumber - 1;
                      });
                      widget.nextPageButtonClick?.call(responseParser.getCurrentFormNumber);
                      print(">>Pre 3 >> ${responseParser.getCurrentFormNumber}");
                    }
                    else {

                    }
                    // formSubmitData[fieldKey] = value;
                  }):const SizedBox(height: 0,width: 0,));
*/

            formSubmitButton = StreamBuilder(
                stream: onAutoValidateChanged,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      responseParser.getCurrentFormNumber > 0
                          ? FormButtonWidget(
                              label: "Preview",
                              jsonData: data,
                              onChangeValue:
                                  (String fieldKey, List<String> value) {
                                if (responseParser.getCurrentFormNumber > 0) {
                                  setState(() {
                                    responseParser.setCurrentFormNumber =
                                        responseParser.getCurrentFormNumber - 1;
                                  });
                                  widget.nextPageButtonClick?.call(
                                      responseParser.getCurrentFormNumber,
                                      formSubmitData);
                                } else {}
                                // formSubmitData[fieldKey] = value;
                              })
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      FormButtonWidget(
                          jsonData: data,
                          onChangeValue: (String fieldKey, List<String> value) {
                            if (responseParser.getTotalFormsCount - 1 >
                                responseParser.getCurrentFormNumber) {
                              if (validateFields()) {
                                var data = getFormData();
                                if (data!.isNotEmpty) {
                                  setState(() {
                                    responseParser.setCurrentFormNumber =
                                        responseParser.getCurrentFormNumber + 1;
                                  });
                                }
                              }
                              widget.nextPageButtonClick?.call(
                                  responseParser.getCurrentFormNumber,
                                  formSubmitData);
                            } else {
                              if (validateFields()) {
                                var data = getFormData();
                                if (data!.isNotEmpty) {
                                  widget.finalSubmitCallBack?.call(
                                      responseParser.getCurrentFormNumber,
                                      formSubmitData);
                                }
                              }
                            }
                          })
                    ],
                  );
                });

            return const SizedBox(
              height: 0,
            );
          }
      }
    }
    return Container();
  }

  Widget formFieldListView({required List<dynamic> formFieldList}) {
    int nextItemIndex = 1;
    responseParser.clearFieldFocusNode();
    return Column(
        children: formFieldList.map((element) {
      Map<String, dynamic> data = element;
      Map<String, dynamic> nextData = {};

      if (nextItemIndex < formFieldList.length) {
        nextData = formFieldList[nextItemIndex];
        nextItemIndex = nextItemIndex + 1;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getFormField(data: data, nextData: nextData),
          // formSubmitButton!=null?(widget.submitButtonAlignment!=null?(Align(child: formSubmitButton!,alignment: widget.submitButtonAlignment!,)):formSubmitButton!):const SizedBox(),
          const SizedBox(height: 10, width: 10)
        ],
      );
    }).toList());
  }
}
String dateToTimeStamp({dateVal}){
  String stringDate1 = '';
  String dateValue = dateVal == "" ? DateFormat('dd/MM/yyyy').format(DateTime.now()): DateFormat('dd/MM/yyyy').format(DateTime.parse(dateVal));
  if(dateValue != '0000-00-00' && dateValue != ''){
    List values1  = dateValue.split("/");
    String day = values1[0].toString().padLeft(2, '0');
    String month = values1[1].toString().padLeft(2, '0');
    String year = values1[2];
    stringDate1 = '$year-$month-$day 01:01:01';
  }
  String dateTimeVal = dateValue == '0000-00-00' || dateValue == '' ? DateFormat('dd/MM/yyyy').format(DateTime.now()) : DateFormat('dd/MM/yyyy').format(DateTime.parse(stringDate1));
  List values  = dateTimeVal.split("/");
  String day = values[0].toString().padLeft(2, '0');
  String month = values[1].toString().padLeft(2, '0');
  String year = values[2];
  String stringDate = '$year-$month-$day 01:01:01';
  DateTime dateWithTime = DateTime.parse(stringDate);
  // DateTime dateTimeValue = DateFormat('yyyy/MM/dd').parse('0000-00-00');
  int timeStamp = (dateWithTime.millisecondsSinceEpoch / 1000).round();
  return timeStamp.toString();
}
