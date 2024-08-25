import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:ratemyprofessor/page/mobileversion/signup.dart';
import 'package:ratemyprofessor/page/webversion/signup.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getAppropriateWidget(),
    );
  }

  Widget _getAppropriateWidget() {
    if (kIsWeb) {
      return const WebSignup();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return const MobileSignup();
    } else {
      return const Center(
        child: Text("Platform not supported"),
      );
    }
  }
}
