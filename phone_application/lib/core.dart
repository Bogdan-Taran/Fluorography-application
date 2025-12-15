import 'dart:convert' show jsonDecode;
import 'models/user_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class Core {
  static UserData? _user;

  UserData? get user => _user;

  Future<void> setUserData() async{
    //load data from shared preferences
  }
}