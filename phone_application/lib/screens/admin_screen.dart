// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:project_fluorography/bloc/admin/admin_bloc.dart';
// import '../services/shared_pref_service.dart';
// import '../styles.dart';
// import '../widgets/screens_widgets.dart';
//
//
// class AdminScreen extends StatefulWidget {
//   static String id = 'admin_screen';
//
//   const AdminScreen({super.key});
//
//   @override
//   State<AdminScreen> createState() => _AdminScreen extends State<AdminScreen>();
// }
//
// class _AdminScreen extends State<AdminScreen> {
//   @override
//   void initState() {
//     (context).read<AdminBloc>.add(AdminInitialEvent);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context){
//     TextStyles textStyles = TextStyles();
//     final UserSharedPreferences _userSharedPreferences = UserSharedPreferences();
//     ScreensWidgets _ScreensWidgets = ScreensWidgets();
//
//     return SafeArea(child: Scaffold(
//       appBar: _ScreensWidgets.AppBarFlura(context: context, bloc: context.read<AdminBloc>(), event: event)
//
//     ))
//   }
// }
//
//
