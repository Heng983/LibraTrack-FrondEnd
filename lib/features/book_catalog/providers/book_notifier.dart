import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class BookState {
  final List<BookModel> books;
  final bool isLoading;
  final String? error;

  const BookState({this.books = const [], this.isLoading = false, this.error});

  BookState copyWith({
    List<BookModel>? books,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class BookNotifier extends Notifier<BookState> {
  @override
  BookState build() => const BookState(isLoading: true);

  Future<void> fetchBooks({String? search, String? category}) async {
    state = state.copyWith(isLoading: true, clearError: true);

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

      final books = booksData is List
          ? booksData
                .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : <BookModel>[];

      state = state.copyWith(books: books, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load books', isLoading: false);
    }
  }
}

final bookProvider = NotifierProvider<BookNotifier, BookState>(
  BookNotifier.new,
);
