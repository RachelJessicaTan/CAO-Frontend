import 'package:flutter/material.dart';
import 'package:frontend/core/services/place_service.dart';
import 'package:frontend/core/services/category_service.dart';
import 'package:frontend/models/models.dart';

class PlaceViewModel extends ChangeNotifier {
  final _placeService = PlaceService.instance;
  final _categoryService = CategoryService.instance;

  List<PlaceModel> _places = [];
  List<PlaceModel> _newPlaces = [];
  List<CategoryModel> _categories = [];
  List<ReviewModel> _reviews = [];
  PlaceModel? _selectedPlace;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  String? _selectedCategory;

  List<PlaceModel> get places => _places;
  List<PlaceModel> get newPlaces => _newPlaces;
  List<CategoryModel> get categories => _categories;
  List<ReviewModel> get reviews => _reviews;
  PlaceModel? get selectedPlace => _selectedPlace;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  void _setLoading(bool val) { _isLoading = val; notifyListeners(); }

  Future<void> loadCategories() async {
    try {
      _categories = await _categoryService.getCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadPlaces({String? category}) async {
    _setLoading(true);
    _error = null;
    try {
      _selectedCategory = category;
      _places = await _placeService.getPlaces(category: category);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    _setLoading(false);
  }

  Future<void> loadNewPlaces({String? search}) async {
    _setLoading(true);
    _error = null;
    try {
      _newPlaces = await _placeService.getPlaces(search: search);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    _setLoading(false);
  }

  Future<void> loadPlaceDetail(int id) async {
    _setLoading(true);
    try {
      _selectedPlace = await _placeService.getPlaceById(id);
      _reviews = await _placeService.getReviews(id);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    _setLoading(false);
  }

  Future<bool> submitPlace({
    required String name,
    required String address,
    String? description,
    String? openTime,
    String? closeTime,
    String? coverUrl,
    List<int>? categoryIds,
    List<int>? tagIds,
  }) async {
    _isSubmitting = true; notifyListeners();
    try {
      await _placeService.submitPlace(
        name: name,
        address: address,
        description: description,
        openTime: openTime,
        closeTime: closeTime,
        coverUrl: coverUrl,
        categoryIds: categoryIds,
        tagIds: tagIds,
      );
      _isSubmitting = false; notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isSubmitting = false; notifyListeners();
      return false;
    }
  }

  Future<bool> addReview(int placeId, String body, int rating) async {
    try {
      await _placeService.addReview(placeId, body, rating);
      await loadPlaceDetail(placeId);
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    loadPlaces(category: category);
  }
}