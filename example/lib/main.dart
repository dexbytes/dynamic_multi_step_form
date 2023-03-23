import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:dynamic_multi_step_form/parts.dart';
import 'package:example/first_screen.dart';
import 'package:example/time_duration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() async {
  // if you are using await in main function then add this line
  WidgetsFlutterBinding.ensureInitialized();
  // Restrict for portrait mode only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //Custom local configuration for Input field setup
  TextFieldConfiguration textFieldConfiguration = TextFieldConfiguration(
      cursorColor: Colors.black,
      suffixIconColor: Colors.black,
      fillColor: Color(0xFFE1EFE7),
      textStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
      //contentPadding: const EdgeInsets.all(8),
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Colors.transparent,
          ) //BorderSide
          ),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Colors.grey,
          ) //BorderSide
          ));

  //textFieldConfiguration.setBorder = const UnderlineInputBorder();
  ConfigurationSetting.instance.setTextFieldViewConfig = textFieldConfiguration;

  //Custom local configuration for tel Input field setup
  TelTextFieldConfiguration telTextFieldConfiguration =
      TelTextFieldConfiguration(
          cursorColor: Colors.yellow,
          suffixIconColor: Colors.black,
          fillColor: Color(0xFFE1EFE7),
          hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
          filled: true,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: Colors.transparent,
              ) //BorderSide
              ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: Colors.grey,
              ) //BorderSide
              ));
  //telTextFieldConfiguration.setBorder = const UnderlineInputBorder();
  ConfigurationSetting.instance.setTelTextFieldViewConfig =
      telTextFieldConfiguration;

  RadioButtonConfiguration radioButtonConfiguration = RadioButtonConfiguration(
    labelAndRadioButtonAlign: LabelAndOptionsAlignment.vertical,
    radioButtonsAlign: LabelAndOptionsAlignment.vertical,
    labelTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
    optionTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
  );
  ConfigurationSetting.instance.setRadioButtonConfiguration =
      radioButtonConfiguration;

  CheckBoxConfiguration checkBoxConfiguration = CheckBoxConfiguration(
    labelAndRadioButtonAlign: LabelAndOptionsAlignment.vertical,
    optionsAlign: LabelAndOptionsAlignment.vertical,
    labelTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
    optionTextStyle: TextStyle(
      color: Colors.grey.shade800,
      fontSize: 14,
    ),
  );
  ConfigurationSetting.instance.setCheckBoxConfiguration =
      checkBoxConfiguration;

  //Set load form from json
  ConfigurationSetting.instance.setLoadFromApi = true;

  String? jsonString = "";
  runApp(MyApp(jsonString:jsonString));
}

class MyApp extends StatelessWidget {
  final String jsonString;

  const MyApp({this.jsonString = ""});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Multi Step Form',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyForm(jsonString:jsonString),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyForm extends StatefulWidget {
  final String jsonString ;

  const MyForm({this.jsonString = ""});

  @override
  _MyFormState createState() => _MyFormState(jsonString);
}

class _MyFormState extends State<MyForm> {
  String jsonString = "";
  bool isLoading = false;

  _MyFormState(this.jsonString) {
    if (kDebugMode) {
      print("$jsonString");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Dynamic Multi Step Form'),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              isLoading
                  ? Container()
                  : SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            child: Text(
                                !ConfigurationSetting.instance.getLoadFromApi
                                    ? "Switch to always from API"
                                    : "Switch to always from local"),
                            onPressed: () async {
                              setState(() {
                                ConfigurationSetting.instance.setLoadFromApi =
                                    !ConfigurationSetting
                                        .instance.getLoadFromApi;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          OutlinedButton(
                            child: const Text("Get Data"),
                            onPressed: () async {
                              timeDuration.startTimeDuration();
                              setState(() {
                                isLoading = true;
                              });
                              //get data which is stored in shared prefernce
                              String? jsonString = await ConfigurationSetting
                                  .instance
                                  .getFormDataLocal();
                              //if(jsonString!.isEmpty) {
                              // Comment this while get data from local json
                              //  String jsonStringResponse = await httpService.getPosts();

                              //== Uncomment while get data from local json
                              String jsonStringResponse =
                                  await localJsonRw.localRead();

                              jsonString = await ConfigurationSetting.instance
                                  .storeFormDataLocal(jsonStringResponse);
                              // }
                              setState(() {
                                isLoading = false;
                              });
                              String time = timeDuration.endTime(
                                  message: "Api calling", reset: true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstScreen(
                                          jsonString: jsonString!,
                                          apiCallingTime: time,
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
              isLoading
                  ? const SizedBox(
                      height: 50, width: 50, child: CircularProgressIndicator())
                  : Container()
            ],
          ),
        ));
  }
}
