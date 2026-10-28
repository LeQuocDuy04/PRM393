import 'dart:async';

import 'package:flutter/foundation.dart';

/// Owns the counter state and emits values. It is deliberately independent of UI.
class CounterStreamService {
  CounterStreamService({this.interval = const Duration(seconds: 1)})
      : _controller = StreamController<int>.broadcast();

  final Duration interval;
  final StreamController<int> _controller;
  Timer? _timer;
  int _counter = 0;
  bool _disposed = false;

  Stream<int> get stream => _controller.stream;
  int get currentValue => _counter;
  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    if (_disposed || isRunning) return;
    _timer = Timer.periodic(interval, (_) {
      if (_disposed || _controller.isClosed) return;
      _counter++;
      debugPrint('Emit counter: $_counter');
      _controller.add(_counter);
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  void resume() => start();

  void reset() {
    if (_disposed || _controller.isClosed) return;
    _counter = 0;
    _controller.add(_counter);
  }

  void emitDemoError() {
    if (!_disposed && !_controller.isClosed) {
      _controller.addError(Exception('Lỗi Stream được mô phỏng. Hãy tiếp tục để nhận dữ liệu mới.'));
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    await _controller.close();
  }
}
