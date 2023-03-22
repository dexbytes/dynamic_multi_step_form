import 'dart:convert';
import 'package:flutter/foundation.dart';


class CommonValidation {

  //Check is entered json is not empty and correct format
  bool isValidJsonEncoded(String jsonEncoded){
    bool isValidate = false;
    if(jsonEncoded.isNotEmpty){
      try {
     // var enteredJsonN = json.decode(jsonEncoded);
        Map<String,dynamic>? enteredJson = json.decode(jsonEncoded);
        if(enteredJson!.isNotEmpty){
                if(enteredJson.containsKey("formType") && enteredJson.containsKey("step") && enteredJson["step"].isNotEmpty){
                  isValidate = true;
                }
              }
      } catch (e) {
        debugPrint("$e");
      }
    }
    return isValidate;
  }

  //Check all field validation
  String? checkValidation({required String enteredValue,required Map<String, dynamic> validationStr,required String formFieldType, isPickFromCalendar}){
    String? errorMsg;
    switch(formFieldType){
      case 'text':
       return errorMsg = isValidText(enteredValue,validationStr);

      case 'password':
        return errorMsg = isValidPassword(enteredValue,validationStr);

      case 'name':
       return errorMsg = isValidName(enteredValue,validationStr);

      case 'email':
        return errorMsg = isValidEmail(enteredValue,validationStr);

      case 'tel':
        return errorMsg = isValidTel(enteredValue,validationStr);

      case 'url':
        return errorMsg = isValidUrl(enteredValue,validationStr);

      case 'number':
        return errorMsg = isValidNumber(enteredValue,validationStr);

        case 'date':
          return errorMsg = validateDate(enteredValue,validationStr,isPickFromCalendar:isPickFromCalendar);

      case 'text_multiline':
        return errorMsg = isValidEmail(enteredValue,validationStr);

    }
  }

  //Text validation
  String? isValidText(String value,Map<String, dynamic> validationStr){


    String? errorMsg;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      /*int minLine = 1;
    int maxLine = 20;*/

      bool required = validation.containsKey('required')?validation['required']: false;
      int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
      int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //Email validation
  String? isValidEmail(String value,Map<String, dynamic> validationStr){

    String? errorMsg ;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      bool isEmail = validation.containsKey('isEmail')?validation['isEmail']: false;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else if(isEmail && rejex.trim().isEmpty){
        rejex = r"^([^\.]+[a-zA-Z0-9.a-zA-Z0-9.!$%&'*+-/=?^_`{|}~!]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+[^\.-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$";
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //Password validation
  String? isValidPassword(String value,Map<String, dynamic> validationStr){
    String? errorMsg ;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

    int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
    int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
    String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
         errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //name validation
  String? isValidName(String value,Map<String, dynamic> validationStr){

    String? errorMsg ;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      /*int minLine = 1;
    int maxLine = 20;*/

      bool required = validation.containsKey('required')?validation['required']: false;
      int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
      int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //telephone validation
  String? isValidTel(String value,Map<String, dynamic> validationStr){

    String? errorMsg ;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
      int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }


  //Url validation
  String? isValidUrl(String value,Map<String, dynamic> validationStr){

    String? errorMsg;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      /*int minLine = 1;
    int maxLine = 20;*/

      bool required = validation.containsKey('required')?validation['required']: false;
      int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
      int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //Number validation
  String? isValidNumber(String value,Map<String, dynamic> validationStr){

    String? errorMsg;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      /*int minLine = 1;
    int maxLine = 20;*/

      bool required = validation.containsKey('required')?validation['required']: false;
      int minLength = validation.containsKey('minLength')?validation['minLength']: 1;
      int maxLength = validation.containsKey('maxLength')?validation['maxLength']: 2;
      String rejex = validation.containsKey('rejex')?validation['rejex']:"";

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else if(value.length > maxLength){
        errorMsg = errorMessage.containsKey('maxLength')?errorMessage['maxLength']:"maxLength key missing";
      }
      else if(value.length < minLength){
        errorMsg = errorMessage.containsKey('minLength')?errorMessage['minLength']:"minLength key missing";
      }
      else if(rejex.trim().isNotEmpty){
        RegExp regex = RegExp(rejex.trim());
        bool isMatched = regex.hasMatch(value);
        errorMsg = isMatched?null: errorMsg = errorMessage.containsKey('rejex')?errorMessage['rejex']:"rejex key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //method to calculate age on Today (in years)
  int ageCalculate(String dateFormat, String input) {
    if(dateFormat != null && (dateFormat == "dd.mm.yyyy" || dateFormat == "dd/mm/yyyy" || dateFormat == "dd-mm-yyyy" )){
      // regex for validation of date format : dd.mm.yyyy, dd/mm/yyyy, dd-mm-yyyy
      RegExp regExp =  RegExp(
        r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$",
        caseSensitive: true,
        multiLine: false,
      );

      if (regExp.hasMatch(input)) {
        DateTime _dateTime = DateTime(
          int.parse(input.substring(6)),
          int.parse(input.substring(3, 5)),
          int.parse(input.substring(0, 2)),
        );
        return DateTime
            .fromMillisecondsSinceEpoch(
            DateTime
                .now()
                .difference(_dateTime)
                .inMilliseconds)
            .year -
            1970;
      }
    }
    else if( dateFormat == "mm.dd.yyyy" || dateFormat == "mm/dd/yyyy" || dateFormat == "mm-dd-yyyy" ){
      // regex for validation of date format : mm.dd.yyyy, mm/dd/yyyy, mm-dd-yyyy
      RegExp regExp =  RegExp(
        r"(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)[0-9]{2}",
        caseSensitive: true,
        multiLine: false,
      );

      if (regExp.hasMatch(input)) {
        DateTime _dateTime = DateTime(
          int.parse(input.substring(6)),
          int.parse(input.substring(0, 2)),
          int.parse(input.substring(3, 5)),
        );
        return DateTime
            .fromMillisecondsSinceEpoch(
            DateTime
                .now()
                .difference(_dateTime)
                .inMilliseconds)
            .year -
            1970;
      }
    }
    else if(dateFormat != null && (dateFormat == "yyyy-MM-dd")){
      // regex for validation of date format : yyyy-MM-dd
      RegExp regExp =  RegExp(
        r"((?:19|20)\\d\\d)-(0?[1-9]|1[012])-([12][0-9]|3[01]|0?[1-9])",
        caseSensitive: true,
        multiLine: false,
      );

      if (regExp.hasMatch(input)) {
        DateTime _dateTime = DateTime(
          int.parse(input.substring(0,5)),
          int.parse(input.substring(0, 2)),
          int.parse(input.substring(3, 5)),
        );
        return DateTime
            .fromMillisecondsSinceEpoch(
            DateTime
                .now()
                .difference(_dateTime)
                .inMilliseconds)
            .year -
            1970;
      }
    }
    else {
      return -1;
    }
    return -1;
  }

  //Number validation
  String? validateDate(String value,Map<String, dynamic> validationStr,{isPickFromCalendar, dateFormat}){
    String? errorMsg;
    try {
      Map<String,dynamic> validation = validationStr;
      Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};

      bool required = validation.containsKey('required')?validation['required']: false;
      int minAge = validation.containsKey('minAge')?validation['minAge']: -1;

      if(value.trim().isEmpty){
        errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
      }
      else{
        errorMsg = null;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return errorMsg;
  }

  //Number validation
  // String? validateDate(String value,Map<String, dynamic> validationStr,{isPickFromCalendar, dateFormat}){
  //   String? errorMsg;
  //   try {
  //     Map<String,dynamic> validation = validationStr;
  //     Map<String,dynamic> errorMessage = validation.containsKey('errorMessage')?validation['errorMessage']:<String,dynamic>{};
  //
  //     bool required = validation.containsKey('required')?validation['required']: false;
  //     int minAge = validation.containsKey('minAge')?validation['minAge']: -1;
  //
  //     if(value.trim().isEmpty){
  //       errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
  //     }
  //     if(value.trim().isNotEmpty){
  //       if(minAge != null && minAge != -1){
  //         int age = ageCalculate(dateFormat,value);
  //         if(age < minAge){
  //           errorMsg = errorMessage.containsKey('required')?errorMessage['required']:"required key missing";
  //         }
  //       }
  //     }
  //     else{
  //       errorMsg = null;
  //     }
  //   }
  //   catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   return errorMsg;
  // }

  //get time from timestamp
  DateTime getTimeFromTimeStamp({required dateTimeStamp,DateTime? date}){
    DateTime tempDate = date??DateTime.now();
    if(dateTimeStamp != null && dateTimeStamp.toString().trim().isNotEmpty){
      try {
        tempDate = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTimeStamp) * 1000);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
       // return tempDate;
      }
    }
    return tempDate;
  }

}

CommonValidation commonValidation = CommonValidation();