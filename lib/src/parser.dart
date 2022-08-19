import 'dart:convert';
import 'package:dynamic_multi_step_form/src/common_validation.dart';
import 'package:dynamic_multi_step_form/src/model/drop_down_field_model.dart';
import 'package:dynamic_multi_step_form/src/model/text_field_model.dart';
import 'package:flutter/foundation.dart';
import '../dynamic_multi_step_form.dart';
export 'model/text_field_model.dart';

class ResponseParser {
  /*This will display current displayed form page it will change when user change form by clicking next or preview*/
  static int _currentFormNumber = 0;
  get getCurrentFormNumber => _currentFormNumber;
  set setCurrentFormNumber(value) {
    _currentFormNumber = value;
  }

  static late final Map<String, FocusNode> _fieldFocusNode = {};
  Map<String, FocusNode> get getFieldFocusNode => _fieldFocusNode;
  set setFieldFocusNode(String fieldName) {
    _fieldFocusNode[fieldName] = FocusNode();
  }

  void clearFieldFocusNode() {
    _fieldFocusNode.clear();
  }

  /*This is formData will contain data according to form index*/
  static final Map<int, List<dynamic>> _formData = {};
  get getFormData => _formData;
  set setFormData(String jsonEncoded) {
    if (commonValidation.isValidJsonEncoded(jsonEncoded)) {
      Map<String, dynamic>? enteredJson = json.decode(jsonEncoded);
      if (enteredJson!["formType"].toString().isNotEmpty) {
        //Single form
        if (enteredJson["formType"] == "single") {
          _formData[0] = enteredJson["formFields"];
          _currentFormNumber = 0;
        }
        //Multi form
        else {
          _currentFormNumber = 0;
        }
        /*DataRefreshStream.instance.formFieldsRefresh(_formData[_currentFormNumber] as List<dynamic>);*/
      }
    }
  }

  resetAll() {
    setCurrentFormNumber = -1;
    clearFieldFocusNode();
  }

  TextFieldModel? textFormFiledParsing(
      {required Map<String, dynamic> jsonData, bool updateCommon = false}) {
    try {
      TextFieldModel textFieldModel = TextFieldModel.fromJson(jsonData);
      if (updateCommon) {}
      return textFieldModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  DropDownModel? dropDownFormFiledParsing(
      {required Map<String, dynamic> jsonData, bool updateCommon = false}) {
    try {
      DropDownModel dropDownModel = DropDownModel.fromJson(jsonData);
      if (updateCommon) {}
      return dropDownModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

ResponseParser responseParser = ResponseParser();
