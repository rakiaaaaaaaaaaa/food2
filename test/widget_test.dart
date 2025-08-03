import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food2/main.dart';

void main() {
  testWidgets('App loads StartupView', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify that StartupView's logo is shown
    expect(find.byType(Image), findsWidgets);
  });
}
