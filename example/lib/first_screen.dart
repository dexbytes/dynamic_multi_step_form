import 'package:dynamic_multi_step_form/parts.dart';
import 'package:example/second_screen.dart';
import 'package:example/widget/appbar_with_back_arrow.dart';

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
  final _formKeyNew = GlobalKey<DynamicFormState>();
  int currentPageIndex = 0;

  _FirstScreenState(this.jsonString);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: appBarWithBackArrow(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Get all fields of form
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Upload KYC",
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child:
            Column(
              children: [
                Expanded(
                    child: DynamicForm(jsonString, dynamicFormKey: _formKeyNew,
                        finalSubmitCallBack:
                            (int currentPage, Map<String, dynamic> data) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(data: data)),
                  );
                }, currentStepCallBack: (
                            {int? currentIndex,
                            Map<String, dynamic>? formSubmitData,
                            Map<String, dynamic>? formInformation}) {
                  setState(() {
                    currentPageIndex = currentIndex!;
                  });
                }, submitButtonAlignment: Alignment.bottomCenter)),
                Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.black,
                      maximumSize: Size(MediaQuery.of(context).size.width, 45),
                      minimumSize: Size(MediaQuery.of(context).size.width, 45),
                    ),
                    clipBehavior: Clip.hardEdge,
                    onPressed: () async {
                      _formKeyNew.currentState!.nextStepCustomClick();
                    },
                    child: const Text('Next'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
