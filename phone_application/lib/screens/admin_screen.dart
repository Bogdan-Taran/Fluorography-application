import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';


class AdminScreen extends StatelessWidget{
  static String id = 'admin_screen';
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context){
    TextStyles textStyles = TextStyles();
    final UserSharedPreferences _userSharedPreferences = UserSharedPreferences();


    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _userSharedPreferences.getUserRole(),
              builder: (context, AsyncSnapshot<String> snapshot){
                if(snapshot.hasData){
                  String role = snapshot.data!;
                  return Text(
                    'Your role is $role',
                    style: textStyles.textStyleTitle(context),
                  );
                } else{
                  return LoadingAnimationWidget.halfTriangleDot(
                    color: Colors.white,
                    size: 24,);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
