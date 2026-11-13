import 'package:flutter/material.dart';
import 'package:flutter_application_7/screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BloodBankApp());
}

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFB71C1C);
    return MaterialApp(
      title: 'نظام إدارة بنك الدم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryRed,
          primary: primaryRed,
          surface: const Color(0xFFF8F8F8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        fontFamily: 'Tajawal',
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: WelcomeScreen(),
    );
  }
}
