import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'interner_connect_state.dart';


class InternetConnectCubit extends Cubit<InternetConnectState>{
  final Connectivity _connectivity;
  late final StreamSubscription _connectivityStream;

  InternetConnectCubit({
    required Connectivity connectivity
  }) : _connectivity = connectivity, super(InternetConnectState()){
    _connectivityStream = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if(result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile)){
        emit(InternetConnectState(type: InternetTypes.connected));
      }
      else if(result.contains(ConnectivityResult.none)){
        emit(InternetConnectState(type: InternetTypes.offline));
      }
      else {
        emit(InternetConnectState(type: InternetTypes.unknown));
      }
    });
  }

  @override
  Future<void> close() {
    _connectivityStream.cancel();
    return super.close();
  }

}
