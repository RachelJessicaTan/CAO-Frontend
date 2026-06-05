import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;
  
  int _selectedCategoryIndex = -1;

  final List<Map<String, String>> categories = [
    {'image': 'lib/assets/food.png', 'label': 'Food'},
    {'image': 'lib/assets/hotel.png', 'label': 'Hotel'},
    {'image': 'lib/assets/cafe.png', 'label': 'Cafe'},
    {'image': 'lib/assets/forest.png', 'label': 'Nature'},
    {'image': 'lib/assets/bar.png', 'label': 'Bar'},
    {'image': 'lib/assets/holiday.png', 'label': 'Holiday'},
  ];

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);

    return Scaffold(
      backgroundColor: brandYellow, 
      body: Stack(
        children: [
          Column(
            children: [
              // kuning atas
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
                    const SizedBox(height: 32),
                    const Text(
                      'Find a\nplace to go?',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
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
              
              // putih
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
                        const Text(
                          'Hype spots',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        _buildSpotCard(
                          'The Post',
                          'Cipete, Jakarta Selatan',
                          '517',
                          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
                        ),
                        const SizedBox(height: 24),
                        _buildSpotCard(
                          'Sudestada',
                          'Jl. Irian, Jakarta Pusat',
                          '842',
                          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // navbar dengan Animasi
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
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnimatedNavIndex(0, PhosphorIconsRegular.house),
                  _buildAnimatedNavIndex(1, PhosphorIconsRegular.magnifyingGlass),
                  _buildAnimatedNavIndex(2, PhosphorIconsRegular.plus),
                  _buildAnimatedNavIndex(3, PhosphorIconsRegular.bell),
                  _buildAnimatedNavIndex(4, PhosphorIconsRegular.bookmarkSimple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Animasi Ketukan untuk Kategori Atas
  Widget _buildAnimatedCategory({required int index, required String imagePath, required String label}) {
    final bool isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = isSelected ? -1 : index;
        });
      },
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
                  color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavIndex(int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
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
            size: isActive ? 26 : 28
          ),
        ),
      ),
    );
  }

  Widget _buildSpotCard(String title, String loc, String count, String imgUrl) {
    return Container(
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
            child: Image.network(imgUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(loc, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(PhosphorIconsRegular.chatCircle, size: 16),
                        const SizedBox(width: 4),
                        Text(count, style: const TextStyle(fontSize: 14)),
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