import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const OneeApp());
}

/// Palette ONEE (Office National de l'Électricité et de l'Eau).
class OneeColors {
  static const Color primary = Color(0xFF0B6E4F); // vert ONEE
  static const Color primaryDark = Color(0xFF084C37);
  static const Color accent = Color(0xFFF7A41D); // jaune/orange
  static const Color bg = Color(0xFFF4F6F8);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF1C2B27);
  static const Color textMuted = Color(0xFF6B7C77);
  static const Color danger = Color(0xFFD64545);
  static const Color success = Color(0xFF2E9E5B);
}

class OneeApp extends StatelessWidget {
  const OneeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ONEE Technicien',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: OneeColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: OneeColors.primary,
          primary: OneeColors.primary,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: OneeColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          color: OneeColors.card,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: OneeColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
