import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/AddPlacePage.dart';
import 'package:frontend/pages/SavedPlacesPage.dart';
import 'package:frontend/pages/PlaceDetailPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 1;

  final List<Map<String, String>> trendingSpots = [
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
    {
      'title': 'Fogo de Chão',
      'loc': 'SCBD, Jakarta Selatan',
      'count': '391',
      'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1000&auto=format&fit=crop',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('lib/assets/cao_logo.png', height: 30, fit: BoxFit.contain),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: const Icon(PhosphorIconsRegular.user, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Search places...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass, color: Colors.grey.shade400, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (val) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Trending', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ...trendingSpots.map((spot) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildSpotCard(spot),
                      )),
                    ],
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
                  _buildNavItem(0, PhosphorIconsRegular.house),
                  _buildNavItem(1, PhosphorIconsRegular.magnifyingGlass),
                  _buildNavItem(2, PhosphorIconsRegular.plus),
                  _buildNavItem(3, PhosphorIconsRegular.bell),
                  _buildNavItem(4, PhosphorIconsRegular.bookmarkSimple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
          return;
        }
        if (index == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddPlacePage()));
          return;
        }
        if (index == 4) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SavedPlacesPage()));
          return;
        }
        setState(() => _currentNavIndex = index);
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
          MaterialPageRoute(builder: (context) => PlaceDetailPage(spot: spot)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(spot['img']!, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(spot['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(spot['loc']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(PhosphorIconsRegular.chatCircle, size: 15),
                          const SizedBox(width: 4),
                          Text(spot['count']!, style: const TextStyle(fontSize: 13)),
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