import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);
    const Color darkColor = Color(0xFF1A1A1A);

    final List<Map<String, String>> categories = [
      {'image': 'lib/assets/food.png', 'label': 'Food'},
      {'image': 'lib/assets/hotel.png', 'label': 'Hotel'},
      {'image': 'lib/assets/cafe.png', 'label': 'Cafe'},
      {'image': 'lib/assets/forest.png', 'label': 'Nature'},
      {'image': 'lib/assets/bar.png', 'label': 'Bar'},
      {'image': 'lib/assets/holiday.png', 'label': 'Holiday'},
    ];

    return Scaffold(
      backgroundColor: brandYellow, // Background utama kuning agar saat scroll tidak ada celah
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
                        // Logo pakai cao_logo.png
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
                        children: categories.map((cat) {
                          return _buildCategory(cat['image']!, cat['label']!);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // putih (melengkung ke atas)
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
          
          // navbar
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
                  // Icon Home dengan buletan hitam di belakang
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(PhosphorIconsRegular.house, color: brandYellow, size: 26),
                  ),
                  const Icon(PhosphorIconsRegular.magnifyingGlass, color: Colors.black, size: 28),
                  const Icon(PhosphorIconsRegular.plus, color: Colors.black, size: 28),
                  const Icon(PhosphorIconsRegular.bell, color: Colors.black, size: 28),
                  const Icon(PhosphorIconsRegular.bookmarkSimple, color: Colors.black, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String imagePath, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 70,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
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