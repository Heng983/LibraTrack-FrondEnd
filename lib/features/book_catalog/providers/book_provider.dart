import 'package:flutter/material.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class BookProvider extends ChangeNotifier {
  List<BookModel> _books = [];
  bool _isLoading = false;
  String? _error;

  List<BookModel> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBooks({String? search, String? category}) async {
    _setLoading(true);
    _error = null;
    try {
      String url = ApiConstants.books;
      final params = <String>[];
      if (search != null && search.isNotEmpty) params.add('search=$search');
      if (category != null && category != 'All Genres') {
        params.add('category=$category');
      }
      if (params.isNotEmpty) url += '?${params.join('&')}';

      final res = await ApiService.getAuth(url);
      final dynamic booksData = res['books'];
      if (booksData is List) {
        _books = booksData
            .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _books = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching books: $e');
      _error = 'Failed to load books';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
