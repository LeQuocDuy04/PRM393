import 'package:flutter_test/flutter_test.dart';
import 'package:student_manager_app/main.dart';

void main() {
  testWidgets('Home screen displays navigation button', (tester) async {
    await tester.pumpWidget(const StudentManagerApp());
    expect(find.text('Quản lý sinh viên'), findsOneWidget);
    expect(find.text('Xem danh sách sinh viên'), findsOneWidget);
  });

  testWidgets('Can navigate from home to student list and detail', (tester) async {
    await tester.pumpWidget(const StudentManagerApp());
    await tester.tap(find.text('Xem danh sách sinh viên'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Danh sách sinh viên'), findsOneWidget);
    await tester.tap(find.text('Nguyễn Văn An'));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết sinh viên'), findsOneWidget);
    expect(find.text('S001'), findsOneWidget);
  });
}
