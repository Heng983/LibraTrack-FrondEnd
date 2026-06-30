import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/providers/book_provider.dart';
import 'package:libratrack_application/features/book_catalog/widgets/book_card.dart';
import 'package:provider/provider.dart';

class BookCatalogScreen extends StatefulWidget {
  const BookCatalogScreen({super.key});

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
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
      context.read<BookProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
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
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
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
            const Divider(color: Colors.grey),
            Expanded(
              child: bookProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : bookProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bookProvider.error ?? 'Failed to load books',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<BookProvider>().fetchBooks(),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: TextStyle(fontSize: 14),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                context.read<BookProvider>().fetchBooks(
                                  search: value,
                                  category: _selectedCategory,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'Search by title, author, or ISBN',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          context
                                              .read<BookProvider>()
                                              .fetchBooks(
                                                category: _selectedCategory,
                                              );
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
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
                                    context.read<BookProvider>().fetchBooks(
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
                                          : Color(0xFFDCE9FF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
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
                          bookProvider.books.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text(
                                      'No books found',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 0.65,
                                      ),
                                  itemCount: bookProvider.books.length,
                                  itemBuilder: (context, index) {
                                    return BookCard(
                                      book: bookProvider.books[index],
                                    );
                                  },
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
