import 'package:frontend/pages/LoginPage.dart';
import 'package:frontend/pages/NotificationPage.dart';
import 'package:frontend/pages/SavedPlacesPage.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  String _userName = 'Rachelle Tan';
  String _userEmail = 'rachelle@cao.com';

  // FIX AMAN: Langsung diinisialisasi di sini tanpa kata kunci 'late' dan tanpa 'initState'
  final TextEditingController _nameController = TextEditingController(text: 'Rachelle Tan');
  final TextEditingController _emailController = TextEditingController(text: 'rachelle@email.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your current password:', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Enter your new password below:', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password has been changed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.black.withOpacity(0.9),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Update', style: TextStyle(color: Color(0xFFFCDD3F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to log out?', style: TextStyle(fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const LoginPage()
                  ),
                  (route) => false
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('You have been logged out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.black.withOpacity(0.9),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Route<T> _createSmoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.0, 0.02), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Atas
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset('lib/assets/cao_logo.png', height: 30, fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text('cao!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Konten Utama Profile
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                children: [
                  // Card Utama Info Pengguna
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Stack(
                      children: [
                        // Tombol Edit / Save di Pojok Kanan Atas
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_isEditing) {
                                  _userName = _nameController.text;
                                  _userEmail = _emailController.text;
                                }
                                _isEditing = !_isEditing;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isEditing ? const Color(0xFFFCDD3F) : Colors.black, 
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isEditing ? Icons.check : PhosphorIconsRegular.pencilSimple,
                                color: _isEditing ? Colors.black : const Color(0xFFFCDD3F),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        
                        // Isi Konten Profil Tengah
                        Column(
                          children: [
                            // Avatar Utama (Feedback Kamera saat Edit)
                            GestureDetector(
                              onTap: () {
                                if (_isEditing) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Simulasi: Membuka Image Picker / Galeri')),
                                  );
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                    child: const CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.white,
                                      child: Icon(PhosphorIconsRegular.user, color: Colors.black, size: 48),
                                    ),
                                  ),
                                  if (_isEditing)
                                    Container(
                                      width: 102,
                                      height: 102,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(PhosphorIconsRegular.camera, color: Colors.white, size: 28),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Input Fields / Teks biasa dengan Feedback Sorotan Form
                            if (!_isEditing) ...[
                              Text(_userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(_userEmail, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: brandYellow, width: 2),
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(hintText: 'Name', contentPadding: EdgeInsets.zero, border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: brandYellow, width: 2),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                  decoration: const InputDecoration(hintText: 'Email', contentPadding: EdgeInsets.zero, border: InputBorder.none),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            
                            // Statistik
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('12', 'Saved Spots'),
                                Container(height: 30, width: 1, color: Colors.grey.shade200),
                                _buildStatItem('4', 'Folders'),
                                Container(height: 30, width: 1, color: Colors.grey.shade200),
                                _buildStatItem('38', 'Reviews'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card Menu List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          PhosphorIconsRegular.bookmarkSimple, 
                          'Saved Places', 
                          'View and organize your spots',
                          onTap: () => Navigator.push(context, _createSmoothRoute(const SavedPlacesPage())),
                        ),
                        _buildMenuTile(
                          PhosphorIconsRegular.key, 
                          'Change Password', 
                          'Update your secret security credentials',
                          onTap: _showChangePasswordDialog,
                        ),
                        _buildMenuTile(
                          PhosphorIconsRegular.bellSimple, 
                          'Notifications', 
                          'Control alerts and updates',
                          onTap:() => Navigator.push(context, _createSmoothRoute(const NotificationPage())),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Divider(height: 1),
                        ),
                        _buildMenuTile(
                          PhosphorIconsRegular.signOut, 
                          'Log Out', 
                          'Sign out from this account', 
                          isLogout: true,
                          onTap: _showLogOutDialog,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, {VoidCallback? onTap, bool isLogout = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.1) : Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isLogout ? Colors.red : const Color(0xFFFCDD3F), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isLogout ? Colors.red : Colors.black),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
    );
  }
}