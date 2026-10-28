import 'package:flutter/material.dart';

import '../services/counter_stream_service.dart';

class StreamCounterScreen extends StatefulWidget {
  const StreamCounterScreen({super.key});

  @override
  State<StreamCounterScreen> createState() => _StreamCounterScreenState();
}

class _StreamCounterScreenState extends State<StreamCounterScreen> {
  late final CounterStreamService _service;

  @override
  void initState() {
    super.initState();
    _service = CounterStreamService();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 2: Stream Counter')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.show_chart, size: 64),
              const SizedBox(height: 12),
              const Text(
                'Stream phát dữ liệu mỗi giây',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              StreamBuilder<int>(
                stream: _service.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Có lỗi khi nhận dữ liệu Stream.');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(_service.isPaused ? 'Đang tạm dừng' : 'Đang chạy realtime'),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        if (_service.isPaused) {
                          _service.resume();
                        } else {
                          _service.pause();
                        }
                      });
                    },
                    icon: Icon(_service.isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(_service.isPaused ? 'Resume' : 'Pause'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      _service.reset();
                      setState(() {});
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'StreamController là nguồn phát. StreamBuilder lắng nghe và tự cập nhật UI. Khi widget bị hủy, dispose() đóng timer và stream.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
