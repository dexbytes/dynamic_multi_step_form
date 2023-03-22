//for Restaurant type dropdown
part of dynamic_json_form;

class DropDown extends StatefulWidget {
  final List<Options>? optionList;
  final String? hint;
  final bool autoValidate;
  final Map<String,dynamic> jsonData;
  final DropdownConfiguration? viewConfiguration;
  final Function (String fieldKey,List<String> fieldValue) onChangeValue ;

  const DropDown({Key? key,required this.jsonData,required this.onChangeValue,
    this.optionList = const [],
    this.hint,this.viewConfiguration, required this.autoValidate
  }) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState(optionList: this.optionList,jsonData: jsonData, autoValidate:autoValidate,onChangeValue: onChangeValue,viewConfiguration:viewConfiguration);
}

class _DropDownState extends State<DropDown> {
  String? valueChoose;
  String? buttonHead = "Select Item";
  List<Options>? optionList;
  DropDownModel? dropDownModel;
  Map<String, dynamic> jsonData;
  DropdownConfiguration? viewConfiguration;
  bool isMultipleSelect = false;
  bool isInline = false;
  String fieldKey = "";
  String label = "";
  bool enableLabel = true;
  String placeholder = "";
  String value = "";
  List<String>? selectedOption = [];
  bool autoValidate = false;

  Function (String fieldKey,List<String> fieldValue) onChangeValue ;
  _DropDownState(
      {required this.jsonData,this.optionList,required this.onChangeValue, this.autoValidate = false,this.viewConfiguration}) {
    dropDownModel ??= responseParser.dropDownFormFiledParsing(
        jsonData: jsonData, updateCommon: true);


    setValues(dropDownModel,jsonData);

  }

  @override
  void didUpdateWidget(oldWidget) {
    autoValidate = widget.autoValidate;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //ErrorMessage
    Widget errorMessage = (selectedOption != null && selectedOption!.isNotEmpty)?Container():
    Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 2),
      child: Text(dropDownModel!.validation!.errorMessage!.required.toString()??'',style: const TextStyle(color: Color(0xFFD32F2F),fontSize: 12),),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !enableLabel?const SizedBox(height: 0,):Row(
            children: [
              Text(label,style: viewConfiguration!._labelTextStyle,),
            ],
          ),SizedBox(height: enableLabel?5:0,),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              dropdownFullScreen:false,
              dropdownOverButton:false,
              hint: Row(
                children: [
                  /*Icon(
                    Icons.list,
                    size: 16,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 4,
                  ),*/
                  Expanded(
                    child: Text(
                      '$buttonHead',
                      style: viewConfiguration!._selectedTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: optionList!
                  .map((item) =>
                  DropdownMenuItem<String>(
                    value: "${item.value}",
                    child: Text(
                      item.displayValue!,
                      style: viewConfiguration!._textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                  .toList(),
              value: valueChoose,
              onChanged: (value) {
               onItemSelect(value);
              },
              icon: viewConfiguration!._rightArrow,
              iconSize: viewConfiguration!._iconSize,
              iconEnabledColor: viewConfiguration!._iconEnabledColor,
              iconDisabledColor: viewConfiguration!._iconDisabledColor,
              buttonHeight: viewConfiguration!._buttonHeight,
              // buttonWidth: viewConfiguration!._buttonWidth,
              buttonPadding: viewConfiguration!._buttonPadding,
              buttonDecoration: viewConfiguration!._buttonDecoration,
              buttonElevation: viewConfiguration!._buttonElevation!,
              itemHeight: viewConfiguration!._itemHeight,
              itemPadding: viewConfiguration!._itemPadding,
              dropdownMaxHeight: viewConfiguration!._dropdownMaxHeight,
              // dropdownWidth: viewConfiguration!._dropdownWidth,
              dropdownPadding: null,
              dropdownDecoration: viewConfiguration!._dropdownDecoration,
              dropdownElevation: viewConfiguration!._dropdownElevation!,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 1,
              scrollbarAlwaysShow: true,
              offset: const Offset(0, 0),
            ),
          ),
          const SizedBox(height: 5,),
          autoValidate ? errorMessage : Container()
        ],
      )

    );
  }

  DropdownMenuItemNew<String> buildMenuItem(Options option) {
    String value = option.value!;/*
    String item = option.displayValue!;
    bool isChecked = selectedOption!.contains(value)?true:option.checked!;*/

    return DropdownMenuItemNew(value: value,
        enabled: false,
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            DropdownRowItem(isMultipleSelect: isMultipleSelect,option: option, onClicked: (bool isChecked) {
              if(!isChecked){
                valueChoose = value;
                _onSelect(value: value);
              }
              else{
                _onUnSelect(value: value);
              }
              _returnValue();
             // _dropDownKey.currentState!.deactivate();
            }, selectedOption: selectedOption,),
            /*!isMultipleSelect?Container():TextButton(
              onPressed: () async {

              },
              child: const Text('Done'),
             // b: Colors.green,
            )*/
          ],
        )
    );
  }

  //Initial value set
  void setValues(DropDownModel? dropDownModel, Map<String, dynamic> jsonData) {

   viewConfiguration  = viewConfiguration ?? ConfigurationSetting.instance._dropdownConfiguration;

    if (dropDownModel != null) {
        try {
          enableLabel = jsonData['elementConfig']['enableLabel'];
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      if (dropDownModel.elementConfig != null) {
        fieldKey = dropDownModel.elementConfig!.name!;
        label = dropDownModel.elementConfig!.label!;
        placeholder = dropDownModel.elementConfig!.placeholder!;

        isMultipleSelect = dropDownModel.elementConfig!.isMultipleSelect??false;
        isInline = dropDownModel.elementConfig!.isInline??false;
        value = dropDownModel.value??"";

        if (dropDownModel.elementConfig!.options!.isNotEmpty) {
          optionList = dropDownModel.elementConfig!.options!.map((e) => Options(value: e.value,displayValue: e.displayValue,checked: e.checked)).toList();
          if(value.isNotEmpty){
            _onSelect(isInit: true,displayValue: value);
          }
        }
        onChangeValue.call(fieldKey,selectedOption!);
      }
    }
  }

  /*Call action when click on any item*/
  void _onSelect({bool isInit = false,String? value = "", String? displayValue = ""}){
    if(value!.trim().isNotEmpty && !selectedOption!.contains(value.trim())){
      //Remove older selected value in case multi selection off
      if(!isMultipleSelect){
        selectedOption = [];
      }
      selectedOption!.add(value.trim());
      if(isInit){
        valueChoose = value;
      }
      else {
        setState(() {
          valueChoose = value;
        });
      }
    }
    else if(displayValue!.trim().isNotEmpty ){
      int idTemp = optionList!.indexWhere((element) => element.displayValue==displayValue);
      if(idTemp!=-1){
        value = optionList![idTemp].value;
      }
      if(!selectedOption!.contains(value!.trim())){
        //Remove older selected value in case multi selection off
        if(!isMultipleSelect){
          selectedOption = [];
        }
        selectedOption!.add(value.trim());

        if(isInit){
          valueChoose = value;
        }
        else {
          setState(() {
            valueChoose = value;
          });
        }
      }
      else {
        try {
          if(isInit){
              buttonHead = displayValue;
          }
          else{
            setState(() {
              buttonHead = displayValue;
            });
          }

        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
    else{
      debugPrint("Please attlist one value");
    }
  }
  /*Call action when click on any item*/
  void _onUnSelect({String? value = "", String? displayValue = ""}){
    if(value!.trim().isNotEmpty && selectedOption!.contains(value.trim())){
      selectedOption!.remove(value.trim());
      setState(() {});
    }
    else if(displayValue!.trim().isNotEmpty){
      int idTemp = optionList!.indexWhere((element) => element.displayValue==displayValue);
      if(idTemp!=-1){
        value = optionList![idTemp].value;
      }
      if(selectedOption!.contains(value!.trim())) {
        selectedOption!.remove(value.trim());
        setState(() {});
      }
    }
    else{
      debugPrint("Please attlist one value");
    }
  }

  void _returnValue(){
    /*if(!isMultipleSelect){
      Navigator.pop(_dropDownKey.currentContext!);
      }*/
    onChangeValue.call(fieldKey,selectedOption!);
  }

  void onItemSelect(Object? value) {
    int index =  optionList!.indexWhere((element) => value as String == element.value);
    if(index!= -1){
      setState(() {
        Options indexData = optionList![index];
        valueChoose = indexData.value!;
      });
      String valueTemp = value as String;
      //if(!isChecked){
        _onSelect(value: valueTemp);
      /*}
      else{
        _onUnSelect(value: value as String);
      }*/
      _returnValue();
    }
  }
}


class Options {
  String? value;
  String? displayValue;
  bool? checked;

  Options({this.value, this.displayValue,this.checked = false});

  Options.fromJson(Map<String, dynamic> json) {
    value = json.containsKey('value')?json['value']:"";
    displayValue = json.containsKey('displayValue')?json['displayValue']:"";
    checked = json.containsKey('checked')?json['checked']:false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['displayValue'] = this.displayValue;
    data['checked'] = this.checked;
    return data;
  }
}

class DropdownRowItem extends StatefulWidget {
  final Options option;
  final Function(bool)? onClicked;
  final List<String>? selectedOption;
  final bool isMultipleSelect;

  const DropdownRowItem({Key? key,required this.option,required this.selectedOption,required this.onClicked,this.isMultipleSelect = false}) : super(key: key);

  @override
  _DropdownRowItemState createState() => _DropdownRowItemState(onClicked: onClicked,option: this.option, selectedOption: this.selectedOption);
}

class _DropdownRowItemState extends State<DropdownRowItem> {
  Function(bool)? onClicked;
  Options option;
  List<String>? selectedOption;
  String value = "";
  String item = "";
  bool isChecked = false;

  _DropdownRowItemState({required this.option,required this.selectedOption,required this.onClicked}){
    value = option.value!;
    item = option.displayValue!;
    isChecked = selectedOption!.contains(value)?true:option.checked!;
  }
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
  void didUpdateWidget(covariant DropdownRowItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.selectedOption != null) {
        // checkStatus = widget.checkStatus;
        selectedOption = widget.selectedOption;
        isChecked = selectedOption!.contains(value)?true:option.checked!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center,
        child:InkWell(onTap: (){
      if(mounted){
        setState(() {
          isChecked = !isChecked;
        });
      }
      onClicked?.call(!isChecked);
    },
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Align(alignment: Alignment.centerLeft,
              child: Text(
                item,
                //style: appStyles.hintTextStyle()
              ),
            ),
          ),
          /*!widget.isMultipleSelect?Container():Checkbox(value: isChecked, onChanged: (value){
            setState(() {
              isChecked = !isChecked;
            });
            onClicked?.call(!isChecked);
          })*/
        ],
      ),
    ));
  }
}