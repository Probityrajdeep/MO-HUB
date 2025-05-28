import 'package:flutter_test/flutter_test.dart';
import 'package:mo_hub/main.dart';

void main() {
  testWidgets('Login page shows correct title', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify that the login page text is displayed
    expect(find.text('Login to Mo Hub'), findsOneWidget);
  });
}
