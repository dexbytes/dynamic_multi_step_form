import 'package:flutter/material.dart';

class SuffixVisibilityIcon extends StatefulWidget {
  final Function(bool)? iconClicked;
  final Widget? iconWidget;
  final bool? initialValue;
  const SuffixVisibilityIcon(
      {Key? key, this.iconClicked, this.iconWidget, this.initialValue = true})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _IconClearTextFormFiledState createState() =>
      _IconClearTextFormFiledState(initialValue!);
}

class _IconClearTextFormFiledState extends State<SuffixVisibilityIcon> {
  bool _passwordVisible = true;
  _IconClearTextFormFiledState(bool initialValue) {
    _passwordVisible = initialValue;
  }
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
  void didUpdateWidget(covariant SuffixVisibilityIcon oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
            widget.iconClicked?.call(_passwordVisible);
          });
        },
        child: Container(
          child: widget.iconWidget != null
              ? widget.iconWidget!
              : Icon(
                  !_passwordVisible ? Icons.visibility : Icons.visibility_off),
        ));
  }
}
