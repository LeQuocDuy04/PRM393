import 'package:flutter/material.dart';
import '../services/counter_stream_service.dart';

class ReactiveCounterScreen extends StatefulWidget {
  const ReactiveCounterScreen({super.key});
  @override
  State<ReactiveCounterScreen> createState() => _ReactiveCounterScreenState();
}

class _ReactiveCounterScreenState extends State<ReactiveCounterScreen> {
  late final CounterStreamService _service;

  @override
  void initState() {
    super.initState();
    _service = CounterStreamService(interval: const Duration(milliseconds: 1200));
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
      appBar: AppBar(title: const Text('Reactive Counter Demo')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BÀI TẬP 4 · REACTIVE THINKING', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Dữ liệu được giữ và thay đổi trong service. Hai widget cùng lắng nghe một broadcast Stream và tự render khi có giá trị mới.', style: Theme.of(context).textTheme.bodyMedium),
        ]))),
        const SizedBox(height: 16),
        _ReactiveValueCard(stream: _service.stream, title: 'Widget A · Giá trị chính', large: true),
        const SizedBox(height: 12),
        _ReactiveValueCard(stream: _service.stream, title: 'Widget B · Cùng lắng nghe Stream', large: false),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
          FilledButton.icon(onPressed: _service.isRunning ? _service.pause : _service.resume, icon: Icon(_service.isRunning ? Icons.pause : Icons.play_arrow), label: Text(_service.isRunning ? 'Pause' : 'Resume')),
          OutlinedButton.icon(onPressed: _service.reset, icon: const Icon(Icons.restart_alt), label: const Text('Reset')),
        ]))),
        const SizedBox(height: 12),
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Imperative vs Reactive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          SizedBox(height: 10),
          Text('Imperative: UI giữ counter, tăng biến và gọi setState().'),
          SizedBox(height: 6),
          Text('Reactive: service phát dữ liệu → Stream → widget lắng nghe → UI render. Không gọi setState để cập nhật giá trị counter.'),
          SizedBox(height: 10),
          Text('Lưu ý: setState vẫn được dùng hợp lý cho thao tác điều khiển giao diện; điều cần tránh là dùng nó làm cơ chế cập nhật dữ liệu Stream.'),
        ]))),
      ]),
    );
  }
}

class _ReactiveValueCard extends StatelessWidget {
  const _ReactiveValueCard({required this.stream, required this.title, required this.large});
  final Stream<int> stream;
  final String title;
  final bool large;

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
    Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 12),
    StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Stream có lỗi');
        if (!snapshot.hasData) return const Text('Waiting...');
        debugPrint('Reactive widget rebuild: ${snapshot.data}');
        return Text('${snapshot.data}', style: (large ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.headlineMedium)?.copyWith(fontWeight: FontWeight.bold));
      },
    ),
  ])));
}
