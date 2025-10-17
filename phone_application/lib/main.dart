import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter/services.dart';


void handleBackPress() {
  print("Назад!");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //установка только портретной ориентации
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}







