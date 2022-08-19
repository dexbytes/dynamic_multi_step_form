import 'package:flutter/material.dart';

class CheckBoxCustom extends StatefulWidget {
  final bool? checkStatus;
  final Function(bool)? onClicked;

  const CheckBoxCustom({Key? key, this.checkStatus = false, this.onClicked})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _CheckBoxCustomState createState() =>
      _CheckBoxCustomState(checkStatus: checkStatus, onClicked: onClicked);
}

class _CheckBoxCustomState extends State<CheckBoxCustom> {
  bool? checkStatus;
  Function(bool)? onClicked;

  _CheckBoxCustomState({this.checkStatus = false, this.onClicked});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CheckBoxCustom oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.checkStatus != null) {
        checkStatus = widget.checkStatus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: checkStatus,
        onChanged: (value) {
          debugPrint("$value");
          setState(() {
            checkStatus = value;
          });
          onClicked?.call(checkStatus!);
        });
  }
}
