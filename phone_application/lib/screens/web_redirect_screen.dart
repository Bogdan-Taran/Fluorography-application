import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class WebRedirectScreen extends StatelessWidget {
  const WebRedirectScreen({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://flura.tomtit-tomsk.ru');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteColorMain,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: REdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.monitor,
                  size: 80.r,
                  color: AppStyle.blueColorBorder,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Приложение "Флюра" поддерживается на разных устройствах, но на экранах, больших чем смартфонов лучше использовать этот сервис в Веб-версии. Вы можете перейти по ссылке или QR-коду.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppStyle.fontSizeMedium_16,
                    color: AppStyle.blackColorMain,
                    fontFamily: 'Geologica',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _launchUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.blueColorBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Нажмите чтобы перейти",
                      style: TextStyle(
                        color: AppStyle.whiteColorMain,
                        fontSize: AppStyle.fontSizeMediumMini_14,
                        fontFamily: 'Geologica',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: REdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/qr_code_link_to_web.png',
                    width: 200.r,
                    height: 200.r,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200.r,
                        height: 200.r,
                        color: Colors.grey[200],
                        child: Center(child: Text('QR Code')),
                      );
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
