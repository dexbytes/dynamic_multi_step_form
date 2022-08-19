import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDoneView extends StatelessWidget {
  final VoidCallback? onPressCallback;
  final String buttonName;
  final TextStyle textStyle;
  const InputDoneView(
      {Key? key,
      this.onPressCallback,
      this.buttonName = "",
      this.textStyle =
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE0E0E0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 3.0, bottom: 3.0),
            onPressed: () {
              //FocusScope.of(context).requestFocus(new FocusNode());
              onPressCallback?.call();
            },
            child: Text(buttonName, style: textStyle),
          ),
        ),
      ),
    );
  }
}
