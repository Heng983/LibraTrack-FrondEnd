import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
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
    if (defaultTargetPlatform == TargetPlatform.android) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();
      });
    }

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
    // Pixel-matches the Android 12 native splash: the same icon asset at the
    // same size (1152px spec = 288dp box) centered on screen, so the icon
    // does not move when Flutter takes over — only the wordmark fades in
    // below it. iOS never shows this screen (its native splash stays up
    // until navigation).
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Stack(
        children: [
          const Center(
            child: Image(
              image: AssetImage('assets/images/android12_splash.png'),
              width: 288,
              height: 288,
            ),
          ),
          Center(
            child: Transform.translate(
              // Icon artwork ends 64dp below center (512px of the 1152px
              // canvas); place the wordmark just under it.
              offset: const Offset(0, 106),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 350),
                builder: (_, opacity, child) =>
                    Opacity(opacity: opacity, child: child),
                child: const Image(
                  image: AssetImage('assets/images/splash_wordmark.png'),
                  width: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
