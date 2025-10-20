import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Админ'),),
      body: const Center(
        child: Text('Привет, админ'),
      ),
    );
  }
}