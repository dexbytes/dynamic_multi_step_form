import 'package:flutter/material.dart';

class SuffixCalendarIcon extends StatefulWidget {
  final Function(bool)? iconClicked;
  final Widget? iconWidget;
  const SuffixCalendarIcon({Key? key,this.iconClicked,this.iconWidget}) : super(key: key);

  @override
  _CalendarTextFormFiledState createState() => _CalendarTextFormFiledState();
}

class _CalendarTextFormFiledState extends State<SuffixCalendarIcon> {

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
  void didUpdateWidget(covariant SuffixCalendarIcon oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(onTap: (){
      /*setState(() {
        _passwordVisible = !_passwordVisible;
        widget.iconClicked?.call(_passwordVisible);
      });*/
      widget.iconClicked?.call(true);
    },child: Container(child: widget.iconWidget!=null? widget.iconWidget!:  const Icon(Icons.calendar_today_outlined),));
  }
}
