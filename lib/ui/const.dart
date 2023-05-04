// ignore_for_file: avoid_print
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

printError(String className, String methodName, Object e) {
  print("$className $methodName hata: ${e.toString()}");
}

goToPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
