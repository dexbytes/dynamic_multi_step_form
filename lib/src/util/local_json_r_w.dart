part of dynamic_json_form;

enum COMPONENT_TYPE {all,email}
class LocalJsonRw{
  String jsonFileAssetsPath = "assets/local_json/";

  Future<String> localRead({COMPONENT_TYPE componentType = COMPONENT_TYPE.all}) async {
    try {
     switch(componentType){
        case COMPONENT_TYPE.all:
          String jsonString = await rootBundle.loadString(jsonFileAssetsPath+"request_data.json");
          // jsonString = json.encode(jsonString);
          return jsonString;

        default :
          String jsonString = await rootBundle.loadString(jsonFileAssetsPath+"request_data.json");
          // jsonString = json.encode(jsonString);
          return jsonString;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "";
    }
  }

  Future<File> get _localFile async {
    return File(jsonFileAssetsPath+'request_data.json');
  }
  Future<bool> updateInfo({Map<String, dynamic> list = const {"name":"Dinesh"}}) async {
    // "list" is the updated book-list
    try {
      final file = await _localFile;
      String encodedData = jsonEncode(list);
      await file.writeAsString(encodedData);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return Future.value(true);
  }

}
final LocalJsonRw localJsonRw = LocalJsonRw();