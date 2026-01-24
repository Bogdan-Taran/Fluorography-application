import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ScreensWidgets {
  PreferredSizeWidget AppBarFlura<B extends Bloc<Object, Object>, E extends Object>({
    required BuildContext context,
    required B bloc,
    required E event,
}){
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.12),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: const BoxDecoration(color: Colors.transparent),
        child:
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      'assets/images/notification_icon.svg',
                      color: const Color(0xff98BFF3),
                      width: 35,
                      height: 35,
                    ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                          Set<WidgetState> states,
                          ) {
                        if (states.contains(WidgetState.disabled)) {
                          return const Color(0xffD5D6D7);
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF72A7EB);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(0xFFBADEFF);
                        }
                        return const Color(0xff98BFF3);
                      }),
                      foregroundColor: WidgetStateProperty.all(const Color(0xffffffff)),
                      minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.1, 35),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    onPressed: () {
                      context.read<B>().add(event);
                      print('Нажата кнопка выхода');
                    },
                    child: const Text(
                      'Выход',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Geologica',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              SearchBar(context: context)
            ],
          ),
        )
      ),
    );
  }

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
