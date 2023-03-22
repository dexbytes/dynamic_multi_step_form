part of dynamic_json_form;

class LocalStorage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static SharedPreferences? prefs;

  /*Get stored local form from device */
  Future<String>? getFormDataLocal() async{
    String?  formData = "";
    if(ConfigurationSetting.instance._loadFromApi){
return "";
    }
    try {
      prefs ??= await _prefs;
      formData = prefs!.getString("form_data_local")??"";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      formData = "";
    }
    return formData;
  }

  /*Store form data local device*/
  Future<String>? storeFormDataLocal(String formJson) async{
    String?  formData = "";
    try {
      prefs ??= await _prefs;
      bool?  formDataStored = await prefs!.setString("form_data_local", formJson);
      formData = formDataStored?formJson:"";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      formData = "";
    }
    return formData;
  }
}

LocalStorage localStorage = LocalStorage();