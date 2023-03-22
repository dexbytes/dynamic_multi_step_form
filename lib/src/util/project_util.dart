import 'package:dynamic_multi_step_form/parts.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class PackageUtil {

  TextInputType keyBoardType({required String formFieldType}){
    TextInputType keyBoardType = TextInputType.text;
    switch(formFieldType){
      case 'text':
        keyBoardType = TextInputType.text;
        break ;
      case 'name':
        keyBoardType = TextInputType.name;
        break ;
      case 'email':
        keyBoardType = TextInputType.emailAddress;
        break ;
      case 'tel':
        keyBoardType = TextInputType.phone;
        break ;
      case 'url':
        keyBoardType = TextInputType.url;
        break ;
      case 'number':
        keyBoardType = TextInputType.number;
        break ;
      case 'text_multiline':
        keyBoardType = TextInputType.multiline;
        break ;
    }
    // keyBoardType = TextInputType.emailAddress;

    return keyBoardType;
  }

  String getText(String dateFormat,DateTime dateTime) {

    try {
      if (dateTime == null) {
            return 'Select Date';
          }
          else {
            if(dateFormat.isNotEmpty){
              return DateFormat(dateFormat).format(dateTime).toString();
            }
            return DateFormat('dd MMMM, yyyy').format(dateTime);
          }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Select Date';
    }
  }
}

PackageUtil packageUtil = PackageUtil();