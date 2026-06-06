import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlaceDetailPage extends StatefulWidget {
  final Map<String, String> spot;

  const PlaceDetailPage({super.key, required this.spot});
  
  @override
  State<StatefulWidget> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Posting Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.spot['title']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black,
                      child: Icon(PhosphorIconsRegular.user, color: Colors.white, size: 14),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Rachelle',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Leave a review for this place:', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                TextField(
                  minLines: 4,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Share your experience!',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Review has been posted', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.black.withOpacity(0.9),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Post', style: TextStyle(color: Color(0xFFFCDD3F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

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
                  widget.spot['img']!,
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
                            widget.spot['title']!,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.spot['loc']!,
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
                        widget.spot['loc']!,
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

                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showReviewDialog, 
                  label: const Text('Leave a review!', style: TextStyle(color: brandYellow, fontWeight: FontWeight.w600)),
                  icon: Icon(Icons.reviews, color: brandYellow, size: 20),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.all(20),
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  )
                )
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