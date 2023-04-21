import 'package:flutter/material.dart';
import 'package:whatsapp_clone/ui/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xff075E54),
              secondary: const Color(0xff25D366))),
      home: const HomePage(),
    );
  }
}
