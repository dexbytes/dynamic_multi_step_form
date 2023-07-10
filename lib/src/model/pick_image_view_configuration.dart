part of dynamic_multi_step_form;

//enum LabelAndOptionsAlignment{vertical, horizontal}
/// CheckBoxConfiguration model
class PickImageViewConfiguration {
  //Label style
  late TextStyle _labelTextStyle = const TextStyle();

  BorderRadiusGeometry? borderRadius = BorderRadius.circular(8.0);

  Widget? bottomSheetCloser =   Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        width: 50,
        child: Divider(
          color: Colors.grey,
          //height: 10,
          thickness: 4,
          indent: 1,
          endIndent: 1,
        ),
      ),
    ],
  );

 Widget? emptyImgView = Container(width: double.infinity,height: 100,decoration: BoxDecoration(
     border: Border.all(color: Color(0xffAEAEAE)),
     borderRadius: BorderRadius.all(Radius.circular(5))),
     padding:
     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
     child: Icon(Icons.upload,size: 70.0,));

 Widget? editImgView = Align(alignment: Alignment.topRight,
   child: Container(padding:
       EdgeInsets.symmetric(horizontal: 5, vertical: 5),
       child: Icon(Icons.close,size: 35.0,)),
 );

  PickImageViewConfiguration({ Widget? emptyImgView, Widget? editImgView,BorderRadiusGeometry? borderRadius}){
    this.emptyImgView = emptyImgView??this.emptyImgView;
    this.editImgView = emptyImgView??this.editImgView;
    this.borderRadius = borderRadius??this.borderRadius;
  }
}

PickImageViewConfiguration pickImageViewConfiguration = PickImageViewConfiguration();
