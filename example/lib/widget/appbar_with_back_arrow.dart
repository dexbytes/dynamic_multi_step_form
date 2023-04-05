import 'package:flutter/material.dart';

PreferredSizeWidget appBarWithBackArrow({
  double height = kToolbarHeight,
  bool isDisplayActions = true,
  Function? onPress,
  Function? onPressTrailingButton,
  List<Widget> action = const [],
  bool isArabicSelected = true,
  Color? color,
  Color? backArrowIconColor,
  bool isShowButton = false,
  TextStyle textStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff828588)),
}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IconButton(
              splashRadius: 22,
              onPressed: () {
                onPress!();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
                splashRadius: 22,
                onPressed: () {
                  onPressTrailingButton!();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 26,
                )),
          ),
        ],
      ));
}
