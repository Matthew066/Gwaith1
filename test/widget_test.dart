// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gwaithh/screens/create_page.dart';

void main() {
  testWidgets('Create page shows actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreatePage(
            boardNames: const [],
            onCreatePin:
                ({
                  required String title,
                  required String author,
                  required String description,
                  required String imageUrl,
                  String? boardName,
                }) {},
            onCreateBoard: ({required String name, required bool isPrivate}) {},
            onCreateCollage:
                ({required String title, required String theme}) {},
          ),
        ),
      ),
    );

    expect(find.text('Buat Sesuatu yang Baru'), findsOneWidget);
    expect(find.text('Buat Pin'), findsOneWidget);
    expect(find.text('Buat Papan'), findsOneWidget);
    expect(find.text('Buat Kolase'), findsOneWidget);
  });
}
