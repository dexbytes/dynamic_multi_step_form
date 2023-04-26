import 'dart:async';

import 'package:flutter/foundation.dart';

/// Register Stream controllers
class DataRefreshStream {
  DataRefreshStream._internal();

  static final DataRefreshStream instance = DataRefreshStream._internal();

  ///Message List Stream
  StreamController<List<dynamic>> _formFieldStreamController =
      StreamController<List<dynamic>>();

  StreamController<List<dynamic>> get getFormFieldsStream {
    _formFieldStreamController = StreamController<List<dynamic>>();
    return _formFieldStreamController;
  }

  ///Form filed refresh controller
  void formFieldsRefresh(List<dynamic> userData) {
    if (kDebugMode) {}
    _formFieldStreamController.sink.add(userData);
  }

  ///close controller
  void disposeMessageListStreamController() {
    _formFieldStreamController.close();
  }
}
