part of dynamic_multi_step_form;

// enum formFieldType {text,name,email,tel,url,number,textMultiline}
/// Custom TextField view
class UploadImageView extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final String? nextFieldKey;
  final PickImageViewConfiguration? viewConfiguration;
  final Function(String fieldKey, String fieldValue) onChangeValue;

  const UploadImageView(
      {Key? key,
      required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""})
      : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState(
      jsonData: jsonData,
      onChangeValue: onChangeValue,
      viewConfiguration: viewConfiguration,
      nextFieldKey: nextFieldKey);
}

class _UploadImageState extends State<UploadImageView> {
  String fieldKey = "upload_img";
  String? label = "";
  String? nextFieldKey = "";

  Map<String, dynamic> jsonData;
  ConfigurationSetting configurationSetting = ConfigurationSetting.instance;
  PickImageViewConfiguration? viewConfiguration;
  Function(String fieldKey, String fieldValue) onChangeValue;
  final StreamController<bool> _fieldStreamControl = StreamController<bool>();

  Stream get onVariableChanged => _fieldStreamControl.stream;
  double fieldHeight = 170;
  double emptyViewHeight = 170;
  double fieldWidth = double.infinity;
  String? imagePath;
  UploadImageModel? uploadFormFiledParsing;
  _UploadImageState(
      {required this.jsonData,
      required this.onChangeValue,
      this.viewConfiguration,
      this.nextFieldKey = ""}) {
    viewConfiguration = viewConfiguration ??
        ConfigurationSetting.instance._pickImageViewConfiguration;

     fieldHeight = viewConfiguration!.imagePreviewSize.height;
     fieldWidth = viewConfiguration!.imagePreviewSize.width;

    uploadFormFiledParsing ??= responseParser.uploadFormFiledParsing(
        jsonData: jsonData, updateCommon: true);


    if(uploadFormFiledParsing!=null){
      fieldKey = uploadFormFiledParsing!.elementConfig!.name!;
      label = uploadFormFiledParsing!.elementConfig!.label!;
      imagePath =  uploadFormFiledParsing!.value;
      if(imagePath!=null && imagePath!.trim().isNotEmpty){
        try {
          onChangeValue.call(fieldKey, imagePath!);
        } catch (e) {
          print(e);
        }
      }
      else{
        imagePath = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fieldStreamControl.close();
    super.dispose();
  }

  VerticalDirection fieldHelpPosition() {
    /* if (textFieldModel!.help != null && textFieldModel!.help!.text!.isEmpty) {
      return VerticalDirection.up;
    }*/
    return VerticalDirection.down;
  }

  ///for ios done button callback
  onPressCallback() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (mounted) {
      setState(() {});
    }
  }

  Widget imageView(String? filePath) {
    if (filePath == null || filePath.trim().isEmpty) {
      return SizedBox();
    }
    if (imagePath!.contains("http")) {
      return CachedNetworkImage(
          height: fieldHeight,
          width: fieldWidth,
          imageUrl: imagePath!,
          imageBuilder: (context, imageProvider) => InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      value: downloadProgress.progress,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
          errorWidget: (context, url, error) {
            setState(() {
              imagePath = null;
            });
            return Container();
          });
    } else if (!imagePath!.contains("http")) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        width: fieldWidth,
        height: fieldHeight,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          // setState(() {
            imagePath = null;
          // });
          return const Center(child: Text('This image type is not supported'));
        },
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Check if data not pars properly
    if (fieldKey.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }

    // if (formFieldType == "date") {
    //   isPickFromCalendar = textFieldModel!.elementConfig!.pickDateFromCalender??true;
    // }
    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: fieldHelpPosition(),
      children: [
        // fieldHelpText(),
        SizedBox(height: 20,),
        label!=null && label!.trim().isNotEmpty?Padding(
          padding: const EdgeInsets.only(bottom: 11,left: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label!,style: TextStyle( fontSize: 16,
                  color: const Color(0xff222222),
                  fontWeight: FontWeight.w400),),
            ],
          ),
        ):SizedBox(),
        SizedBox(
            child: imagePath == null || imagePath!.trim().isEmpty? InkWell(
    onTap: () {
    displayProductDetailModal(context);
    },
    child: Container(
    padding: EdgeInsets.all(4),
    child: viewConfiguration!.emptyImgView),
    )
               :ClipRRect(
                borderRadius: viewConfiguration!.borderRadius,
                child: Stack(
                   children: [
                     imageView(imagePath),
                     InkWell(
                       onTap: () {
                         setState(() {
                           imagePath = null;
                         });
                         onChangeValue.call(fieldKey, "");
                       },
                       child: viewConfiguration!.editImgView,
                     )
                   ],
                 ),
               ),
            ),
      ],
    );
  }

  void actionOnClick(String clickFor) async {
    if (clickFor.toLowerCase() == "camera") {
      // Capture a photo.
      List<Media>? photo = await ImagesPicker.openCamera(
        // pickType: PickType.video,
        pickType: PickType.image,
        quality: 0.8,
        maxSize: 800,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.wh16x9,
        ),
        maxTime: 15,
      );
      if (photo != null && photo.isNotEmpty) {
        setState(() {
          imagePath = photo[0].path;
        });
        onChangeValue.call(fieldKey, imagePath!);
      }
    } else if (clickFor.toLowerCase() == "gallery") {
      // Pick an image.
      List<Media>? photo = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.all,
        language: Language.System,
        maxTime: 30,
        // maxSize: 500,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.wh16x9,
        ),
      );
      if (photo != null && photo.isNotEmpty) {
        setState(() {
          imagePath = photo[0].path;
        });
        onChangeValue.call(fieldKey, imagePath!);
      }
    }
  }

  void displayProductDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext buildContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 10,bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Container(
                 child: InkWell(
                     highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(buildContext);
                      },
                      child: viewConfiguration!.bottomSheetCloser),
               ),
            viewConfiguration!.bottomSheetTopTitle!,
                SizedBox(height: 25,),
               Column(children: [
                 InkWell(
                     onTap: () {
                       actionOnClick("camera");
                       Navigator.pop(buildContext);
                     },
                     child: viewConfiguration!.bottomSheetCameraRow),
                 SizedBox(
                   height: 15,
                 ),
                 InkWell(
                     onTap: () {
                       actionOnClick("gallery");
                       Navigator.pop(buildContext);
                     },
                     child: viewConfiguration!.bottomSheetGalleryRow),
               ],)
              ],
            ),
          ),
        );
      },
    );
  }
}

// class ActionConfig {}
