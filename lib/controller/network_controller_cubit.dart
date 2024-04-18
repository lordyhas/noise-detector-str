import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
part 'network_controller_state.dart';



class NetworkControllerCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;
  StreamSubscription? _connectivityStreamSubscription;

  NetworkControllerCubit(this._connectivity) : super(NetworkLoading()) {
    _connectivityStreamSubscription = _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        emit(NetworkConnected(connectionType: ConnectionType.wifi));
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emit(NetworkConnected(connectionType: ConnectionType.mobile));
      } else {
        emit(NetworkDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivityStreamSubscription?.cancel();
    return super.close();
  }
}

