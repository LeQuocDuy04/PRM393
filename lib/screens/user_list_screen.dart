import 'package:flutter/material.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key, required this.repository});
  final UserRepository repository;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = widget.repository.getUsers();
  }

  void _reload() {
    setState(() => _usersFuture = widget.repository.getUsers());
  }

  void _switchSource(bool useAlternate) {
    widget.repository.useAlternateSource(useAlternate);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final isAlternate = widget.repository.usingAlternateSource;
    return Scaffold(
      appBar: AppBar(title: const Text('User List Repository Demo'), actions: [IconButton(tooltip: 'Tải lại', onPressed: _reload, icon: const Icon(Icons.refresh))]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BÀI TẬP 3 · REPOSITORY PATTERN', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('UI chỉ gọi UserRepository. Repository điều phối nguồn dữ liệu; màn hình không import datasource.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          const Text('Thử đổi nguồn dữ liệu để thấy UI không cần viết lại.'),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Fake source'), icon: Icon(Icons.storage_outlined)),
              ButtonSegment(value: true, label: Text('Source khác'), icon: Icon(Icons.swap_horiz)),
            ],
            selected: {isAlternate},
            onSelectionChanged: (selection) => _switchSource(selection.first),
          ),
        ]))),
        const SizedBox(height: 14),
        FutureBuilder<List<User>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(child: Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())));
            }
            if (snapshot.hasError) {
              return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
                const Icon(Icons.error_outline, size: 36, color: Colors.red),
                const SizedBox(height: 8), Text('Không tải được user: ${snapshot.error}'),
                TextButton(onPressed: _reload, child: const Text('Thử lại')),
              ])));
            }
            final users = snapshot.data ?? const <User>[];
            if (users.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('Không có người dùng.')));
            return Column(children: [
              Align(alignment: Alignment.centerLeft, child: Text('${users.length} người dùng', style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(height: 8),
              ...users.map((user) => Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(
                leading: CircleAvatar(child: Text(user.name.isNotEmpty ? user.name[0] : '?')),
                title: Text(user.name), subtitle: Text('${user.email}\n${user.role}'), isThreeLine: true,
                trailing: Text('#${user.id}', style: Theme.of(context).textTheme.labelMedium),
              ))),
            ]);
          },
        ),
        const SizedBox(height: 12),
        const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Sơ đồ: UserScreen → UserRepository (abstract) → UserRepositoryImpl → Data Source.'))),
      ]),
    );
  }
}
