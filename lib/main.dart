import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/admin/providers/borrow_request_provider.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_provider.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:libratrack_application/features/book_catalog/providers/book_provider.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:libratrack_application/features/navigation/admin_navigation_bar.dart';
import 'package:libratrack_application/features/navigation/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BorrowCartProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => BorrowRequestProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LibraTrack',
        home: const SplashDecider(),
        routes: {
          '/admin': (context) => const AdminNavigationBar(),
          '/admin/dashboard': (context) => const AdminNavigationBar(),
          '/student': (context) => const MainScreen(),
          '/login': (context) => const StudentLoginScreen(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        ),
      ),
    );
  }
}

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await ApiService.getToken();
    final role = await ApiService.getRole();

    if (token != null && token.isNotEmpty) {
      await context.read<AuthProvider>().loadCurrentUser();
    }

    FlutterNativeSplash.remove();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminNavigationBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F8),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
