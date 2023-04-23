import 'package:flutter/material.dart';
import 'package:whatsapp_clone/ui/const.dart';

class ProgressElevatedButton extends StatefulWidget {
  final bool isProgress;
  final String? text;
  final Icon? icon;
  final void Function() onPressed;
  const ProgressElevatedButton(
      {Key? key,
      required this.isProgress,
      this.text,
      this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  State<ProgressElevatedButton> createState() => _ProgressElevatedButtonState();
}

class _ProgressElevatedButtonState extends State<ProgressElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return widget.icon == null
        ? ElevatedButton(
            child: widget.isProgress
                ? const CircularProgressIndicator()
                : Text(
                    widget.text!,
                    style: textStyle,
                  ),
            onPressed: () {
              onPressed();
            })
        : IconButton(
            icon: widget.isProgress
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : widget.icon!,
            onPressed: () {
              onPressed();
            },
          );
  }

  onPressed() {
    if (!widget.isProgress) {
      widget.onPressed();
    }
  }
}
