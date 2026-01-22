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

  Widget buildLoading() {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: Colors.white,
        size: 24,),
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
        ElevatedButton(
          onPressed: () {},
          child: const Text('Повторить'),
        ),
      ],
    )
    );
  }


  void openDatePicker(BuildContext context) {
    BottomPicker.date(
      headerBuilder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Выберите дату',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF72A7EB),
                fontWeight: FontWeight.w600,
                fontFamily: 'Geologica',
              ),
            ),
            IconButton(
                onPressed: () {
                  context.read<MedicBloc>().add(MedicCloseDatePickerEvent());
                },
                icon: Icon(Icons.close),
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Color(0xFF72A7EB))),
            )
          ],
        );
      },
      dateOrder: DatePickerDateOrder.dmy,
      // initialDateTime: DateTime(2025, 10, 01),
      initialDateTime: DateTime.now(),
      maxDateTime: DateTime(2030),
      minDateTime: DateTime(2020),
      onChange: (index) {
        print(index);
        String date = _ConverterServices.convertDatePicker(index);
        print(date);
        // context.read<MedicBloc>().add(MedicSelectDateEvent(selectedDate: date));
      },
      onSubmit: (index) {
        print(index);
        String date = _ConverterServices.convertDatePicker(index);
        print(date);
        context.read<MedicBloc>().add(MedicSelectDateEvent(selectedDate: date));
      },
      onDismiss: (p0) {
        print(p0);
      },
      bottomPickerTheme: BottomPickerTheme.fluraPlate,
    ).show(context);
  }
}


class DateEditDialog extends StatefulWidget {
  final String? currentDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onCancel;

  DateEditDialog({
    Key? key,
    this.currentDate,
    required this.onDateSelected,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DateEditDialog> createState() => _DateEditDialogState();
}

  class _DateEditDialogState extends State<DateEditDialog>{
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text('Изменить дату флюорографии'),
      content: Column(
        children: [
          Text(widget.currentDate!),
          SizedBox(height: 16,),
          Row(
            children: [
              Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2027));
                      if(date != null){
                        BlocListener<SelectDateBloc, SelectDateState>(
                          listener: (context, state) {
                            selectedDate = (state.selectedDate)!;
                          },
                        );
                      }
                    },
                    child: Text('Выбрать дату нахуй'),
                  )
              )
            ],
          )
        ],
      ),
    );
  }

}