import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/views/pages/home_page.dart';
import 'package:frontend/views/pages/search_page.dart';
import 'package:frontend/views/pages/add_place_page.dart';
import 'package:frontend/views/pages/notification_page.dart';
import 'package:frontend/views/pages/saved_places_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  static Route _smoothRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;
    final pages = [
      const HomePage(),
      const SearchPage(),
      const AddPlacePage(),
      const NotificationPage(),
      const SavedPlacesPage(),
    ];
    Navigator.pushAndRemoveUntil(context, _smoothRoute(pages[index]), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      PhosphorIconsRegular.house,
      PhosphorIconsRegular.magnifyingGlass,
      PhosphorIconsRegular.plus,
      PhosphorIconsRegular.bell,
      PhosphorIconsRegular.bookmarkSimple,
    ];

    return Positioned(
      bottom: 30,
      left: 32,
      right: 32,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.brandYellow,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(icons.length, (i) {
            final isActive = i == currentIndex;
            return GestureDetector(
              onTap: () => _navigate(context, i),
              child: AnimatedScale(
                scale: isActive ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.all(isActive ? 12 : 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.black : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icons[i], color: isActive ? AppColors.brandYellow : AppColors.black, size: isActive ? 26 : 28),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}