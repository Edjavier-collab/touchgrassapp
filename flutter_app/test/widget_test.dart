import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:touchgrass_flutter/presentation/app.dart';

void main() {
  testWidgets('TouchGrass app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: TouchGrassApp(),
      ),
    );

    // Verify that the app starts with either home page or onboarding
    expect(find.text('Touch-Gras'), findsOneWidget);
  });
}
