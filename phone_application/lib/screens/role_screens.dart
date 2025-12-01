import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/student_bloc.dart';
import '../services/api_service.dart';
import 'student_list_screen.dart';
import '../models/student_models.dart';

class MedicScreen extends StatelessWidget {
  const MedicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(apiService: ApiService()),
      child: const StudentListScreen(role: UserRole.medic),
    );
  }
}

class CuratorScreen extends StatelessWidget {
  final String groupNumber;

  const CuratorScreen({Key? key, required this.groupNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(apiService: ApiService()),
      child: StudentListScreen(
        role: UserRole.curator,
        curatorGroup: groupNumber,
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(apiService: ApiService()),
      child: const StudentListScreen(role: UserRole.administrator),
    );
  }
}