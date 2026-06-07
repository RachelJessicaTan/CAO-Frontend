import 'package:flutter/material.dart';
import 'package:frontend/core/services/saved_service.dart';
import 'package:frontend/models/models.dart';

class SavedViewModel extends ChangeNotifier {
  final _service = SavedService.instance;

  // Folders: map nama folder → list places
  Map<String, List<PlaceModel>> _folders = {};
  List<PlaceModel> _allSaved = [];
  bool _isLoading = false;
  String? _error;

  Map<String, List<PlaceModel>> get folders => _folders;
  List<PlaceModel> get allSaved => _allSaved;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSaved() async {
    _isLoading = true; notifyListeners();
    try {
      _allSaved = await _service.getSavedPlaces();
      // Default folder
      if (_folders.isEmpty && _allSaved.isNotEmpty) {
        _folders['My Places'] = List.from(_allSaved);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    _isLoading = false; notifyListeners();
  }

  Future<bool> isSaved(int placeId) async {
    try {
      return await _service.isSaved(placeId);
    } catch (_) { return false; }
  }

  Future<void> saveToFolder(PlaceModel place, String folderName) async {
    try {
      await _service.savePlace(place.id);
      _folders.putIfAbsent(folderName, () => []);
      if (!_folders[folderName]!.any((p) => p.id == place.id)) {
        _folders[folderName]!.add(place);
      }
      if (!_allSaved.any((p) => p.id == place.id)) {
        _allSaved.add(place);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> unsaveFromFolder(PlaceModel place, String folderName) async {
    try {
      _folders[folderName]?.removeWhere((p) => p.id == place.id);
      // Hapus dari API hanya kalau ga ada di folder lain
      final inOtherFolder = _folders.entries
          .where((e) => e.key != folderName)
          .any((e) => e.value.any((p) => p.id == place.id));
      if (!inOtherFolder) {
        await _service.unsavePlace(place.id);
        _allSaved.removeWhere((p) => p.id == place.id);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void addFolder(String name) {
    if (!_folders.containsKey(name)) {
      _folders[name] = [];
      notifyListeners();
    }
  }

  void deleteFolder(String name) {
    _folders.remove(name);
    notifyListeners();
  }

  List<String> get folderNames => _folders.keys.toList();
}