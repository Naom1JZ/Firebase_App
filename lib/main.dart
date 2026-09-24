import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/firestore_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RegistroConectadoApp());
}

class RegistroConectadoApp extends StatelessWidget {
  const RegistroConectadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguimiento de entregas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff126782)),
        scaffoldBackgroundColor: const Color(0xfff6f4ef),
        useMaterial3: true,
      ),
      home: const FirestoreHomePage(),
    );
  }
}
