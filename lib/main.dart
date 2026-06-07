import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/viewmodels/place_viewmodel.dart';
import 'package:frontend/viewmodels/saved_viewmodel.dart';
import 'package:frontend/views/pages/load_page.dart';
import 'package:frontend/views/pages/home_page.dart';
import 'package:frontend/views/pages/admin_page.dart';
import 'package:frontend/core/services/token_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PlaceViewModel()),
        ChangeNotifierProvider(create: (_) => SavedViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CAO',
        theme: ThemeData(
          fontFamily: 'Sans-Serif',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFCDD3F)),
          useMaterial3: true,
        ),
        home: const SplashRouter(),
      ),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final isLoggedIn = await TokenService.instance.isLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      await context.read<AuthViewModel>().loadUser();
      if (!mounted) return;
      final isAdmin = context.read<AuthViewModel>().isAdmin;
      if (isAdmin) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const AdminPage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoadPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFCDD3F),
      body: Center(child: CircularProgressIndicator(color: Colors.black)),
    );
  }
}