import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class ConnectivityService {
  final hasConnection = ValueNotifier<bool>(false);
  FutureOr<void> dispose();
}
