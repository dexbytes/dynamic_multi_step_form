import 'package:flutter/material.dart';

class BottomSheetOnlyCardView extends StatelessWidget {
  final String sheetTitle;
  final TextStyle sheetTitleStyle;
  final Color topLineColor;
  final double topLineThickness;
  final double topLineWidth;
  final topLineClickCallBack;
  final Color cardBackgroundColor;
  final double cardShape;
  final Widget child;
  final Widget? child2;
  final bool topLineShow;
  final EdgeInsetsGeometry topLineMargin;
  final CrossAxisAlignment crossAxisAlignment;

  BottomSheetOnlyCardView({
    Key? key,
    this.sheetTitle = "",
    this.sheetTitleStyle = const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
    this.topLineColor = Colors.grey,
    this.topLineThickness = 4,
    this.topLineWidth = 50,
    this.cardBackgroundColor = Colors.red,
    this.cardShape = 30,
    this.topLineClickCallBack,
    required this.child,
    this.topLineShow = false,
    this.topLineMargin = const EdgeInsets.only(top: 12, bottom: 10),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.child2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: topLineShow,
                  child: InkWell(
                    highlightColor: Colors.brown,
                    onTap: () {
                      if (topLineClickCallBack != null) {
                        topLineClickCallBack(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: topLineMargin,
                      width: topLineWidth,
                      child: Divider(
                        color: topLineColor,
                        //height: 10,
                        thickness: topLineThickness,
                        indent: 1,
                        endIndent: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20, top: 0),
              child: Text("$sheetTitle", style: sheetTitleStyle),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
