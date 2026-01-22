import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreensWidgets {

  Widget SearchBar({
    required BuildContext context,
  }) {
    final TextEditingController searchController = TextEditingController();
    return TextField(
      controller: searchController,
      cursorColor: Color(0xff72A7EB),
      cursorHeight: 25,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: SvgPicture.asset(
            'assets/images/serch_icon.svg',
            width: 20,
            height: 20,
            color: const Color(0xff98BFF3),
          ),
        ),
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xff98BFF3), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xff72A7EB), width: 2),
        ),
        hintText: 'Поиск',
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.016,
          color: Color(0xff98BFF3),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ),
      keyboardType: TextInputType.text,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}
