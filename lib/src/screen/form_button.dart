part of dynamic_json_form;

class FormButtonWidget extends StatefulWidget {
  final List<Options> optionList;
  final Map<String,dynamic> jsonData;
  final String label;
  final Function (String fieldKey,List<String> fieldValue) onChangeValue ;

  const FormButtonWidget({Key? key,required this.jsonData,required this.onChangeValue,this.label = "",
    this.optionList = const [],
  }) : super(key: key);

  @override
  _FormButtonWidgetState createState() => _FormButtonWidgetState(optionList: this.optionList,jsonData: jsonData,onChangeValue: onChangeValue);
}

class _FormButtonWidgetState extends State<FormButtonWidget> {
  List<Options> optionList = [];
  FormButtonModel? formButtonModel;
  Map<String, dynamic> jsonData;
  // FormButtonConfiguration? viewConfiguration;
  String fieldKey = "";
  String label = "";
  bool enableLabel = true;
  bool isVisible = true;
  String value = "";
  List<String>? selectedOption = [];
  Function (String fieldKey,List<String> fieldValue) onChangeValue ;
  Options _intialValue = Options();

  _FormButtonWidgetState({required this.jsonData,required this.optionList,required this.onChangeValue}) {
    formButtonModel ??= responseParser.formButtonParsing(jsonData: jsonData, updateCommon: true);
   setValues(formButtonModel,jsonData);

  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  //Initial value set
  void setValues(FormButtonModel? radioButtonModel, Map<String, dynamic> jsonData) {

    //viewConfiguration  = viewConfiguration ?? ConfigurationSetting.instance._checkBoxConfiguration;

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
        isVisible = radioButtonModel.elementConfig!.isVisible!;
        value = radioButtonModel.value??"";

      }
    }
  }

  @override
  Widget build(BuildContext context) {
 //   var checkBoxAlignment = viewConfiguration!._optionsAlign == LabelAndOptionsAlignment.horizontal?Axis.horizontal:Axis.vertical;

/*
    //Label
    Widget label =  Text(FormButtonModel!.elementConfig!.label??'',style: viewConfiguration!._labelTextStyle,  strutStyle: StrutStyle(),);

    //ErrorMessage
    Widget errorMessage = (selectedOption != null && selectedOption!.isNotEmpty)?Container():
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 2),
      child:Text(checkBoxModel!.validation!.errorMessage!.required.toString()??'',style: const TextStyle(color:  Color(0xFFD32F2F),fontSize: 12)),);
*/


    return !isVisible?const SizedBox():ElevatedButton(clipBehavior: Clip.hardEdge,
      onPressed: () async {
        onChangeValue.call(fieldKey,selectedOption!);
       /* if(_formKeyNew.currentState!.validateFields()){
          var data =  _formKeyNew.currentState!.getFormData();

          if(data!.isNotEmpty){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
            );
          }
        }*/
      },
      child: Text(widget.label.isNotEmpty?widget.label:label),
      //color: Colors.green,
    );
  }
}
