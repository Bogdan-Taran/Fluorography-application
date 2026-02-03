import 'package:shared_preferences/shared_preferences.dart';
import 'converters_service.dart';

class UserSharedPreferences{
  final ConverterServices _converterServices = ConverterServices();

  Future<void> saveUserDataIntoSharedPreferences(UserData) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('id', UserData.id);
    await prefs.setString('firstname', UserData.firstname);
    await prefs.setString('lastname', UserData.lastname);
    await prefs.setString('patronymic', UserData.patronymic);
    await prefs.setInt('network_city_id', UserData.network_city_id);
    final String? userNormalNamedRole = await _converterServices.convertUserRoleFormListToNormalName(UserData);
    await prefs.setString('role', userNormalNamedRole!);
    await prefs.setStringList('groups', UserData.groups);
  }


  Future<void> getUserFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    print('Typing all values about user from shared preferences');

    print(prefs.getInt('id'));
    print(prefs.getString('firstname'));
    print(prefs.getString('lastname'));
    print(prefs.getString('patronymic'));
    print(prefs.getInt('network_city_id'));
    print(prefs.getString('role'));
    print(prefs.getStringList('groups'));
  }

  Future<List<String>> getCuratorListGroupsFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('groups')!;
  }


  Future<String?> getUserFirstnameFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('firstname'));
    return prefs.getString('firstname');
  }

  Future<String> getUserRole() async{
    print('Получаю роль из SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    switch (role){
      case 'curator':
        return 'curator';
        break;
      case 'admin':
        return 'admin';
        break;
      case 'medic':
        return 'medic';
        break;
      case 'student':
        return 'student';
        break;
      case null:
        return 'undefined1';
        break;
      case '':
        return 'undefined2';
        break;
      default:
        return 'undefined3';
        break;
    }
  }





}