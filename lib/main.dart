import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/theme/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:libratrack_application/features/navigation/admin_navigation_bar.dart';
import 'package:libratrack_application/features/navigation/main_screen.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final prefs = await SharedPreferences.getInstance();
  AppColors.isDark = prefs.getBool('dark_mode') ?? false;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      key: ValueKey(isDark),
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
    );
  }
}

class SplashDecider extends ConsumerStatefulWidget {
  const SplashDecider({super.key});

  @override
  ConsumerState<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends ConsumerState<SplashDecider> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = ref.read(authProvider);
    if (auth.isLoggedIn) {
      await Future.delayed(Duration.zero);
      if (!mounted) {
        FlutterNativeSplash.remove();
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => auth.admin != null
              ? const AdminNavigationBar()
              : const MainScreen(),
        ),
      );
      FlutterNativeSplash.remove();
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    final token = await ApiService.getToken();
    final role = await ApiService.getRole();

    if (token != null && token.isNotEmpty) {
      if (!mounted) {
        FlutterNativeSplash.remove();
        return;
      }
      await ref.read(authProvider.notifier).loadCurrentUser();
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (!mounted) {
      FlutterNativeSplash.remove();
      return;
    }

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
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // Normally never visible: the native splash stays up until _checkAuth
    // navigates away. Pixel-matches the Android 12 native splash (same icon
    // asset, same 288dp box, centered) so that if a frame does slip through
    // the hand-off is invisible.
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F8),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/android12_splash.png'),
          width: 288,
          height: 288,
        ),
      ),
    );
  }
}
