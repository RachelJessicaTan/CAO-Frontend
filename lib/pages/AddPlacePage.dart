import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/HomePage.dart'; 
import 'package:frontend/pages/NotificationPage.dart'; 
import 'package:frontend/pages/SearchPage.dart';
import 'package:frontend/pages/SavedPlacesPage.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  int _selectedCategoryIndex = -1;
  String? _selectedSuitableFor;
  final int _currentNavIndex = 2;

  final List<Map<String, dynamic>> categories = [
    {'icon': PhosphorIconsRegular.forkKnife, 'label': 'Food'},
    {'icon': PhosphorIconsRegular.bed, 'label': 'Hotel'},
    {'icon': PhosphorIconsRegular.coffee, 'label': 'Cafe'},
    {'icon': PhosphorIconsRegular.waves, 'label': 'Holiday'},
    {'icon': PhosphorIconsRegular.wine, 'label': 'Bar'},
    {'icon': PhosphorIconsRegular.tree, 'label': 'Nature'},
  ];

  final List<String> suitableForOptions = [
    'Solo', 'Couple', 'Family', 'Friends', 'Business', 'Pet Friendly',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _reviewController.dispose();
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
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 16),
                child: Row(
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text('Add Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Spot Shots *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text('Add more', style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                          child: Icon(PhosphorIconsRegular.plus, color: Colors.grey.shade400, size: 28),
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Spot Name *'),
                        const SizedBox(height: 8),
                        _buildTextField(_nameController, 'Enter spot name'),
                        const SizedBox(height: 20),
                        _buildLabel('Spot Location *'),
                        const SizedBox(height: 8),
                        _buildTextField(_locationController, 'Enter detail address'),
                        const SizedBox(height: 20),
                        _buildLabel('Category *'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(categories.length, (index) {
                            final bool isSelected = _selectedCategoryIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategoryIndex = isSelected ? -1 : index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                  border: isSelected ? Border.all(color: brandYellow, width: 3) : null,
                                ),
                                child: Icon(categories[index]['icon'] as IconData, color: brandYellow, size: 20),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Suitable for *'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSuitableFor,
                              isExpanded: true,
                              hint: Text('Choose tags', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                              icon: Icon(PhosphorIconsRegular.caretDown, color: Colors.grey.shade400, size: 18),
                              items: suitableForOptions.map((option) {
                                return DropdownMenuItem(value: option, child: Text(option, style: const TextStyle(fontSize: 14)));
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedSuitableFor = val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Your Review *'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                          child: TextField(
                            controller: _reviewController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Initiate review',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: brandYellow,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Send for Approval',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                            ),
                          ),
                        ),
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

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (icon == PhosphorIconsRegular.plus) return;

        if (icon == PhosphorIconsRegular.house) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.magnifyingGlass) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SearchPage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.bell) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NotificationPage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.bookmarkSimple) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SavedPlacesPage()), (route) => false);
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