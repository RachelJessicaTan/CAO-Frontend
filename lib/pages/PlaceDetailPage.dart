import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlaceDetailPage extends StatelessWidget {
  final Map<String, String> spot;

  const PlaceDetailPage({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // SliverAppBar membuat Header & Gambar bisa nge-blend dan fixed saat di-scroll
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true, // KUNCI: Header tetap menempel di atas walau di-scroll
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0.9), // Warna header saat di-scroll ke bawah
              scrolledUnderElevation: 2,
              
              // Kustomisasi tombol Back asli agar tidak ikut tergulung kaku
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: innerBoxIsScrolled 
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                            : [],
                      ),
                      child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
                    ),
                  ),
                ),
              ),
              
              // Area Gambar Hero yang akan menyusut halus saat di-scroll
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  spot['img']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        
        // Konten Detail di bawah gambar
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
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
                          Text(
                            spot['title']!,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            spot['loc']!,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(PhosphorIconsRegular.bookmarkSimple, color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Suitable for
                const Text(
                  'SUITABLE FOR',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Date Night', 'Hang Out', 'Studying', 'Solo Time'].map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: brandYellow, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                const Divider(color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(PhosphorIconsRegular.clock, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 10),
                    const Text('Open', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text('07.00 - 21.00', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(PhosphorIconsRegular.mapPin, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        spot['loc']!,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Top Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildReview('ws_alfonso', 'Nice place for chilling. Have good taste on Asian food. I like the way they serve the Cheese Parmigiana.'),
                _buildReview('oliver', 'Best service!'),
                _buildReview('gianazM', 'Cozy VIP room for meetings or family dinner.'),
                _buildReview('croycloy', 'Amazing ambience and great food selection.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReview(String username, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(review, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
        ],
      ),
    );
  }
}