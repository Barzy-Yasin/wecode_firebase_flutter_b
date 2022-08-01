import 'package:flutter/material.dart';
import 'package:wecode_firebase_flutter_b/src/screens/crud_operation_screen.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CrudOperationsScreen(),
    );
  }
}
