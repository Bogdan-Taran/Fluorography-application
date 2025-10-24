//здесь происходит получение/чтение роли из БД (админ, препод, медик)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService{
  List<dynamic> users = [];
  Future<void> fetchUsers() async {
    print('fetchUsers called');
    const url = 'http://192.168.13.19/api/login';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);


    print('fetchUsers completed');
  }

}