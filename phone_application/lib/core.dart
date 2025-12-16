import 'models/user_model.dart';

class Core {
  static UserData? _user;

  UserData? get user => _user;

  Future<void> setUserData() async{
    //load data from shared preferences
  }
}