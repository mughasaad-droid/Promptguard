import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'admin_screens/admin_control_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: "YOUR_FIREBASE_API_KEY"),
        authDomain: "promptguard-d1559.firebaseapp.com",
        projectId: "promptguard-d1559",
        storageBucket: "promptguard-d1559.firebasestorage.app",
        messagingSenderId: "622915739922",
        appId: "1:622915739922:web:0707b57fba2b3e0f8ed3cb",
        measurementId: "G-WX14C75V8Q",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const PromptGuardAdminApp());
}

class PromptGuardAdminApp extends StatelessWidget {
  const PromptGuardAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PromptGuard Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AdminControlScreen(),
    );
  }
}
