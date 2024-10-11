import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
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
      appBar: appBarWithBackArrow(onPress: () {
        Navigator.pop(context);
      }),
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
            child: Column(
              children: [
                Expanded(
                    // Add jsonString from example assets file or json encoded String.
                    child: DynamicForm(jsonString,
                        childElementList: [],
                        dynamicFormKey: _formKeyNew,
                        finalSubmitCallBack: (int currentPage, Map<String, dynamic> data) async {
                  //Get all entered information on final or last form submit and redirect to another scree to display entered information
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(data: data)),
                  );
                },
                        currentStepCallBack: (
                            {int? currentIndex,
                            Map<String, dynamic>? formSubmitData,
                            Map<String, dynamic>? formInformation,
                            bool? isBack = false}) {
                  //This function return value when any current form submit and validated.
                  setState(() {
                    //Here currentIndex is a current displayed step index. its default value is zero.
                    currentPageIndex = currentIndex!;
                  });
                })),
                // Custom user buttons to move on next step or submit current form details
                Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.black,
                      maximumSize: Size(MediaQuery.of(context).size.width, 40),
                      minimumSize: Size(MediaQuery.of(context).size.width, 40),
                    ),
                    clipBehavior: Clip.hardEdge,
                    onPressed: () async {
                      //Call next step function to validate form and move next step of form
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
