import 'package:flutter/material.dart';
import 'package:project_fluorography/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminScreenReference extends StatelessWidget {
  const AdminScreenReference({super.key});

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
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: IgnorePointer(
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(1, -1),
                    child: SvgPicture.asset(
                      'assets/images/vectorRight.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1, 0.5),
                    child: SvgPicture.asset(
                      'assets/images/vectorLine.svg',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'assets/images/vectorBottom.svg',
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Этот раздел вам недоступен',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.blueColorTextTitle,
                  fontFamily: 'Geologica',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
