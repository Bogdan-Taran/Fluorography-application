
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceGetCommunityMembers{
  final String _baseUrl = 'http://flura.tomtit-tomsk.ru';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Map<String, dynamic>> getStudentsList() async{
    final token = getToken();
    final url = Uri.parse('$_baseUrl/api/students');
    final response = await http.get(
      url,
      headers:{
        'Content-Type':'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
    }
  }







}