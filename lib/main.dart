import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reminder/core/routing/router.dart';

import 'core/routing/locator/locator.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  setLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      onGenerateRoute: PageRouter.generateRoutes,
    );
  }
}
