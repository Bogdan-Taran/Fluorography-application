// Запускает событие из пользовательского интерфейса и передает текущее состояние.
// Ничего, кроме взаимодействия пользователя с пользовательским интерфейсом.

import 'package:flutter/material.dart';
// import 'lib/screens/roles_depend_screen/medic/model/result_model.dart';
part of 'medic_bloc.dart';


@immutable
sealed class MedicEvent {}

class LoadMedic extends MedicEvent{}
