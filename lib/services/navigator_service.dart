import 'package:flutter/material.dart';

class NavigatorService {
  Future navigateTo(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
