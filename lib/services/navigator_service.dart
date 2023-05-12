import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<Object?> navigateTo(Widget page) => navigatorKey.currentState!
      .push(MaterialPageRoute(builder: (context) => page));

  Future<Object?> navigateAndReplace(Widget page) =>
      navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => page));
}
