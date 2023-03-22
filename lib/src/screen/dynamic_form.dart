part of dynamic_json_form;

class DynamicForm extends StatefulWidget {
final String jsonEncoded;
final Function(int currentFormNumber,Map<String,dynamic> data)? finalSubmitCallBack;
final Function({int currentIndex,Map<String,dynamic>? formSubmitData,Map<String,dynamic>? formInformation})? currentStepCallBack;
final GlobalKey<DynamicFormState>? dynamicFormKey ;
final Alignment? submitButtonAlignment;
final EdgeInsetsGeometry? formPadding;
final EdgeInsetsGeometry? formIndicatorPadding;

const DynamicForm(this.jsonEncoded,{this.submitButtonAlignment,this.dynamicFormKey,required this.finalSubmitCallBack,this.currentStepCallBack,this.formPadding = const EdgeInsets.only(left: 15,right: 15),this.formIndicatorPadding = const EdgeInsets.only(left: 0,right: 0,bottom: 15,top: 15)}) : super(key: dynamicFormKey);
  @override
  DynamicFormState createState() => DynamicFormState(jsonEncoded: jsonEncoded);
}

class DynamicFormState extends State<DynamicForm> {
  String jsonEncoded;
  Stream get onVariableChanged => DataRefreshStream.instance.getFormFieldsStream.stream;
  Map<String,dynamic> formSubmitData = <String,dynamic>{};
  Map<int,dynamic> formScreenList = {};
  List<SingleForm> formScreen = [];

  DynamicFormState({required this.jsonEncoded}){
    responseParser.setFormData = jsonEncoded;
    formScreenList = responseParser.getFormData;
    int currentIndex = -1;
    formScreen =
        formScreenList.entries.map( (entry) {
          currentIndex += 1;
          final _formKeyNew = GlobalKey<SingleFormState>();
           return SingleForm(singleFormKey: _formKeyNew,formData:entry.value, nextPageButtonClick:(index,Map<String,dynamic> formSubmitData){
            this.formSubmitData ['$currentIndex'] = formSubmitData;
            widget.currentStepCallBack?.call(currentIndex:currentIndex,formSubmitData:formSubmitData);
            setState(() {
            });
          }, finalSubmitCallBack:(index,Map<String,dynamic> formSubmitData){
                this.formSubmitData ['$currentIndex'] = formSubmitData;
                widget.finalSubmitCallBack?.call(index,this.formSubmitData);
              });
        }
            ).toList();
  }
  //Next step button click event
  void nextStepCustomClick(){
    int currentPage = responseParser.getCurrentFormNumber;

    if (responseParser.getTotalFormsCount-1 >
        responseParser.getCurrentFormNumber) {
      if (formScreen[currentPage].singleFormKey!.currentState!.validateFields()) {
        Map<String,dynamic>? data = formScreen[currentPage].singleFormKey!.currentState!.getFormData();
        Map<String,dynamic>? formInformation = formScreen[currentPage].singleFormKey!.currentState!.formInformation;
        formSubmitData ['$currentPage'] = data;
        widget.currentStepCallBack?.call(currentIndex:currentPage+1,formSubmitData:data,formInformation:formInformation);

        if (data!.isNotEmpty) {
          setState(() {
            responseParser.setCurrentFormNumber =
                responseParser.getCurrentFormNumber +
                    1;
          });
        }
      }
    }
    else {
      if (formScreen[currentPage].singleFormKey!.currentState!.validateFields()) {
        Map<String,dynamic>? data = formScreen[currentPage].singleFormKey!.currentState!.getFormData();
        Map<String,dynamic>? formInformation = formScreen[currentPage].singleFormKey!.currentState!.formInformation;
        formSubmitData ['$currentPage'] = data;
        widget.currentStepCallBack?.call(currentIndex:currentPage+1,formSubmitData:data,formInformation:formInformation);
        if (data!.isNotEmpty) {
         widget.finalSubmitCallBack?.call(responseParser.getCurrentFormNumber,formSubmitData);
        }
      }
    }
  }

  //Preview step button click event
  void previewStepCustomClick(){
    Map<String,dynamic>? data = formScreen[responseParser.getCurrentFormNumber].singleFormKey!.currentState!.getFormData();
    Map<String,dynamic>? formInformation = formScreen[responseParser.getCurrentFormNumber].singleFormKey!.currentState!.formInformation;
    if (responseParser.getCurrentFormNumber > 0) {
      setState(() {
        responseParser.setCurrentFormNumber =
            responseParser.getCurrentFormNumber - 1;
      });
    }
    widget.currentStepCallBack?.call(currentIndex:responseParser.getCurrentFormNumber,formSubmitData:data,formInformation:formInformation);
  }

  Widget formStepIndicator(){
    int count = responseParser.getTotalFormsCount;
    int currentPage = responseParser.getCurrentFormNumber;
    return count>1?Padding(padding: widget.formIndicatorPadding!,child: StepProgressIndicator(
      totalSteps: count,
      currentStep: currentPage,
      selectedColor: Colors.green,
      unselectedColor: Colors.grey,
    ),):const SizedBox(height: 0,);
  }
  @override
  Widget build(BuildContext context) {
   
    return Material(
      child: !commonValidation.isValidJsonEncoded(jsonEncoded)?Container():
      Column(mainAxisSize: MainAxisSize.min,children: [
        formStepIndicator(),
      Flexible(child:
      ListView.builder(shrinkWrap: true,padding: widget.formPadding!,
          physics: const ClampingScrollPhysics(),
          itemCount: formScreen.length,
          itemBuilder: (BuildContext context, int index) {
            if(responseParser.getCurrentFormNumber!=index){
              return const SizedBox(height: 0,);
            }
            return formScreen[index];
          })),
        // formScreen[selectedPageIndex].singleFormKey!=null && formScreen[selectedPageIndex].singleFormKey!.currentState!=null && formScreen[selectedPageIndex].singleFormKey!.currentState!.formSubmitButton!=null?formScreen[selectedPageIndex].singleFormKey!.currentState!.formSubmitButton!:const SizedBox(height:0),
      ],),
    );
  }
}



