import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(fontSize: 20);

showSnackBar(BuildContext context, String content, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: error ? Colors.red : null,
    content: Text(content),
    duration: const Duration(seconds: 2),
  ));
}
