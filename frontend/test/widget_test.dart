import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('PapacapimApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PapacapimApp());
    expect(find.byType(PapacapimApp), findsOneWidget);
  });
}
