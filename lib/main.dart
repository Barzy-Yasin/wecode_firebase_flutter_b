import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wecode_firebase_flutter_b/firebase_options.dart';
import 'package:wecode_firebase_flutter_b/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const RootApp());
}
