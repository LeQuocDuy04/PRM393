import 'package:flutter/material.dart';
import '../services/counter_stream_service.dart';

class LiveCounterScreen extends StatefulWidget {
  const LiveCounterScreen({super.key});

  @override
  State<LiveCounterScreen> createState() => _LiveCounterScreenState();
}

class _LiveCounterScreenState extends State<LiveCounterScreen> {
  late final CounterStreamService _service;

  @override
  void initState() {
    super.initState();
    _service = CounterStreamService();
    _service.start();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Counter Stream')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const _IntroCard(
          number: 'BÀI TẬP 1 + 2',
          title: 'Realtime Stream',
          description: 'Counter phát dữ liệu mỗi giây. StreamBuilder xử lý loading, data và error; UI không dùng setState để cập nhật counter.',
        ),
        const SizedBox(height: 18),
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          const Icon(Icons.monitor_heart_outlined, size: 42),
          const SizedBox(height: 12),
          const Text('COUNTER HIỆN TẠI', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          StreamBuilder<int>(
            stream: _service.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Stream vẫn có thể phát dữ liệu mới sau lỗi.', textAlign: TextAlign.center),
                ]);
              }
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) return const Text('Đang chờ dữ liệu...');
              return Text('${snapshot.data}', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold));
            },
          ),
          const SizedBox(height: 22),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
            FilledButton.icon(onPressed: _service.isRunning ? _service.pause : _service.resume,
              icon: Icon(_service.isRunning ? Icons.pause : Icons.play_arrow), label: Text(_service.isRunning ? 'Pause' : 'Resume')),
            OutlinedButton.icon(onPressed: _service.reset, icon: const Icon(Icons.restart_alt), label: const Text('Reset')),
            OutlinedButton.icon(onPressed: _service.emitDemoError, icon: const Icon(Icons.warning_amber), label: const Text('Test error')),
          ]),
          const SizedBox(height: 12),
          const Text('Mở Debug Console để xem log “Emit counter”.', textAlign: TextAlign.center),
        ]))),
        const SizedBox(height: 18),
        const _FlowCard(),
      ]),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.number, required this.title, required this.description});
  final String number;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(number, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
    const SizedBox(height: 6), Text(title, style: Theme.of(context).textTheme.titleLarge),
    const SizedBox(height: 8), Text(description),
  ])));
}

class _FlowCard extends StatelessWidget {
  const _FlowCard();
  @override
  Widget build(BuildContext context) => const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Luồng dữ liệu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    SizedBox(height: 10),
    Text('Timer → StreamController.add() → Stream<int> → StreamBuilder → UI'),
    SizedBox(height: 8),
    Text('Không tạo Stream trong build(). Service hủy Timer và đóng StreamController khi màn hình bị hủy.'),
  ])));
}
