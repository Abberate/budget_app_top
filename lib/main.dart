import 'package:budget_app/firebase_options.dart';
import 'package:budget_app/responsive_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAAXlL0fnfrDu8ZtwEyqlvj3N6DSG41efk",
            authDomain: "budget-app-fb214.firebaseapp.com",
            projectId: "budget-app-fb214",
            storageBucket: "budget-app-fb214.firebasestorage.app",
            messagingSenderId: "762369467211",
            appId: "1:762369467211:web:d9e78cb608aa7cb9eb3ece",
            measurementId: "G-VWBZ7HLCJ8"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(useMaterial3: true),
      home: ResponsiveHandler(),
    );
  }
}
