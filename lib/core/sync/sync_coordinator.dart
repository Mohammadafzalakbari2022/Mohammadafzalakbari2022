import 'package:flutter/foundation.dart';

/// Ensures only one push/pull sync runs at a time (manual + automatic).
final class SyncCoordinator extends ChangeNotifier {
  SyncCoordinator._();
  static final SyncCoordinator instance = SyncCoordinator._();

  bool _busy = false;

  bool get busy => _busy;

  /// Runs [work] when idle; returns `null` if another sync is already running.
  Future<T?> runExclusive<T>(Future<T> Function() work) async {
    if (_busy) return null;
    _busy = true;
    notifyListeners();
    try {
      return await work();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
