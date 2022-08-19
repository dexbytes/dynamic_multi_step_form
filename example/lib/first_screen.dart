import 'package:dynamic_multi_step_form/parts.dart';
import 'package:example/second_screen.dart';

class FirstScreen extends StatefulWidget {
  final String jsonString;
  final String apiCallingTime;
  const FirstScreen(
      {Key? key, required this.jsonString, this.apiCallingTime = ""})
      : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState(jsonString);
}

class _FirstScreenState extends State<FirstScreen> {
  final String jsonString;
  final _formKeyNew = GlobalKey<DynamicMultiStepFormScreenState>();

  _FirstScreenState(this.jsonString);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('First Screen'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: ListView(
          children: [
            Column(
              children: [
                Text(widget.apiCallingTime),

                //Get all fields of form
                DynamicMultiStepFormScreen(
                  jsonString,
                  dynamicFormKey: _formKeyNew,
                  finalSubmitCallBack: (Map<String, dynamic> data) async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen(data: data)),
                    );
                  },
                ),

                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    onPressed: () async {
                      if (_formKeyNew.currentState!.validateFields()) {
                        var data = _formKeyNew.currentState!.getFormData();
                        if (data!.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondScreen(data: data)),
                          );
                        }
                      }
                    },
                    child: const Text('Submit Form'),
                    //color: Colors.green,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
