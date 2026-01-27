import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/working_with_fluorography/working_with_fluorography_bloc.dart';

import '../services/builders_screen.dart';
import '../services/checker_service.dart';

class ScreensWidgets {
  CheckerService _CheckerService = CheckerService();
  BuildersScreen _BuildersScreen = BuildersScreen();

  PreferredSizeWidget AppBarFlura<
    B extends Bloc<Object, Object>,
    E extends Object
  >({required BuildContext context, required B bloc, required E event}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.13),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Padding(
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
                      foregroundColor: WidgetStateProperty.all(
                        const Color(0xffffffff),
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.1, 35),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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

              SearchBar(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchBar({required BuildContext context}) {
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

  Widget EditElevatedButton({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () {
        context.read<WorkingWithFluorographyBloc>().add(
          TurnOnEditingModeEvent(),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xff98BFF3)),
      child: Text(
        'Редактировать',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.016,
          color: Color(0xffffffff),
          fontFamily: 'Geologica',
        ),
      ),
    );
  }

  Widget EditRowWithButtons({required BuildContext context}) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<WorkingWithFluorographyBloc>().add(
              CancelEditingModeEvent(),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xffffffff)),
          child: Text(
            'Отменить',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.016,
              color: Color(0xff98BFF3),
              fontFamily: 'Geologica',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<WorkingWithFluorographyBloc>().add(
              EnableEditingModeEvent(),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff98BFF3)),
          child: Text(
            'Сохранить',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.016,
              color: Color(0xffffffff),
              fontFamily: 'Geologica',
            ),
          ),
        ),
      ],
    );
  }

  Widget DataFluraContainer({
    required BuildContext context,
    required String dataContainer,
  }) {
    bool isEditing = false;
    return BlocListener<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case EditModeWorkingWithFluorographyState:
            print('Состояние изменения');
            isEditing = true;
          case CancelEditingModeEvent:
            print('Состояние отмены');
            isEditing = false;
          case EnableEditingModeEvent:
            print('Состояние применения');
            isEditing = false;
          case OpenedDatePickerState:
            print('Состояние открытия datepicker');
            _BuildersScreen.openDatePicker(context);
          default:
            print('Дефолтное сосотоянеи');
            isEditing = false;
        }
      },
      child: BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
        builder: (context, state){
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                isEditing ?
                Colors.transparent:
                switch(_CheckerService.isFluorographyOverdue(dataContainer)){
                  DataStatus.unknown => const Color(0xffF29393),
                  DataStatus.overdue => const Color(0xffF29393),
                  DataStatus.quitOverdue => const Color(0xffFFE550),
                  DataStatus.noOverdue => Colors.transparent,
                },
                shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              side: BorderSide(
                width: 2,
                color: isEditing ? Color(0xff98BFF3) : Colors.transparent
              )
            ),
            // TODO: make opening Datepicker
            onPressed: isEditing ? () {
              context.read<WorkingWithFluorographyBloc>().add(OpenDatePickerEvent());
            } : null,
            child: Text(
              dataContainer,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff26292B),
              ),
            ),
          );
        },
      ),
    );



    /*
    return Container(
      decoration: BoxDecoration(
        color: switch(_CheckerService.isFluorographyOverdue(dataContainer)){
          DataStatus.unknown => const Color(0xffF29393),
          DataStatus.overdue => const Color(0xffF29393),
          DataStatus.quitOverdue => const Color(0xffFFE550),
          DataStatus.noOverdue => Colors.transparent,
        },
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 8,
        ),
        child: Text(
          dataContainer,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff26292B),
          ),
        ),
      ),
    );*/
  }
}
