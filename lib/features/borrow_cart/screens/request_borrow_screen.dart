import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/agree_checkbox.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/book_info_card.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/due_date_banner.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/duration_dropdown.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/reason_text_field.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/student_info_card.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/submit_button.dart';
import 'package:provider/provider.dart';

class RequestBorrowScreen extends StatefulWidget {
  final BookModel book;

  const RequestBorrowScreen({super.key, required this.book});

  @override
  State<RequestBorrowScreen> createState() => _RequestBorrowScreenState();
}

class _RequestBorrowScreenState extends State<RequestBorrowScreen> {
  String _selectedDuration = '7 Days';
  bool _agreedToTerms = false;
  final _reasonController = TextEditingController();

  final List<String> _durations = ['7 Days', '14 Days', '21 Days', '30 Days'];

  DateTime get _dueDate {
    final days = int.parse(_selectedDuration.split(' ')[0]);
    return DateTime.now().add(Duration(days: days));
  }

  String get _dueDateFormatted {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_dueDate.month - 1]} ${_dueDate.day}, ${_dueDate.year}';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms before submitting.'),
        ),
      );
      return;
    }

    final borrow = context.read<BorrowCartProvider>();
    final days = int.parse(_selectedDuration.split(' ')[0]);

    final success = await borrow.requestBorrow(
      bookId: widget.book.id,
      reason: _reasonController.text.trim(),
      durationDays: days,
    );

    if (success) {
      // ← remove this specific book from cart
      final cart = context.read<BorrowCartProvider>();
      final index = cart.items.indexWhere((b) => b.id == widget.book.id);
      if (index != -1) cart.removeItem(index);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully!')),
      );
      Navigator.pop(context); // ← go back to cart
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(borrow.error ?? 'Failed to submit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = context.read<AuthProvider>().student;

    return Scaffold(
      backgroundColor: Color(0xFFF8F8FE),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.navy,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Request to Borrow",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StudentInfoCard(
                      name: student?.name ?? '',
                      studentId: student?.studentId ?? '',
                      email: student?.email ?? '',
                      department: student?.department,
                    ),
                    const SizedBox(height: 16),
                    BookInfoCard(book: widget.book),
                    const SizedBox(height: 20),
                    Text(
                      "Request Duration",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DurationDropdown(
                      selectedDuration: _selectedDuration,
                      durations: _durations,
                      onChanged: (val) =>
                          setState(() => _selectedDuration = val!),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Reason for Borrowing",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ReasonTextField(controller: _reasonController),
                    const SizedBox(height: 20),
                    DueDateBanner(dueDateFormatted: _dueDateFormatted),
                    const SizedBox(height: 20),
                    AgreeCheckbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val!),
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                      onSubmit: _handleSubmit,
                      onCancel: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
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
