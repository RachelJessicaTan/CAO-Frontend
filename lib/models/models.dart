// ─── User Model ───────────────────────────────────────────────
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  UserModel({required this.id, required this.name, required this.email, required this.role, this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'] ?? 'user',
    avatarUrl: json['avatarUrl'],
  );
}

// ─── Category Model ───────────────────────────────────────────
class CategoryModel {
  final int id;
  final String name;
  final String slug;

  CategoryModel({required this.id, required this.name, required this.slug});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    name: json['name'],
    slug: json['slug'],
  );
}

// ─── Tag Model ────────────────────────────────────────────────
class TagModel {
  final int id;
  final String name;
  final String slug;

  TagModel({required this.id, required this.name, required this.slug});

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    id: json['id'],
    name: json['name'],
    slug: json['slug'],
  );
}

// ─── Review Model ─────────────────────────────────────────────
class ReviewModel {
  final int id;
  final String body;
  final int rating;
  final String? userName;
  final DateTime createdAt;

  ReviewModel({required this.id, required this.body, required this.rating, this.userName, required this.createdAt});

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'],
    body: json['body'],
    rating: 0,
    userName: json['userName'],
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

// ─── Place Model ──────────────────────────────────────────────
class PlaceModel {
  final int id;
  final String name;
  final String address;
  final String? description;
  final String? coverUrl;
  final String? openTime;
  final String? closeTime;
  final double avgRating;
  final int totalReviews;
  final String? mapsUrl;
  final List<CategoryModel> categories;
  final List<TagModel> tags;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    this.coverUrl,
    this.openTime,
    this.closeTime,
    required this.avgRating,
    required this.totalReviews,
    this.mapsUrl,
    required this.categories,
    required this.tags,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    description: json['description'],
    coverUrl: json['coverUrl'],
    openTime: json['openTime'],
    closeTime: json['closeTime'],
    avgRating: double.tryParse(json['avgRating'].toString()) ?? 0.0,
    totalReviews: json['totalReviews'] ?? 0,
    mapsUrl: json['mapsUrl'],
    categories: (json['categories'] as List? ?? [])
        .map((c) => CategoryModel.fromJson(c['category'] ?? c))
        .toList(),
    tags: (json['tags'] as List? ?? [])
        .map((t) => TagModel.fromJson(t['tag'] ?? t))
        .toList(),
  );

  // Untuk category pertama (display di card)
  String get primaryCategory => categories.isNotEmpty ? categories.first.name : '';
}

// ─── Saved Folder Model ───────────────────────────────────────
class SavedFolderModel {
  final String name;
  List<PlaceModel> places;

  SavedFolderModel({required this.name, required this.places});
}