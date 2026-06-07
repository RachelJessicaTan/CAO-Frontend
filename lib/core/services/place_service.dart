import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/models/models.dart';

class PlaceService {
  PlaceService._internal();
  static final PlaceService instance = PlaceService._internal();

  final _client = ApiClient.instance;

  Future<List<PlaceModel>> getPlaces({String? category, String? search, int page = 1}) async {
    final query = <String, String>{'page': page.toString(), 'limit': '10'};
    if (category != null) query['category'] = category;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final res = await _client.get(ApiEndpoints.places, query: query);
    final data = _client.parseResponse(res) as List;
    return data.map((p) => PlaceModel.fromJson(p)).toList();
  }

  Future<PlaceModel> getPlaceById(int id) async {
    final res = await _client.get(ApiEndpoints.placeById(id));
    return PlaceModel.fromJson(_client.parseResponse(res));
  }

  Future<List<ReviewModel>> getReviews(int placeId) async {
    final res = await _client.get(ApiEndpoints.placeReviews(placeId));
    final data = _client.parseResponse(res) as List;
    return data.map((r) => ReviewModel.fromJson(r)).toList();
  }

  Future<void> addReview(int placeId, String body, int rating) async {
    await _client.post(ApiEndpoints.placeReviews(placeId),
        {'body': body, 'rating': rating}, auth: true);
  }

  Future<void> submitPlace({
    required String name,
    required String address,
    String? description,
    String? openTime,
    String? closeTime,
    String? coverUrl,
    List<int>? categoryIds,
    List<int>? tagIds,
  }) async {
    await _client.post(ApiEndpoints.places, {
      'name': name,
      'address': address,
      if (description != null) 'description': description,
      if (openTime != null) 'openTime': openTime,
      if (closeTime != null) 'closeTime': closeTime,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (categoryIds != null) 'categoryIds': categoryIds,
      if (tagIds != null) 'tagIds': tagIds,
    }, auth: true);
  }
}