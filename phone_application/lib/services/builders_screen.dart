import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';

class BuildersScreen {
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