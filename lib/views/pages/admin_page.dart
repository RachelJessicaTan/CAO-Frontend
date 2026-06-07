import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/views/pages/load_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<PlaceModel> _pendingPlaces = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  Future<void> _loadPending() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.instance.get('/places/admin/pending', auth: true);
      final data = ApiClient.instance.parseResponse(res) as List;
      setState(() {
        _pendingPlaces = data.map((p) => PlaceModel.fromJson(p)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _approve(int placeId) async {
    try {
      await ApiClient.instance.post('/places/$placeId/approve', {}, auth: true);
      setState(() => _pendingPlaces.removeWhere((p) => p.id == placeId));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place approved!')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _reject(int placeId) async {
    try {
      await ApiClient.instance.delete('/places/$placeId', auth: true);
      setState(() => _pendingPlaces.removeWhere((p) => p.id == placeId));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place rejected.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
    }
  }

  List<PlaceModel> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _pendingPlaces;
    return _pendingPlaces
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.address.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.brandYellow,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Admin Panel',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    // Logout button
                    GestureDetector(
                      onTap: () async {
                        await context.read<AuthViewModel>().logout();
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoadPage()),
                            (r) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: AppColors.black, shape: BoxShape.circle),
                        child: const Icon(PhosphorIconsRegular.signOut,
                            color: AppColors.brandYellow, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Pending Approvals: ${_pendingPlaces.length}',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.black.withOpacity(0.6))),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search pending places...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass,
                          color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.brandYellow))
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(PhosphorIconsRegular.checkCircle,
                                size: 60, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('No pending approvals',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadPending,
                        color: AppColors.brandYellow,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => _buildCard(_filtered[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(PlaceModel place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (place.coverUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(place.coverUrl!,
                  height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                if (place.primaryCategory.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.brandYellow,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(place.primaryCategory,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),

                Text(place.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(PhosphorIconsRegular.mapPin,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(place.address,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ),
                  ],
                ),

                if (place.description != null) ...[
                  const SizedBox(height: 8),
                  Text(place.description!,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],

                if (place.openTime != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(PhosphorIconsRegular.clock,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text('${place.openTime} - ${place.closeTime}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ]),
                ],

                if (place.tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: place.tags
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(t.name,
                                  style: const TextStyle(fontSize: 11)),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showRejectDialog(place),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Reject',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approve(place.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.brandYellow,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Approve',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(PlaceModel place) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reject Place', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Reject "${place.name}"? This will permanently delete it.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _reject(place.id);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: AppColors.white),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}