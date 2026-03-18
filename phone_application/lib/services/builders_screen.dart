import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import 'converters_service.dart';

class BuildersScreen {
  ConverterServices _ConverterServices = ConverterServices();

  Widget buildLoading({double size = 50}) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: Color(0xff98BFF3),
        size: size,
      ),
    );
  }

  Widget buildError(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Ошибка: $errorMessage',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Повторить')),
        ],
      ),
    );
  }

  void openDatePicker(BuildContext context,
      String uniqueDateContainerId,
      WorkingWithFluorographyBloc bloc,) {
    final dateNow = DateTime.now();
    BottomPicker.date(
      buttonContent: Text(
        textAlign: TextAlign.center,
        'Выбрать',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w400,
          fontFamily: 'Geologica',
        ),
      ),
      buttonStyle: BoxDecoration(
        color: Color(0xff98BFF3),
        borderRadius: BorderRadius.circular(14),
      ),
      headerBuilder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Выберите дату',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF72A7EB),
                fontWeight: FontWeight.w400,
                fontFamily: 'Geologica',
              ),
            ),
            IconButton(
              onPressed: () {
                // context.read<MedicBloc>().add(MedicCloseDatePickerEvent());
                bloc.add(CloseDatePickerEvent(uniqueId: uniqueDateContainerId));
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Color(0xFF72A7EB)),
              ),
            ),
          ],
        );
      },
      dateOrder: DatePickerDateOrder.dmy,
      // initialDateTime: DateTime(2025, 10, 01),
      initialDateTime: DateTime.now(),
      maxDateTime: DateTime.now(),
      minDateTime: dateNow.subtract(Duration(days: 365 * 2)),
      onChange: (index) {
        print(index);
        String date = _ConverterServices.convertDatePicker(index);
        print(date);
        // context.read<MedicBloc>().add(MedicSelectDateEvent(selectedDate: date));
      },
      onSubmit: (index) {
        print(index);
        String date = _ConverterServices.convertDatePicker(index);
        print('Печатаю дату: $date');
        bloc.add(
          SelectDateEvent(
            selectedDate: date,
            uniqueContainerId: uniqueDateContainerId,
          ),
        );
        print(
          'Вызвал ивент выбора даты, selected date: $date, uniqueContainerId: $uniqueDateContainerId',
        );
      },
      onDismiss: (p0) {
        print(p0);
      },
      bottomPickerTheme: BottomPickerTheme.fluraPlate,
    ).show(context);
  }
}

class PopUpMessage extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const PopUpMessage({
    super.key,
    required this.message,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return
      Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: Material(
            child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSuccess ? Color(0xff1DD300) : Color(0xffF80012),
                ),
                child: Row(
                  children: [
                    Icon(
                        isSuccess? Icons.check_circle_outline : Icons.error_outline,
                        color: Colors.white
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ),
          )
      );
  }
}

void showPopMessage(
    BuildContext context,
    String message,
    bool isSuccess
    ){
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(builder: (context){
    return PopUpMessage(message: message, isSuccess: isSuccess);
  });
  Overlay.of(context).insert(overlayEntry);
  Future.delayed(Duration(seconds: 2), (){
    if(overlayEntry!.mounted){
      overlayEntry.remove();
    }
  });
}
