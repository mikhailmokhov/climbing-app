import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  ConnectivityService() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (_connectionChangedCallback != null) {
        _connectionChangedCallback(_convertStatusToBoolean(result));
      }
    });
  }

  StreamSubscription<ConnectivityResult> _subscription;

  Function _connectionChangedCallback;

  Future<bool> isConnected() async {
    return _convertStatusToBoolean(await Connectivity().checkConnectivity());
  }

  void dispose() {
    _subscription.cancel();
  }

  void connectionChanged(Function(bool) callback) {
    _connectionChangedCallback = callback;
  }

  bool _convertStatusToBoolean(ConnectivityResult status) {
    switch (status) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.none:
    }
    return false;
  }
}
