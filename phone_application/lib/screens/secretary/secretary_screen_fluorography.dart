import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../main.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/builders_screen.dart';
import '../../services/converters_service.dart';
import '../../widgets/bottom_navy_bar.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;
import '../../widgets/show_exit_dialog.dart';
import '../notification_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Флюорография секретерь
class SecretaryScreenFluorography extends ConsumerStatefulWidget {
  const SecretaryScreenFluorography({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecretaryScreenFluorography();
}

class _SecretaryScreenFluorography extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.whiteColorMain,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/images/serch_icon.svg',
                    width: 20,
                    height: 20,
                    color: const Color(0xff98BFF3),
                  ),
                ),
                hintText: 'Поиск',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff26292B),
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  'У вас нет доступа к этой странице. Вам доступна страница "справки"',
                  style: TextStyle(
                    color: AppStyle.blueColorTextTitle,
                    fontSize: AppStyle.fontSizeExtraLarge,
                    fontWeight: FontWeight.w500
                  ),
                textAlign: TextAlign.center,
              ),
            )
        )
    );
  }
}