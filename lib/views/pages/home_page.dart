import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/viewmodels/place_viewmodel.dart';
import 'package:frontend/views/widgets/bottom_nav_bar.dart';
import 'package:frontend/views/widgets/place_card.dart';
import 'package:frontend/views/pages/place_detail_page.dart';
import 'package:frontend/views/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PlaceViewModel>();
      vm.loadCategories();
      vm.loadPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.brandYellow,
          body: Stack(
            children: [
              Column(
                children: [
                  // Header kuning
                  Container(
                    color: AppColors.brandYellow,
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('lib/assets/cao_logo.png', height: 30, fit: BoxFit.contain),
                            GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const ProfilePage())),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                                child: const Icon(PhosphorIconsRegular.user, color: AppColors.white, size: 24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text('Find a\nplace to go?',
                            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1.1)),
                        const SizedBox(height: 32),

                        // Category scroll
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              // "All" button
                              _buildCategoryChip(
                                label: 'All',
                                isSelected: vm.selectedCategory == null,
                                onTap: () => vm.selectCategory(null),
                                imagePath: null,
                              ),
                              ...vm.categories.map((cat) => _buildCategoryChip(
                                label: cat.name,
                                isSelected: vm.selectedCategory == cat.slug,
                                onTap: () => vm.selectCategory(cat.slug),
                                imagePath: _categoryImage(cat.slug),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Putih konten
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: vm.isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.brandYellow))
                          : vm.places.isEmpty
                              ? Center(child: Text('No places found', style: TextStyle(color: Colors.grey.shade400)))
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vm.selectedCategory == null ? 'Hype spots' : 'Results',
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 24),
                                      ...vm.places.map((place) => Padding(
                                        padding: const EdgeInsets.only(bottom: 24),
                                        child: PlaceCard(
                                          place: place,
                                          onTap: () async {
                                            await Navigator.push(context,
                                                MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place)));
                                            if (mounted) {
                                              context.read<PlaceViewModel>().loadPlaces(category: vm.selectedCategory);
                                            }
                                          },
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
              const BottomNavBar(currentIndex: 0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                  color: AppColors.black,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: AppColors.white, width: 3) : null,
                ),
                child: imagePath != null
                    ? Image.asset(imagePath, fit: BoxFit.contain)
                    : const Icon(PhosphorIconsRegular.squaresFour, color: AppColors.brandYellow, size: 20),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  String? _categoryImage(String slug) {
    const map = {
      'food': 'lib/assets/food.png',
      'hotel': 'lib/assets/hotel.png',
      'cafe': 'lib/assets/cafe.png',
      'nature': 'lib/assets/forest.png',
      'bar': 'lib/assets/bar.png',
      'holiday': 'lib/assets/holiday.png',
    };
    return map[slug];
  }
}