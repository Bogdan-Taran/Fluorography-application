// используется для передачи состояния в ..._bloc.dart, а также для получения состояния,
// его категоризации и отображения пользовательского интерфейса в соответствии с ним.

part of 'medic_bloc.dart';

@immutable
sealed class MedicState {}

final class MedicInitial extends MedicState {}
