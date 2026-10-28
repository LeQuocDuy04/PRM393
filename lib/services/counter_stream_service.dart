import 'dart:async';

/// Produces a new counter value every second through a StreamController.
class CounterStreamService {
  final StreamController<int> _controller = StreamController<int>();
  Timer? _timer;
  int _count = 0;
  bool _isPaused = false;
  bool _isDisposed = false;

  CounterStreamService() {
    _startTimer();
  }

  Stream<int> get stream => _controller.stream;
  int get currentCount => _count;
  bool get isPaused => _isPaused;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused || _isDisposed) return;
      _count++;
      // ignore: avoid_print
      print('Stream phát giá trị: $_count');
      if (!_controller.isClosed) {
        _controller.add(_count);
      }
    });
  }

  void pause() {
    if (_isDisposed || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  void resume() {
    if (_isDisposed || !_isPaused) return;
    _isPaused = false;
    _startTimer();
  }

  void reset() {
    if (_isDisposed) return;
    _count = 0;
    if (!_controller.isClosed) {
      _controller.add(_count);
    }
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    await _controller.close();
  }
}
