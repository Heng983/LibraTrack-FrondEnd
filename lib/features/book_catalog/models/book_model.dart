import 'package:libratrack_application/core/constants/api_constants.dart';

class BookModel {
  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.available,
    this.copiesLeft = 0,
    this.category = 'General',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.description = '',
    this.isbn = '',
    this.publisher = '',
    this.published = '',
    this.language = 'English',
  });

  final int id;
  final String title;
  final String author;
  final String cover;
  final bool available;
  final int copiesLeft;
  final String category;
  final double rating;
  final int reviewCount;
  final String description;
  final String isbn;
  final String publisher;
  final String published;
  final String language;

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      cover: ApiConstants.proxyCover(
        json['cover'] as String? ?? json['image'] as String? ?? '',
      ),
      available: json['available'] as bool? ?? false,
      copiesLeft: json['copies_left'] as int? ?? 0,
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      isbn: json['isbn'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      published: json['published'] as String? ?? '',
      language: json['language'] as String? ?? 'English',
    );
  }
}
