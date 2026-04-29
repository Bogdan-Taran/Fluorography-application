import 'package:flutter/material.dart';
import 'package:project_fluorography/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedicScreenReference extends StatelessWidget {
  const MedicScreenReference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteColorMain,
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
