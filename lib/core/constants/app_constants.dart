class AppConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // Ganti 10.0.2.2 dengan IP laptop kamu kalau test di device fisik
  // Contoh: 'http://192.168.1.x:3000/api'
}

class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';

  // Places
  static const String places = '/places';
  static String placeById(int id) => '/places/$id';
  static String placeReviews(int id) => '/places/$id/reviews';

  // Saved
  static const String saved = '/saved';
  static String savedById(int id) => '/saved/$id';

  // Categories
  static const String categories = '/categories';
}