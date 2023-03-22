import 'package:dynamic_multi_step_form/parts.dart';
import 'package:example/second_screen.dart';

class FirstScreen extends StatefulWidget {
 final String jsonString;
 final String apiCallingTime;
 const FirstScreen({Key? key,required this.jsonString,this.apiCallingTime = ""}) : super(key: key);

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
      appBar: AppBar(centerTitle: true,title: const Text('First Screen'),),
      body:
      Container(margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 20),
        child: Column(
          children: [
            //Get all fields of form
            Expanded(child:DynamicForm(jsonString,dynamicFormKey: _formKeyNew,
                finalSubmitCallBack: (int currentPage,Map<String, dynamic> data) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
                  );
                },
                currentStepCallBack:({int? currentIndex,Map<String,dynamic>? formSubmitData,Map<String,dynamic>? formInformation}){
              setState(() {
                print("$formInformation");
                currentPageIndex = currentIndex!;
              });
 },
           submitButtonAlignment:Alignment.bottomCenter)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              currentPageIndex>0?Align(alignment: Alignment.center,
              child: ElevatedButton(clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  _formKeyNew.currentState!.previewStepCustomClick();
                },
                child: const Text('Previous'),
              ),
            ):const SizedBox(),
              Align(alignment: Alignment.center,
              child: ElevatedButton(clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  _formKeyNew.currentState!.nextStepCustomClick();
                },
                child: const Text('Submit Form'),
              ),
            )],)
          ],
        ),
      ),

    );
  }
}
