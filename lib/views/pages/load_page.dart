import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/views/pages/home_page.dart';
import 'package:frontend/views/pages/admin_page.dart';

// ─── LOAD PAGE ────────────────────────────────────────────────
class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandYellow,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Center(child: Image.asset('lib/assets/cao_logo.png', height: 60)),
            const Spacer(flex: 3),
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.black, foregroundColor: AppColors.brandYellow, elevation: 0, shape: const StadiumBorder()),
                      child: const Text('Create new account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.black,
                        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                        elevation: 2, shadowColor: Colors.black.withOpacity(0.2),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('I already have an account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOGIN PAGE ───────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final vm = context.read<AuthViewModel>();
    final success = await vm.login(_emailController.text.trim(), _passwordController.text);
    if (!mounted) return;
    if (success) {
      if (vm.isAdmin) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const AdminPage()), (r) => false);
      } else {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomePage()), (r) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
                child: IconButton(
                  alignment: Alignment.centerLeft, padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft, color: AppColors.black, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      const Text('Welcome back', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -0.5)),
                      const SizedBox(height: 48),
                      _field(label: 'Email', hint: 'hello@cao.com', controller: _emailController),
                      const SizedBox(height: 24),
                      _field(label: 'Password', hint: '••••••••', controller: _passwordController,
                          isPassword: true, obscure: _obscure, onToggle: () => setState(() => _obscure = !_obscure)),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bottomBar(label: 'Log In', isLoading: vm.isLoading, onPressed: _login),
      ),
    );
  }
}

// ─── SIGNUP PAGE ──────────────────────────────────────────────
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }
    final vm = context.read<AuthViewModel>();
    final success = await vm.register(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
    if (!mounted) return;
    if (success) {
      // Register selalu jadi user biasa, langsung ke HomePage
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const HomePage()), (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Registration failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
                child: IconButton(
                  alignment: Alignment.centerLeft, padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft, color: AppColors.black, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      const Text('Create account', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -0.5)),
                      const SizedBox(height: 48),
                      _field(label: 'Full Name', hint: 'John Doe', controller: _nameController),
                      const SizedBox(height: 24),
                      _field(label: 'Email', hint: 'hello@cao.com', controller: _emailController),
                      const SizedBox(height: 24),
                      _field(label: 'Password', hint: '••••••••', controller: _passwordController,
                          isPassword: true, obscure: _obscure, onToggle: () => setState(() => _obscure = !_obscure)),
                      const SizedBox(height: 24),
                      _field(label: 'Reconfirm Password', hint: '••••••••', controller: _confirmController,
                          isPassword: true, obscure: _obscureConfirm, onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bottomBar(label: 'Sign Up', isLoading: vm.isLoading, onPressed: _register),
      ),
    );
  }
}

// ─── SHARED HELPERS ───────────────────────────────────────────
Widget _field({
  required String label,
  required String hint,
  required TextEditingController controller,
  bool isPassword = false,
  bool obscure = false,
  VoidCallback? onToggle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        const Text('*', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
      TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        cursorColor: AppColors.black,
        style: const TextStyle(color: AppColors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.black, width: 2)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: isPassword
              ? IconButton(
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                  icon: PhosphorIcon(obscure ? PhosphorIconsRegular.eyeSlash : PhosphorIconsRegular.eye,
                      color: Colors.grey.shade500, size: 22),
                  onPressed: onToggle)
              : null,
        ),
      ),
    ],
  );
}

Widget _bottomBar({required String label, required bool isLoading, required VoidCallback onPressed}) {
  return Container(
    color: AppColors.white,
    padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
    child: SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black, foregroundColor: AppColors.brandYellow,
          shape: const StadiumBorder(), elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.brandYellow, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}