part of 'curator_bloc.dart';

@immutable
abstract class CuratorEvent {}

class CuratorInitialEvent extends CuratorEvent{}


class CuratorSignOutEvent extends CuratorEvent{}