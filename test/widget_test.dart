import 'package:flutter_test/flutter_test.dart';
import 'package:saeg_al_ouqoud/main.dart' as app;

void main() {
  testWidgets('App should start', (WidgetTester tester) async {
    await tester.pumpWidget(const app.SaegApp());
    expect(find.byType(app.SaegApp), findsOneWidget);
  });
}