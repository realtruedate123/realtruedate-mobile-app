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