import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/book_catalog/providers/book_notifier.dart';
import 'package:libratrack_application/features/book_catalog/widgets/book_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookCatalogScreen extends ConsumerStatefulWidget {
  const BookCatalogScreen({super.key});

  @override
  ConsumerState<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends ConsumerState<BookCatalogScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _selectedCategory = 'All Genres';

  final List<String> _categories = [
    'All Genres',
    'Fiction',
    'Technology',
    'Science',
    'History',
    'Novel',
  ];

  // Placeholder books rendered under the skeleton shimmer while loading.
  static final List<BookModel> _skeletonBooks = List.filled(
    6,
    const BookModel(
      id: 0,
      title: 'Book title placeholder',
      author: 'Author name',
      cover: '',
      available: true,
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookProvider.notifier).fetchBooks();
      if (ref.read(authProvider).student == null) {
        ref.read(authProvider.notifier).loadCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(bookProvider);
    final profileImage = ref.watch(
      authProvider.select((auth) => auth.student?.profileImage),
    );
    final profileImageUrl = profileImage != null
        ? '${ApiConstants.baseUrl.replaceAll('/api', '')}$profileImage'
        : null;
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person_rounded,
                                color: AppColors.onPrimary,
                                size: 26,
                              ),
                            )
                          : Icon(
                              Icons.person_rounded,
                              color: AppColors.onPrimary,
                              size: 26,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'LibraTrack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _searchFocusNode.requestFocus(),
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.navy,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.divider),
            Expanded(
              child: bookState.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bookState.error ?? 'Failed to load books',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(bookProvider.notifier).fetchBooks(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: TextStyle(fontSize: 14),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                ref
                                    .read(bookProvider.notifier)
                                    .fetchBooks(
                                      search: value,
                                      category: _selectedCategory,
                                    );
                              },
                              decoration: InputDecoration(
                                hintText: 'Search by title, author, or ISBN',
                                hintStyle: TextStyle(
                                  color: AppColors.hintGray,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: AppColors.textMuted,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          ref
                                              .read(bookProvider.notifier)
                                              .fetchBooks(
                                                category: _selectedCategory,
                                              );
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Browse Categories',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 36,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected = _selectedCategory == cat;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedCategory = cat);
                                    ref
                                        .read(bookProvider.notifier)
                                        .fetchBooks(
                                          category: cat,
                                          search: _searchController.text,
                                        );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.navy
                                          : AppColors.navy.withValues(
                                              alpha: 0.12,
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.onPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recently Added',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navy,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          !bookState.isLoading && bookState.books.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text(
                                      'No books found',
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              : Skeletonizer(
                                  enabled: bookState.isLoading,
                                  effect: ShimmerEffect(
                                    baseColor: AppColors.fieldBg,
                                    highlightColor: AppColors.borderColor,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 0.65,
                                        ),
                                    itemCount: bookState.isLoading
                                        ? _skeletonBooks.length
                                        : bookState.books.length,
                                    itemBuilder: (context, index) {
                                      return BookCard(
                                        book: bookState.isLoading
                                            ? _skeletonBooks[index]
                                            : bookState.books[index],
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
