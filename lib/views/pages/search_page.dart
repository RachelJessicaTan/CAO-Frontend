import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/viewmodels/place_viewmodel.dart';
import 'package:frontend/views/widgets/bottom_nav_bar.dart';
import 'package:frontend/views/widgets/place_card.dart';
import 'package:frontend/views/pages/place_detail_page.dart';
import 'package:frontend/views/pages/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceViewModel>().loadNewPlaces();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 20),
                    child: Column(
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
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search places by name...',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                              prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass, color: Colors.grey.shade400, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            onChanged: (val) => vm.loadNewPlaces(search: val.trim()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: vm.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.brandYellow))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(32, 8, 32, 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _searchController.text.isEmpty ? 'New Places' : 'Results',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                if (vm.newPlaces.isEmpty)
                                  Center(child: Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Text('No places found', style: TextStyle(color: Colors.grey.shade400)),
                                  ))
                                else
                                  ...vm.newPlaces.map((place) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: PlaceCard(
                                      place: place,
                                      onTap: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place))),
                                    ),
                                  )),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
              const BottomNavBar(currentIndex: 1),
            ],
          ),
        );
      },
    );
  }
}