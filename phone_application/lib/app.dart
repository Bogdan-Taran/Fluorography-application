import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_fluorography/screens/authentication_flow_page.dart';
import 'package:project_fluorography/widgets/button.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
              builder: (context, orientation){
                //SizerUtil().init(constraints, orientation);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Clean Flura',
                  home: const AuthenticationFlowScreen(),
                );
              }
          );
        }
    );
  }
}



class MyHomePage extends StatefulWidget{
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clean Flura'),
      ),
      body: const MessageButton(),
    );
  }
}