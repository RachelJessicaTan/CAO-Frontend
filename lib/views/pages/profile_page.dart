import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/views/pages/load_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        final user = vm.user;
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              Container(
                color: AppColors.brandYellow,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                width: double.infinity,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.black.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80, height: 80,
                      decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                      child: const Icon(PhosphorIconsRegular.user, color: AppColors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(user?.name ?? 'Guest',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '',
                        style: TextStyle(fontSize: 14, color: AppColors.black.withOpacity(0.6))),
                    if (vm.isAdmin) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Admin', style: TextStyle(color: AppColors.brandYellow, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _tile(icon: PhosphorIconsRegular.user, label: 'Edit Profile', onTap: () {}),
                    _tile(icon: PhosphorIconsRegular.bell, label: 'Notifications', onTap: () {}),
                    _tile(icon: PhosphorIconsRegular.lock, label: 'Privacy & Security', onTap: () {}),
                    const Divider(height: 32),
                    _tile(
                      icon: PhosphorIconsRegular.signOut,
                      label: 'Log Out',
                      color: AppColors.error,
                      onTap: () async {
                        await vm.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (_) => const LoadPage()), (r) => false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile({required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.black, size: 22),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: color ?? AppColors.black)),
      trailing: color == null ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}