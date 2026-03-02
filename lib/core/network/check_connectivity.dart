import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ConnectivityService {
//   static final ConnectivityService _instance = ConnectivityService._internal();
//   factory ConnectivityService() => _instance;
//
//   ConnectivityService._internal() {
//     _init();
//   }
//
//   final Connectivity _connectivity = Connectivity();
//
//   // Latest list of network types (wifi, mobile, ethernet, vpn, etc.)
//   List<ConnectivityResult> _lastStatus = [ConnectivityResult.none];
//
//   final _controller = StreamController<List<ConnectivityResult>>.broadcast();
//   Stream<List<ConnectivityResult>> get stream => _controller.stream;
//
//   List<ConnectivityResult> get currentStatus => _lastStatus;
//
//   void _init() async {
//     _lastStatus = await _connectivity.checkConnectivity();
//     _controller.add(_lastStatus);
//
//     _connectivity.onConnectivityChanged.listen((statusList) {
//       _lastStatus = statusList;
//       _controller.add(statusList);
//     });
//   }
//
//   // Helper method
//   static Future<bool> isOnline() async {
//     final result = await Connectivity().checkConnectivity();
//     return !result.contains(ConnectivityResult.none);
//   }
//
//   // Future<bool> isOnline() async {
//   //   final list = await _connectivity.checkConnectivity();
//   //   return list.any((s) => s != ConnectivityResult.none);
//   // }
// }


import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  // Stream controller to broadcast online/offline changes
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get stream => _controller.stream;

  // Current online status
  bool _isOnline = false;
  bool get currentStatus => _isOnline;

  Timer? _timer;

  /// Call this once from main() after ensureInitialized
  Future<void> init({Duration checkInterval = const Duration(seconds: 5)}) async {
    // Initial check
    _isOnline = await InternetConnectionChecker().hasConnection;
    _controller.add(_isOnline);

    // Periodically check internet connection
    _timer = Timer.periodic(checkInterval, (_) async {
      final status = await InternetConnectionChecker().hasConnection;
      if (status != _isOnline) {
        _isOnline = status;
        _controller.add(_isOnline);
      }
    });
  }

  /// Stop periodic checking
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  /// Helper method: check internet once
  static Future<bool> isOnline() async {
    try {
      return await InternetConnectionChecker().hasConnection;
    } catch (e) {
      print("Connectivity check failed: $e");
      return false;
    }
  }
}

/*
/// Enum for connection state
enum ConnectionStatus { wifi, mobile, none }

/// Reusable Connectivity Service for whole app
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  /// Reactive network status
  final Rx<ConnectionStatus> connectionStatus = ConnectionStatus.none.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _listenToChanges();
  }

  /// Initial check
  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  /// Listen for network changes
  void _listenToChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
  }

  /// Update reactive connection status
  void _updateStatus(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (result == ConnectivityResult.wifi) {
      connectionStatus.value = ConnectionStatus.wifi;
    } else if (result == ConnectivityResult.mobile) {
      connectionStatus.value = ConnectionStatus.mobile;
    } else {
      connectionStatus.value = ConnectionStatus.none;
    }
  }

  /// Helper: Return true if connected
  bool get isConnected =>
      connectionStatus.value != ConnectionStatus.none;

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}*/


/*class CheckConnectivity {
  static Future<bool> isInternetAvailable() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }

    return false;
  }
}
*/