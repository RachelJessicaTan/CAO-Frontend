import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/models/models.dart';

class CategoryService {
  CategoryService._internal();
  static final CategoryService instance = CategoryService._internal();

  final _client = ApiClient.instance;

  Future<List<CategoryModel>> getCategories() async {
    final res = await _client.get(ApiEndpoints.categories);
    final data = _client.parseResponse(res) as List;
    return data.map((c) => CategoryModel.fromJson(c)).toList();
  }
}