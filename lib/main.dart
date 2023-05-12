import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/services/navigator_service.dart';
import 'package:whatsapp_clone/ui/users_page/users_page.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';

Future main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: 'WhatsApp Clone',
        theme: ThemeData(
            primaryColor: const Color(0xff075E54),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xff075E54),
              secondary: const Color(0xff25D366),
            )),
        navigatorKey: locator<NavigatorService>().navigatorKey,
        home: const UsersPage(),
      ),
    );
  }
}
