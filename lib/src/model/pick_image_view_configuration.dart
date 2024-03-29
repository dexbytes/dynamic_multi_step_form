part of dynamic_multi_step_form;

//enum LabelAndOptionsAlignment{vertical, horizontal}
/// CheckBoxConfiguration model
class PickImageViewConfiguration {
  Size imagePreviewSize = Size(double.infinity, 170);
  BorderRadiusGeometry? borderRadius = BorderRadius.circular(8.0);

  Widget? bottomSheetCloser = Row(
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

  Widget? bottomSheetTopTitle = Text(
    "Select option",
    style: TextStyle(
        fontSize: 18,
        color: const Color(0xff090C30),
        fontWeight: FontWeight.w600),
  );

  Widget? bottomSheetCameraRow = Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(Icons.camera_alt),
        SizedBox(
          width: 10,
        ),
        Text(
          "Take a Photo",
          style: TextStyle(
              fontSize: 16,
              color: const Color(0xff090C30),
              fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
  Widget? bottomSheetGalleryRow = Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(Icons.image),
        SizedBox(
          width: 10,
        ),
        Text(
          "Select option",
          style: TextStyle(
              fontSize: 16,
              color: const Color(0xff090C30),
              fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  Widget? emptyImgView = Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffAEAEAE)),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Icon(
        Icons.upload,
        size: 70.0,
      ));

  Widget? editImgView = Align(
    alignment: Alignment.topRight,
    child: Container(
        alignment: Alignment.center,
        height: 25,
        width: 25,
        margin: EdgeInsets.only(right: 8, top: 6),
        padding: EdgeInsets.all(0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade700),
        child: Icon(
          Icons.close,
          size: 18.0,
          color: Colors.white,
        )),
  );

  PickImageViewConfiguration(
      {Widget? emptyImgView,
      Size? imagePreviewSize,
      Widget? editImgView,
      Widget? bottomSheetGalleryRow,
      Widget? bottomSheetTopTitle,
      Widget? bottomSheetCameraRow,
      BorderRadiusGeometry? borderRadius}) {
    this.imagePreviewSize = imagePreviewSize ?? this.imagePreviewSize;
    this.emptyImgView = emptyImgView ?? this.emptyImgView;
    this.editImgView = editImgView ?? this.editImgView;
    this.borderRadius = borderRadius ?? this.borderRadius;
    this.bottomSheetGalleryRow =
        bottomSheetGalleryRow ?? this.bottomSheetGalleryRow;
    this.bottomSheetCameraRow =
        bottomSheetCameraRow ?? this.bottomSheetCameraRow;
    this.bottomSheetTopTitle = bottomSheetTopTitle ?? this.bottomSheetTopTitle;
  }
}

PickImageViewConfiguration pickImageViewConfiguration =
    PickImageViewConfiguration();
