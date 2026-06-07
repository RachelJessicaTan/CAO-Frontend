import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/viewmodels/place_viewmodel.dart';
import 'package:frontend/views/widgets/bottom_nav_bar.dart';
import 'package:frontend/views/pages/profile_page.dart';
import 'package:frontend/core/api/api_client.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _openTimeController = TextEditingController();
  final _closeTimeController = TextEditingController();
  final _coverUrlController = TextEditingController();

  int _selectedCategoryIndex = -1;
  final List<int> _selectedTagIds = [];
  String? _previewUrl;

  List<CategoryModel> _categories = [];
  List<TagModel> _tags = [];
  bool _loadingMeta = true;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final catRes = await ApiClient.instance.get('/categories');
      final tagRes = await ApiClient.instance.get('/categories/tags');
      final catData = ApiClient.instance.parseResponse(catRes) as List;
      final tagData = ApiClient.instance.parseResponse(tagRes) as List;
      setState(() {
        _categories = catData.map((c) => CategoryModel.fromJson(c)).toList();
        _tags = tagData.map((t) => TagModel.fromJson(t)).toList();
        _loadingMeta = false;
      });
    } catch (_) {
      setState(() => _loadingMeta = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit(PlaceViewModel vm) async {
    if (_nameController.text.trim().isEmpty || _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and address are required')),
      );
      return;
    }

    // Ambil categoryId dari kategori yang dipilih
    final categoryIds = _selectedCategoryIndex >= 0 && _selectedCategoryIndex < _categories.length
        ? [_categories[_selectedCategoryIndex].id]
        : <int>[];

    final success = await vm.submitPlace(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      openTime: _openTimeController.text.trim().isEmpty ? null : _openTimeController.text.trim(),
      closeTime: _closeTimeController.text.trim().isEmpty ? null : _closeTimeController.text.trim(),
      coverUrl: _coverUrlController.text.trim().isEmpty ? null : _coverUrlController.text.trim(),
      categoryIds: categoryIds,
      tagIds: _selectedTagIds,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place submitted for approval! ✅')),
      );
      _nameController.clear();
      _addressController.clear();
      _descController.clear();
      _openTimeController.clear();
      _closeTimeController.clear();
      _coverUrlController.clear();
      setState(() {
        _selectedCategoryIndex = -1;
        _selectedTagIds.clear();
        _previewUrl = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Failed to submit')),
      );
    }
  }

  // Icon mapping untuk category
  IconData _categoryIcon(String slug) {
    const map = {
      'food': PhosphorIconsRegular.forkKnife,
      'hotel': PhosphorIconsRegular.bed,
      'cafe': PhosphorIconsRegular.coffee,
      'holiday': PhosphorIconsRegular.waves,
      'bar': PhosphorIconsRegular.wine,
      'nature': PhosphorIconsRegular.tree,
    };
    return map[slug] ?? PhosphorIconsRegular.mapPin;
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
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('lib/assets/cao_logo.png', height: 30),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ProfilePage())),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: AppColors.black, shape: BoxShape.circle),
                            child: const Icon(PhosphorIconsRegular.user,
                                color: AppColors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _loadingMeta
                        ? const Center(child: CircularProgressIndicator(color: AppColors.brandYellow))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4))
                                ],
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text('Add Places',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 24),

                                  // Spot Photo
                                  _label('Spot Photo'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _textField(_coverUrlController, 'Paste image URL here...'),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          final url = _coverUrlController.text
                                              .trim()
                                              .replaceAll('\n', '')
                                              .replaceAll('\r', '')
                                              .replaceAll(' ', '');
                                          setState(() => _previewUrl = url.isEmpty ? null : url);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: const BoxDecoration(
                                              color: AppColors.black, shape: BoxShape.circle),
                                          child: const Icon(PhosphorIconsRegular.magnifyingGlass,
                                              color: AppColors.brandYellow, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (_previewUrl != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        _previewUrl!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text('Invalid image URL',
                                                style: TextStyle(color: Colors.grey.shade400)),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(PhosphorIconsRegular.image,
                                                size: 32, color: Colors.grey.shade400),
                                            const SizedBox(height: 8),
                                            Text('Paste URL then tap 🔍 to preview',
                                                style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 20),

                                  _label('Spot Name *'),
                                  const SizedBox(height: 8),
                                  _textField(_nameController, 'Enter spot name'),
                                  const SizedBox(height: 20),

                                  _label('Spot Location *'),
                                  const SizedBox(height: 8),
                                  _textField(_addressController, 'Enter detail address'),
                                  const SizedBox(height: 20),

                                  _label('Description'),
                                  const SizedBox(height: 8),
                                  _textField(_descController, 'Describe this place...', maxLines: 3),
                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        _label('Open Time'),
                                        const SizedBox(height: 8),
                                        _textField(_openTimeController, '07:00'),
                                      ])),
                                      const SizedBox(width: 16),
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        _label('Close Time'),
                                        const SizedBox(height: 8),
                                        _textField(_closeTimeController, '21:00'),
                                      ])),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Category dari database
                                  _label('Category *'),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(_categories.length, (i) {
                                      final isSelected = _selectedCategoryIndex == i;
                                      return GestureDetector(
                                        onTap: () => setState(() =>
                                            _selectedCategoryIndex = isSelected ? -1 : i),
                                        child: Column(
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                color: AppColors.black,
                                                shape: BoxShape.circle,
                                                border: isSelected
                                                    ? Border.all(color: AppColors.brandYellow, width: 3)
                                                    : null,
                                              ),
                                              child: Icon(_categoryIcon(_categories[i].slug),
                                                  color: AppColors.brandYellow, size: 18),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _categories[i].name,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected ? AppColors.black : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 20),

                                  // Tags dari database
                                  _label('Suitable for'),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _tags.map((tag) {
                                      final isSelected = _selectedTagIds.contains(tag.id);
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          if (isSelected) _selectedTagIds.remove(tag.id);
                                          else _selectedTagIds.add(tag.id);
                                        }),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppColors.black : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            tag.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected ? AppColors.brandYellow : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 28),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: vm.isSubmitting ? null : () => _submit(vm),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.black,
                                        foregroundColor: AppColors.brandYellow,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)),
                                        elevation: 0,
                                      ),
                                      child: vm.isSubmitting
                                          ? const SizedBox(height: 20, width: 20,
                                              child: CircularProgressIndicator(
                                                  color: AppColors.brandYellow, strokeWidth: 2))
                                          : const Text('Send for Approval',
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const BottomNavBar(currentIndex: 2),
            ],
          ),
        );
      },
    );
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));

  Widget _textField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}