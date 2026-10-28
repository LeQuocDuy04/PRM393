import 'package:flutter/material.dart';
import 'models/student.dart';
import 'models/student_store.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/student_detail_screen.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_form_screen.dart';

void main() => runApp(const StudentManagerApp());

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    final uri = Uri.tryParse(name);

    // Accept custom Android links such as studentapp://student/detail?id=S001
    // and route-style URLs such as /students/detail?id=S001.
    final isDeepLink = (uri != null && uri.scheme == 'studentapp' &&
            uri.host == 'student' && uri.path == '/detail') ||
        name.startsWith('${AppRoutes.studentDetail}?');
    if (isDeepLink) {
      final id = uri?.queryParameters['id'] ??
          Uri.tryParse(name)?.queryParameters['id'];
      final student = id == null ? null : StudentStore.instance.findById(id);
      if (student == null) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const _DeepLinkNotFoundScreen(),
        );
      }
      return MaterialPageRoute<void>(
        settings: RouteSettings(name: AppRoutes.studentDetail, arguments: student),
        builder: (_) => const StudentDetailScreen(),
      );
    }

    // If a deep link arrives in a format we do not recognize, show a safe fallback.
    if (uri != null && uri.hasScheme && uri.scheme == 'studentapp') {
      return MaterialPageRoute<void>(builder: (_) => const _DeepLinkNotFoundScreen());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.studentList: (_) => const StudentListScreen(),
        AppRoutes.studentDetail: (_) => const StudentDetailScreen(),
        AppRoutes.studentForm: (_) => const StudentFormScreen(),
      },
      onGenerateRoute: _generateRoute,
      onUnknownRoute: (_) => MaterialPageRoute<void>(builder: (_) => const _DeepLinkNotFoundScreen()),
    );
  }
}

class _DeepLinkNotFoundScreen extends StatelessWidget {
  const _DeepLinkNotFoundScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Không tìm thấy sinh viên')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.link_off, size: 56),
              const SizedBox(height: 12),
              const Text('Deep link không hợp lệ hoặc mã sinh viên không tồn tại.', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false),
                child: const Text('Về trang chủ'),
              ),
            ]),
          ),
        ),
      );
}
