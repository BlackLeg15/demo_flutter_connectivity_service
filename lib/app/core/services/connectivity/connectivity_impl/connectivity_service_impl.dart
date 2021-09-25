import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../connectivity_service.dart';

class ConnectivityServiceImpl extends ConnectivityService {
  late final Connectivity _connectivity;
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityServiceImpl._();

  static Future<ConnectivityServiceImpl> getInstance() async {
    final instance = ConnectivityServiceImpl._();
    await instance._initConnectivity();
    return instance;
  }

  Future<void> _initConnectivity() async {
    _connectivity = Connectivity();
    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      //TODO tratar erro corretamente
      debugPrint(e.toString());
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    hasConnection.value = result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
  }

  @override
  FutureOr<void> dispose() => _connectivitySubscription.cancel();
}
