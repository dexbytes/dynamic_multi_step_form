import 'dart:convert';
import 'package:dynamic_multi_step_form/src/common_validation.dart';
import 'package:dynamic_multi_step_form/src/model/drop_down_field_model.dart';
import 'package:dynamic_multi_step_form/src/model/form_button_model.dart';
import 'package:dynamic_multi_step_form/src/model/text_field_model.dart';
import 'package:flutter/foundation.dart';
import '../dynamic_json_form.dart';
import 'model/checkbox_model.dart';
import 'model/radio_button_model.dart';
export 'model/text_field_model.dart';

class ResponseParser{
  /*This will display current displayed form page it will change when user change form by clicking next or preview*/
  static int _currentFormNumber = 0;
  static int totalFormsCount = 1;
  get getCurrentFormNumber => _currentFormNumber;
  set setCurrentFormNumber(value){
    _currentFormNumber = value;
  }

  static late Map<String,FocusNode> _fieldFocusNode = {};
  Map<String,FocusNode> get getFieldFocusNode => _fieldFocusNode;
  set setFieldFocusNode (String fieldName){
    _fieldFocusNode[fieldName] = FocusNode();
  }
  void clearFieldFocusNode (){
    _fieldFocusNode.clear();
  }

  /*This is formData will contain data according to form index*/
  // static final Map<int,List<dynamic>> _formData = {};
  static final Map<int,dynamic> _formData = {};
  get getFormData => _formData;
  get getTotalFormsCount => totalFormsCount;
  set setFormData(String jsonEncoded){
    if(commonValidation.isValidJsonEncoded(jsonEncoded)){
      Map<String,dynamic>? enteredJson = json.decode(jsonEncoded);
      if(enteredJson!["formType"].toString().isNotEmpty){
        //Single form
        if(enteredJson["formType"]=="single"){
          // _formData[0] = enteredJson["formFields"];
          _formData[0] = enteredJson;
          _currentFormNumber = 0;
        }
        //Multi form
        else{
          Map<String,dynamic>? enteredJsonMap = enteredJson["step"];
          int count = 0;
          totalFormsCount = count;
          enteredJsonMap!.forEach((key, value) {
            // _formData[count] = value["formFields"];
            _formData[count] = value;
            count = count+1;
            totalFormsCount = count;
          });
          _currentFormNumber = 0;
        }
        /*DataRefreshStream.instance.formFieldsRefresh(_formData[_currentFormNumber] as List<dynamic>);*/
      }

    }
  }
  resetAll(){
    setCurrentFormNumber = -1;
    clearFieldFocusNode();
  }

  TextFieldModel? textFormFiledParsing({required Map<String,dynamic> jsonData,bool updateCommon = false}){
    try {
      TextFieldModel textFieldModel = TextFieldModel.fromJson(jsonData);
      if(updateCommon){

          }
      return textFieldModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  DropDownModel? dropDownFormFiledParsing({required Map<String,dynamic> jsonData,bool updateCommon = false}){
    try {
      DropDownModel dropDownModel = DropDownModel.fromJson(jsonData);
      if(updateCommon){

          }
      return dropDownModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  RadioButtonModel? radioButtonFormFiledParsing({required Map<String,dynamic> jsonData,bool updateCommon = false}){
    try {
      RadioButtonModel radioButtonModel = RadioButtonModel.fromJson(jsonData);
      if(updateCommon){

          }
      return radioButtonModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  CheckboxModel? checkBoxFormFiledParsing({required Map<String,dynamic> jsonData,bool updateCommon = false}){
    try {
      CheckboxModel checkBoxModel = CheckboxModel.fromJson(jsonData);
      if(updateCommon){

          }
      return checkBoxModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  FormButtonModel? formButtonParsing({required Map<String,dynamic> jsonData,bool updateCommon = false}){
    try {
      FormButtonModel formButtonModel = FormButtonModel.fromJson(jsonData);
      if(updateCommon){

          }
      return formButtonModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

ResponseParser responseParser = ResponseParser();