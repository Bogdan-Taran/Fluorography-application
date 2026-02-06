import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../services/checker_service.dart';

class EditElevatedButtonBuildWidget extends StatelessWidget {
  final String uniqueId;

  const EditElevatedButtonBuildWidget({super.key, required this.uniqueId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<WorkingWithFluorographyBloc>().add(
          TurnOnEditingModeEvent(uniqueId: uniqueId),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff98BFF3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shadowColor: Colors.transparent,
      ),
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
}

class EditRowWithButtons extends StatelessWidget {
  final String uniqueId;
  final bool isEditing;

  const EditRowWithButtons({
    super.key,
    required this.uniqueId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<WorkingWithFluorographyBloc>().add(
                    CancelEditingModeEvent(uniqueId: uniqueId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    width: 1,
                    color: isEditing ? Color(0xff98BFF3) : Colors.transparent,
                  ),
                ),
                child: Text(
                  'Отменить',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    color: Color(0xff98BFF3),
                    fontFamily: 'Geologica',
                  ),
                ),
              ),
              SizedBox(
                width: 18,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<WorkingWithFluorographyBloc>().add(
                    SaveEditingModeEvent(),
                  );
                  context.read<WorkingWithFluorographyBloc>().add(
                    CancelEditingModeEvent(uniqueId: uniqueId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff98BFF3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  shadowColor: Colors.transparent,
                ),
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
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EditElevatedButtonBuildWidget(key: key, uniqueId: uniqueId),
            ],
          );
  }
}

class DataFluraContainerBuildWidget extends StatelessWidget {
  final String dataContainer;
  final String uniqueDateContainerId;
  final String uniqueEditingSectionId;

  const DataFluraContainerBuildWidget({
    super.key,
    required this.dataContainer,
    required this.uniqueDateContainerId,
    required this.uniqueEditingSectionId,
  });

  @override
  Widget build(BuildContext context) {
    CheckerService _CheckerService = CheckerService();
    BuildersScreen _BuildersScreen = BuildersScreen();
    bool isEditing = false;
    return BlocBuilder<
      WorkingWithFluorographyBloc,
      WorkingWithFluorographyState
    >(
      builder: (context, state) {
        isEditing = state.editingStates[uniqueEditingSectionId] ?? false;
        // print('Перестраиваю виджет с id $uniqueDateContainerId, изменяемость: $isEditing');
        final displayDate =
            state.tempDates[uniqueDateContainerId] ?? dataContainer;
        // print('Отображаемая дата: $displayDate');
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(30, 15),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            backgroundColor: isEditing
                ? Colors.transparent
                : switch (_CheckerService.isFluorographyOverdue(
                    dataContainer,
                  )) {
                    DataStatus.unknown => const Color(0xffF29393),
                    DataStatus.overdue => const Color(0xffF29393),
                    DataStatus.quitOverdue => const Color(0xffFFE550),
                    DataStatus.noOverdue => Colors.transparent,
                  },
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            side: BorderSide(
              width: 2,
              color: isEditing ? Color(0xff98BFF3) : Colors.transparent,
            ),
          ),
          onPressed: isEditing
              ? () {
                  print('Нажата кнопка');
                  context.read<WorkingWithFluorographyBloc>().add(
                    OpenDatePickerEvent(uniqueId: uniqueDateContainerId),
                  );
                  _BuildersScreen.openDatePicker(
                    context,
                    uniqueDateContainerId,
                    context.read<WorkingWithFluorographyBloc>(),
                  );
                  print('Должен открыться datepicker');
                  print('Открыл datePicker для $uniqueDateContainerId');
                }
              : () {},
          child: Text(
            // dataContainer,
            // _ConverterServices.formatFluraDate(displayDate),
            displayDate,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff26292B),
            ),
          ),
        );
      },
    );
  }
}
