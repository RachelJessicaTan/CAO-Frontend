import 'package:flutter/material.dart';
import 'package:frontend/pages/NotificationPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/SearchPage.dart';
import 'package:frontend/pages/AddPlacePage.dart';
import 'package:frontend/pages/SavedPlacesPage.dart';
import 'package:frontend/pages/PlaceDetailPage.dart';
import 'package:frontend/pages/ProfilePage.dart'; // IMPORT PROFILE PAGE DI SINI

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentNavIndex = 0; 
  int _selectedCategoryIndex = -1;

  final List<Map<String, String>> categories = [
    {'image': 'lib/assets/food.png', 'label': 'Food'},
    {'image': 'lib/assets/hotel.png', 'label': 'Hotel'},
    {'image': 'lib/assets/cafe.png', 'label': 'Cafe'},
    {'image': 'lib/assets/forest.png', 'label': 'Nature'},
    {'image': 'lib/assets/bar.png', 'label': 'Bar'},
    {'image': 'lib/assets/holiday.png', 'label': 'Holiday'},
  ];

  final List<Map<String, String>> spots = [
    {
      'title': 'The Post',
      'loc': 'Cipete, Jakarta Selatan',
      'count': '517',
      'img': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
    },
    {
      'title': 'Sudestada',
      'loc': 'Jl. Irian, Jakarta Pusat',
      'count': '842',
      'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
    },
  ];

  // Fungsi transisi kustom (Disamakan persis dengan AddPlacePage)
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
      backgroundColor: brandYellow,
      body: Stack(
        children: [
          Column(
            children: [
              // Kuning atas
              Container(
                width: double.infinity,
                color: brandYellow,
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('lib/assets/cao_logo.png', height: 30, fit: BoxFit.contain),
                        // MODIFIKASI DI SINI: Membungkus ikon user dengan GestureDetector untuk ke ProfilePage
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              _createSmoothRoute(const ProfilePage()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                            child: const Icon(PhosphorIconsRegular.user, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Find a\nplace to go?',
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1.1),
                    ),
                    const SizedBox(height: 32),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          return _buildAnimatedCategory(
                            index: index,
                            imagePath: categories[index]['image']!,
                            label: categories[index]['label']!,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hype spots', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        ...spots.map((spot) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildSpotCard(spot),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
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
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
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

  Widget _buildAnimatedCategory({required int index, required String imagePath, required String label}) {
    final bool isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryIndex = isSelected ? -1 : index),
      child: AnimatedScale(
        scale: isSelected ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          width: 70,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                ),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavIndex(BuildContext context, int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (icon == PhosphorIconsRegular.house) return; 
        
        if (icon == PhosphorIconsRegular.magnifyingGlass) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const SearchPage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.plus) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const AddPlacePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.bell) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const NotificationPage()), (route) => false);
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

  Widget _buildSpotCard(Map<String, String> spot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _createSmoothRoute(PlaceDetailPage(spot: spot)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(spot['img']!, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(spot['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(spot['loc']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(PhosphorIconsRegular.chatCircle, size: 16),
                          const SizedBox(width: 4),
                          Text(spot['count']!, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSmallTag(PhosphorIconsRegular.shoppingBag),
                      const SizedBox(width: 8),
                      _buildSmallTag(PhosphorIconsRegular.forkKnife),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTag(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: Icon(icon, color: const Color(0xFFFCDD3F), size: 16),
    );
  }
}