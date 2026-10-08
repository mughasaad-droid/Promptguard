import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/mock_data.dart';
import 'theme/app_theme.dart';
import 'widgets/shared_widgets.dart';
import 'screens/dashboard_screen.dart';
import 'screens/audit_logs_screen.dart';
import 'screens/policy_config_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("Initializing Firebase...");

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

    debugPrint("Firebase Initialized Successfully");
    runApp(const PromptGuardApp());
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error: $e")),
      ),
    ));
  }
}

class PromptGuardApp extends StatelessWidget {
  const PromptGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppData(),
      child: MaterialApp(
        title: 'PromptGuard Firewall',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const RootShell();
        }
        return const AuthScreen();
      },
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int index = 0;

  static const titles = ['Dashboard', 'Audit Logs', 'Configuration', 'More'];

  final pages = const [
    DashboardScreen(),
    AuditLogsScreen(),
    PolicyConfigScreen(),
    _MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const BrandMark(),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PromptGuard Firewall', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                Text(titles[index], style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_rounded), label: 'Audit Logs'),
          NavigationDestination(icon: Icon(Icons.tune_rounded), label: 'Config'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'More'),
        ],
      ),
    );
  }
}

class _MoreScreen extends StatelessWidget {
  const _MoreScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'SYSTEM HEALTH  ·  LIVE'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _HealthRow(icon: Icons.speed_rounded, label: 'Latency (p95)', value: '148 ms', color: AppColors.success),
                  Divider(height: 20),
                  _HealthRow(icon: Icons.bolt_rounded, label: 'Throughput', value: '24.6k evals/min', color: AppColors.brandSecondary),
                  Divider(height: 20),
                  _HealthRow(icon: Icons.error_outline_rounded, label: 'Error Rate', value: '0.02%', color: AppColors.success),
                  Divider(height: 20),
                  _HealthRow(icon: Icons.check_circle_outline_rounded, label: 'Uptime', value: '99.98%', color: AppColors.success),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'ACCOUNT'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.redAccent)),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _HealthRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}
