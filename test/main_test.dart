import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/views/poc_pod_screen.dart';
import 'package:driver_app/views/profile_screen.dart';

void main() {
  testWidgets('Bottom navigation bar switches between screens', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that PocPodScreen is displayed initially
    expect(find.text('POD'), findsOneWidget);
    expect(find.byType(PocPodScreen), findsOneWidget);

    // Tap on the second tab (Profile)
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify that ProfileScreen is displayed
    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}