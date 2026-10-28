import 'package:flutter_test/flutter_test.dart';
import 'package:slot6_student_list_app/main.dart';

void main() {
  testWidgets('Student list screen displays sample students', (tester) async {
    await tester.pumpWidget(const StudentListApp());

    expect(find.text('Student List'), findsOneWidget);
    expect(find.text('Nguyễn Văn A'), findsOneWidget);
    expect(find.text('Student directory'), findsOneWidget);
  });

  testWidgets('Selecting a student updates selected count', (tester) async {
    await tester.pumpWidget(const StudentListApp());

    expect(find.text('0 selected'), findsOneWidget);
    await tester.tap(find.byTooltip('Chọn sinh viên').first);
    await tester.pump();

    expect(find.text('1 selected'), findsOneWidget);
  });

  testWidgets('Tapping a student opens the detail screen', (tester) async {
    await tester.pumpWidget(const StudentListApp());

    await tester.tap(find.text('Nguyễn Văn A'));
    await tester.pumpAndSettle();

    expect(find.text('Student Detail'), findsOneWidget);
    expect(find.text('a@student.edu'), findsOneWidget);
    expect(find.text('Computer Science'), findsOneWidget);
  });
}
