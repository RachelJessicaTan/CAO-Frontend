import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/models/models.dart';

class SavedService {
  SavedService._internal();
  static final SavedService instance = SavedService._internal();

  final _client = ApiClient.instance;

  Future<List<PlaceModel>> getSavedPlaces() async {
    final res = await _client.get(ApiEndpoints.saved, auth: true);
    final data = _client.parseResponse(res) as List;
    return data.map((p) => PlaceModel.fromJson(p)).toList();
  }

  Future<bool> isSaved(int placeId) async {
    final res = await _client.get(ApiEndpoints.savedById(placeId), auth: true);
    final data = _client.parseResponse(res);
    return data['saved'] == true;
  }

  Future<void> savePlace(int placeId) async {
    await _client.post(ApiEndpoints.saved, {'placeId': placeId}, auth: true);
  }

  Future<void> unsavePlace(int placeId) async {
    await _client.delete(ApiEndpoints.savedById(placeId), auth: true);
  }
}