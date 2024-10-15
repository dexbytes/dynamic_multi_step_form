part of dynamic_multi_step_form;

/// Dynamic form screen
class DynamicForm extends StatefulWidget {
  final String jsonEncoded;
  final Function(int currentFormNumber, Map<String, dynamic> data)?
      finalSubmitCallBack;
  final Function(
      {int currentIndex,
      Map<String, dynamic>? formSubmitData,
      Map<String, dynamic>? formInformation,bool? isBack})? currentStepCallBack;
  final GlobalKey<DynamicFormState>? dynamicFormKey;

  final Alignment? submitButtonAlignment;
  final EdgeInsetsGeometry? formPadding;
  final EdgeInsetsGeometry? formIndicatorPadding;
  final bool? showIndicator;
  final List<List<ChildElement>>? childElementList;
  final TextStyle titleTextStyle;

  const DynamicForm(this.jsonEncoded,
      {this.submitButtonAlignment,
      this.dynamicFormKey,
      this.childElementList = const [],
      this.showIndicator = true,
      required this.finalSubmitCallBack,
      this.currentStepCallBack,
      this.formPadding = const EdgeInsets.only(left: 15, right: 15, top: 0),
      this.formIndicatorPadding = const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      this.titleTextStyle = const TextStyle(fontSize: 16, color: const Color(0xff222222), fontWeight: FontWeight.w500)
      })
      : super(key: dynamicFormKey);

  @override
  DynamicFormState createState() => DynamicFormState(jsonEncoded: jsonEncoded,titleTextStyle: titleTextStyle);
}

class DynamicFormState extends State<DynamicForm> {
  String jsonEncoded;
  TextStyle titleTextStyle;

  Stream get onVariableChanged =>
      DataRefreshStream.instance.getFormFieldsStream.stream;
  Map<String, dynamic> formSubmitData = <String, dynamic>{};
  Map<int, dynamic> formScreenList = {};
  List<SingleForm> formScreen = [];
  List<String> formInformation = [];

  DynamicFormState({required this.jsonEncoded,this.titleTextStyle = const TextStyle(fontSize: 16, color: const Color(0xff222222), fontWeight: FontWeight.w500)}) {
    responseParser.setFormData = jsonEncoded;
    formScreenList = responseParser.getFormData;
    int currentIndex = -1;
    formScreen = formScreenList.entries.map((entry) {
      currentIndex += 1;
      final _formKeyNew = GlobalKey<SingleFormState>();
      formInformation.add(entry.value['title']);
      Map<String, dynamic>? filledFormData;
      if(this.formSubmitData.isNotEmpty && this.formSubmitData.containsKey('$currentIndex')){
        filledFormData  =  this.formSubmitData['$currentIndex'];
      }
      return SingleForm(filledFormData: filledFormData,
          singleFormKey: _formKeyNew,
          formData: entry.value,
          titleTextStyle: titleTextStyle,
          nextPageButtonClick: (index, Map<String, dynamic> formSubmitData) {
            this.formSubmitData['$currentIndex'] = formSubmitData;

            widget.currentStepCallBack?.call(
                currentIndex: currentIndex, formSubmitData: formSubmitData,isBack:false);
            setState(() {});
          },
          finalSubmitCallBack: (index, Map<String, dynamic> formSubmitData) {
            this.formSubmitData['$currentIndex'] = formSubmitData;
            widget.finalSubmitCallBack?.call(index, this.formSubmitData);
          });
    }).toList();
  }

  void updateForm(){
    setState(() {
      responseParser.setFormData = widget.jsonEncoded;
      formScreenList = responseParser.getFormData;
      int currentIndex = -1;
      formScreen = formScreenList.entries.map((entry) {
        currentIndex += 1;
        final _formKeyNew = GlobalKey<SingleFormState>();
        formInformation.add(entry.value['title']);
        Map<String, dynamic>? filledFormData;
        if(this.formSubmitData.isNotEmpty && this.formSubmitData.containsKey('$currentIndex')){
          filledFormData  =  this.formSubmitData['$currentIndex'];
        }
        return SingleForm(filledFormData: filledFormData,
            singleFormKey: _formKeyNew,
            formData: entry.value,
            titleTextStyle: titleTextStyle,
            nextPageButtonClick: (index, Map<String, dynamic> formSubmitData) {
              this.formSubmitData['$currentIndex'] = formSubmitData;
              widget.currentStepCallBack?.call(
                  currentIndex: currentIndex, formSubmitData: formSubmitData,isBack:false);
              setState(() {});
            },
            finalSubmitCallBack: (index, Map<String, dynamic> formSubmitData) {
              this.formSubmitData['$currentIndex'] = formSubmitData;
              widget.finalSubmitCallBack?.call(index, this.formSubmitData);
            });
      }).toList();
    });
  }

  @override
  void didUpdateWidget(covariant DynamicForm oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  ///Next step button click event
  void nextStepCustomClick() {
    int currentPage = responseParser.getCurrentFormNumber;

    if (responseParser.getTotalFormsCount - 1 >
        responseParser.getCurrentFormNumber) {
      if (formScreen[currentPage].singleFormKey!.currentState!.validateFields()) {
        int currentPageIndex = responseParser.getCurrentFormNumber;
        Map<String, dynamic> _formSubmitFinalData = responseParser.getFilledFormsData;

// Check if _formSubmitFinalData contains the key and if its value is not null or empty
        if (_formSubmitFinalData.containsKey('$currentPageIndex') &&
            _formSubmitFinalData['$currentPageIndex'] != null &&
            _formSubmitFinalData['$currentPageIndex'] is Map &&
            (_formSubmitFinalData['$currentPageIndex'] as Map).isNotEmpty) {

          // Safely retrieve data since we already checked it's not null and is not empty
          Map<String, dynamic> formSubmitFinalSingleData = _formSubmitFinalData["$currentPageIndex"] as Map<String, dynamic>;
          formSubmitData['$currentPage'] = formSubmitFinalSingleData;

          Map<String, dynamic>? formInformation = formScreen[currentPage]
              .singleFormKey!
              .currentState!
              .formInformation;

          widget.currentStepCallBack?.call(
            currentIndex: currentPage + 1,
            formSubmitData: formSubmitFinalSingleData,
            formInformation: formInformation,
            isBack: false,
          );

          if (formSubmitFinalSingleData.isNotEmpty) {
            setState(() {
              responseParser.setCurrentFormNumber =
                  responseParser.getCurrentFormNumber + 1;
            });
          }
        }
        else {
          Map<String, dynamic>? data = formScreen[currentPage].singleFormKey!.currentState!.getFormData();
          Map<String, dynamic>? formInformation = formScreen[currentPage].singleFormKey!.currentState!.formInformation;
          formSubmitData['$currentPage'] = data;
          responseParser.setFormFilledData('$currentPage',data);
          widget.currentStepCallBack?.call(
              currentIndex: currentPage + 1,
              formSubmitData: data,
              formInformation: formInformation,isBack:false);
          if (data!.isNotEmpty) {
            setState(() {
              responseParser.setCurrentFormNumber =
                  responseParser.getCurrentFormNumber + 1;
            });
          }
        }
      }
    } else {
      if (formScreen[currentPage]
          .singleFormKey!
          .currentState!
          .validateFields()) {
        Map<String, dynamic>? data =
            formScreen[currentPage].singleFormKey!.currentState!.getFormData();
        Map<String, dynamic>? formInformation = formScreen[currentPage]
            .singleFormKey!
            .currentState!
            .formInformation;
        formSubmitData['$currentPage'] = data;

        // responseParser.setFormFilledData('$currentPage',data);

        widget.currentStepCallBack?.call(
            currentIndex: currentPage + 1,
            formSubmitData: data,
            formInformation: formInformation,isBack:false);
        if (data!.isNotEmpty) {
          widget.finalSubmitCallBack
              ?.call(responseParser.getCurrentFormNumber, formSubmitData);
          responseParser.clearFormFilledData();
        }
      }
    }
  }

  ///Preview step button click event
  void previewStepCustomClick() {

    Map<String, dynamic>? data = formScreen[responseParser.getCurrentFormNumber]
        .singleFormKey!
        .currentState!
        .getFormData();
    Map<String, dynamic>? formInformation =
        formScreen[responseParser.getCurrentFormNumber]
            .singleFormKey!
            .currentState!
            .formInformation;


    if (responseParser.getCurrentFormNumber > 0) {
      setState(() {
        responseParser.setCurrentFormNumber =
            responseParser.getCurrentFormNumber - 1;

      });
    }

    widget.currentStepCallBack?.call(
        currentIndex: responseParser.getCurrentFormNumber,
        formSubmitData: data,
        formInformation: formInformation,
        isBack:true);

    // Map<String, dynamic>? dataOld = formSubmitData["$oldPage"];//formScreen[oldPage].singleFormKey!.currentState!.getFormData();
    // Map<String, dynamic>? formInformationOld = formScreen[oldPage]
    //     .singleFormKey!
    //     .currentState!
    //     .formInformation;

    // formScreen[oldPage].singleFormKey!.currentState!.setFormData();

  }

  Widget? customStep(int, color, double) {
    return Container();
  }

  ///Form step indicator
  Widget formStepIndicator() {
    Color selectedColor = Color(0xFF3BAD59);
    Color unselectedColor = Color(0xFFC2C2C2);
    int count = responseParser.getTotalFormsCount;
    int currentPage = responseParser.getCurrentFormNumber;
    return widget.showIndicator!
        ? (count > 1
            ? Padding(
                padding: widget.formIndicatorPadding!,
                child: StepProgressIndicator(
                    totalSteps: count,
                    size: 35,
                    padding: 8,
                    currentStep: currentPage + 1,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onTap: (index) {
                      return () {
                        if (responseParser.getCurrentFormNumber > index) {
                          previewStepCustomClick();
                        }
                      };
                    },
                    customStep: (int index, Color color, double) {
                      String title = "${formInformation[index]}";
                      return Column(
                        children: [
                          Flexible(
                            child: Text(
                              "$title",
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ],
                      );
                    }),
              )
            : const SizedBox(
                height: 0,
              ))
        : SizedBox(
            height: 0,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: !commonValidation.isValidJsonEncoded(jsonEncoded)
          ? Container()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                formStepIndicator(),
                Flexible(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: ListView.builder(
                      shrinkWrap: false,
                      padding: widget.formPadding!,
                      physics: const ClampingScrollPhysics(),
                      itemCount: formScreen.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (responseParser.getCurrentFormNumber != index) {
                          return const SizedBox(
                            height: 0,
                          );
                        }
                        return formScreen[index];
                      }),
                )),
                // formScreen[selectedPageIndex].singleFormKey!=null && formScreen[selectedPageIndex].singleFormKey!.currentState!=null && formScreen[selectedPageIndex].singleFormKey!.currentState!.formSubmitButton!=null?formScreen[selectedPageIndex].singleFormKey!.currentState!.formSubmitButton!:const SizedBox(height:0),
              ],
            ),
    );
  }
}

class ChildElement {
  int? index;
  Widget? childElement;

  ChildElement({this.index = 0, required this.childElement});
}
