import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/HomePage.dart';
import 'package:frontend/pages/SearchPage.dart';
import 'package:frontend/pages/AddPlacePage.dart';
import 'package:frontend/pages/SavedPlacesPage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final int _currentNavIndex = 3; 

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Spot Baru Ditambahkan!',
      'desc': 'Admin CAO added place near Gading Serpong, Tangerang.',
      'time': '2 jam yang lalu',
      'isUnread': true,
      'icon': PhosphorIconsRegular.checkCircle,
    },
    {
      'title': 'Spot Baru Ditambahkan!',
      'desc': 'Admin CAO added place near Cipete, Jakarta Selatan.',
      'time': 'Dini hari tadi',
      'isUnread': false,
      'icon': PhosphorIconsRegular.checkCircle,
    },
    {
      'title': 'Spot Baru Ditambahkan!',
      'desc': 'Admin CAO added place near SCBD, Jakarta Selatan.',
      'time': '2 hari yang lalu',
      'isUnread': false,
      'icon': PhosphorIconsRegular.checkCircle,
    },
  ];

  // KUNCI MULUS: Fungsi pembuat transisi kustom (Fade & Slide halus) disamakan dengan halaman lain
  Route _createSmoothRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.02), // Geser tipis dari bawah ke atas
              end: Offset.zero,
            ).animate(curvedAnimation),
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
      body: Stack(
        children: [
          Column(
            children: [
              // Header Atas
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'lib/assets/cao_logo.png',
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(PhosphorIconsRegular.user, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 120),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return _buildNotificationCard(
                      title: item['title'],
                      desc: item['desc'],
                      time: item['time'],
                      isUnread: item['isUnread'],
                      icon: item['icon'],
                    );
                  },
                ),
              ),
            ],
          ),

          // Navbar Bawah
          Positioned(
            bottom: 30,
            left: 32,
            right: 32,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: brandYellow,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnimatedNavIndex(context, 0, PhosphorIconsRegular.house),
                  _buildAnimatedNavIndex(context, 1, PhosphorIconsRegular.magnifyingGlass),
                  _buildAnimatedNavIndex(context, 2, PhosphorIconsRegular.plus),
                  _buildAnimatedNavIndex(context, 3, PhosphorIconsRegular.bell),
                  _buildAnimatedNavIndex(context, 4, PhosphorIconsRegular.bookmarkSimple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFFFFBE6) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnread ? const Color(0xFFFCDD3F).withOpacity(0.4) : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Color(0xFFFCDD3F), shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.3),
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedNavIndex(BuildContext context, int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        if (icon == PhosphorIconsRegular.bell) return;

        // MODIFIKASI: Membungkus semua routing halaman dengan _createSmoothRoute agar transisi seragam
        if (icon == PhosphorIconsRegular.house) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const HomePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.magnifyingGlass) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const SearchPage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.plus) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const AddPlacePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.bookmarkSimple) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const SavedPlacesPage()), (route) => false);
        }
      },
      child: AnimatedScale(
        scale: isActive ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(isActive ? 12 : 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? const Color(0xFFFCDD3F) : Colors.black,
            size: isActive ? 26 : 28,
          ),
        ),
      ),
    );
  }
}