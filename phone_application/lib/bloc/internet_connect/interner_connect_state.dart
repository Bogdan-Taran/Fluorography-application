part of 'interner_connect_cubit.dart';

enum InternetTypes{
  connected,
  offline,
  unknown
}

class InternetConnectState {
  final InternetTypes type;

  InternetConnectState({
    this.type = InternetTypes.unknown,
  });
}

final class InternetConnectInitial extends InternetConnectState {}
