import 'package:flutter/material.dart';

/// Custom Suffix Close Icon view
class SuffixScannerIcon extends StatefulWidget {
  final TextEditingController? textController;
  final VoidCallback? iconClicked;
  final VoidCallback? qrScannerIconClicked;
  final Widget? iconWidget;
  final Widget? qrScannerIconWidget;
  final Color? iconColor;
  final Color? qrScannerIconColor;
  final bool isHideCrossIcon;

  const SuffixScannerIcon({
    Key? key,
    this.textController,
    this.iconColor,
    this.qrScannerIconColor,
    this.iconClicked,
    this.qrScannerIconClicked,
    this.isHideCrossIcon = true,
    this.iconWidget,
    this.qrScannerIconWidget,
  }) : super(key: key);

  @override
  _IconClearTextFormFiledState createState() =>
      _IconClearTextFormFiledState(textController: textController);
}

class _IconClearTextFormFiledState extends State<SuffixScannerIcon> {
  String enteredValue = "";
  TextEditingController? textController;

  _IconClearTextFormFiledState({this.textController}) {
    if (textController != null) {
      enteredValue = textController!.text;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (textController != null) {
      textController!.addListener(() {
        setState(() {
          enteredValue = textController!.text;
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SuffixScannerIcon oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    setState(() {
      if (widget.textController != null) {
        enteredValue = widget.textController!.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return enteredValue.isNotEmpty
        ? widget.isHideCrossIcon
            ? InkWell(
                onTap: () => widget.iconClicked?.call(),
                child: Container(
                  child: widget.iconWidget != null
                      ? widget.iconWidget!
                      : Icon(
                          Icons.close,
                          color: widget.iconColor ?? Colors.black,
                        ),
                ))
            : SizedBox()
        : InkWell(
            onTap: () => widget.qrScannerIconClicked?.call(),
            child: Container(
              child: widget.qrScannerIconWidget != null
                  ? widget.qrScannerIconWidget!
                  : Icon(
                      Icons.document_scanner_sharp,
                      color: widget.qrScannerIconColor ?? Colors.black,
                      size: 35,
                    ),
            ));
  }
}
