import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/viewmodels/place_viewmodel.dart';
import 'package:frontend/viewmodels/saved_viewmodel.dart';

class PlaceDetailPage extends StatefulWidget {
  final PlaceModel place;

  const PlaceDetailPage({super.key, required this.place});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  bool _isSaved = false;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceViewModel>().loadPlaceDetail(widget.place.id);
      _checkSaved();
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _checkSaved() async {
    final saved = await context.read<SavedViewModel>().isSaved(widget.place.id);
    if (mounted) setState(() => _isSaved = saved);
  }

  void _showSaveFolderDialog() {
    final savedVm = context.read<SavedViewModel>();
    final folderNames = savedVm.folderNames;
    final newFolderController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Save to folder',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (folderNames.isEmpty)
                Text('No folders yet. Create one below.',
                    style: TextStyle(color: Colors.grey.shade500))
              else
                ...folderNames.map((name) => ListTile(
                      title: Text(name),
                      leading: const Icon(PhosphorIconsRegular.folder),
                      onTap: () {
                        savedVm.saveToFolder(widget.place, name);
                        setState(() => _isSaved = true);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Saved to "$name"')));
                      },
                    )),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newFolderController,
                      decoration: const InputDecoration(
                          hintText: 'New folder name',
                          border: InputBorder.none),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final name = newFolderController.text.trim();
                      if (name.isEmpty) return;
                      savedVm.addFolder(name);
                      savedVm.saveToFolder(widget.place, name);
                      setState(() => _isSaved = true);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved to "$name"')));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.brandYellow),
                    child: const Text('Create & Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(PlaceViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Write a Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Share your experience...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_reviewController.text.trim().isEmpty) return;
                  final success = await vm.addReview(
                      widget.place.id, _reviewController.text.trim(), 5);
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (success) {
                    _reviewController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review submitted!')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.brandYellow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Submit Review',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceViewModel>(
      builder: (context, vm, _) {
        final place = vm.selectedPlace ?? widget.place;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.white.withOpacity(0.9),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.85),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back,
                            size: 22, color: AppColors.black),
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: place.coverUrl != null
                      ? Image.network(place.coverUrl!,
                          width: double.infinity, fit: BoxFit.cover)
                      : Container(color: Colors.grey.shade200),
                ),
              ),
            ],
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.name,
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(place.address,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showSaveFolderDialog,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isSaved
                                ? AppColors.brandYellow
                                : AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isSaved
                                ? PhosphorIconsFill.bookmarkSimple
                                : PhosphorIconsRegular.bookmarkSimple,
                            color: _isSaved ? AppColors.black : AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category badge
                  if (place.primaryCategory.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(place.primaryCategory,
                          style: const TextStyle(
                              color: AppColors.brandYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Suitable for (tags)
                  if (place.tags.isNotEmpty) ...[
                    const Text('SUITABLE FOR',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: place.tags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.brandYellow, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(tag.name,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  // Open hours
                  if (place.openTime != null) ...[
                    Row(children: [
                      Icon(PhosphorIconsRegular.clock,
                          size: 18, color: Colors.grey.shade500),
                      const SizedBox(width: 10),
                      const Text('Open',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('${place.openTime} - ${place.closeTime ?? '?'}',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600)),
                    ]),
                    const SizedBox(height: 12),
                  ],

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(PhosphorIconsRegular.mapPin,
                          size: 18, color: Colors.grey.shade500),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(place.address,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reviews header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reviews (${vm.reviews.length})',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => _showReviewDialog(vm),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text('+ Review',
                              style: TextStyle(
                                  color: AppColors.brandYellow,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (vm.isLoading)
                    const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.brandYellow))
                  else if (vm.reviews.isEmpty)
                    Text('No reviews yet. Be the first!',
                        style: TextStyle(color: Colors.grey.shade400))
                  else
                    ...vm.reviews.map((review) => _buildReview(review)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReview(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.reviewBg,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review.userName ?? 'User',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(review.body,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4)),
        ],
      ),
    );
  }
}