import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/agree_checkbox.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/book_info_card.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/due_date_banner.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/duration_dropdown.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/reason_text_field.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/student_info_card.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/submit_button.dart';

class RequestBorrowScreen extends ConsumerStatefulWidget {
  final BookModel book;

  const RequestBorrowScreen({super.key, required this.book});

  @override
  ConsumerState<RequestBorrowScreen> createState() =>
      _RequestBorrowScreenState();
}

class _RequestBorrowScreenState extends ConsumerState<RequestBorrowScreen> {
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
      GlassSnackBar.show(
        context,
        'Please agree to the terms before submitting.',
      );
      return;
    }

    final borrow = ref.read(borrowCartProvider.notifier);
    final days = int.parse(_selectedDuration.split(' ')[0]);

    final success = await borrow.requestBorrow(
      bookId: widget.book.id,
      reason: _reasonController.text.trim(),
      durationDays: days,
    );

    if (!mounted) return;

    if (success) {
      final cart = ref.read(borrowCartProvider);
      final index = cart.cartItems.indexWhere((b) => b.id == widget.book.id);
      if (index != -1) borrow.removeItem(index);

      GlassSnackBar.show(
        context,
        'Request submitted successfully!',
        type: GlassSnackBarType.success,
      );
      Navigator.pop(context);
    } else {
      final error = ref.read(borrowCartProvider).error;
      GlassSnackBar.show(
        context,
        error ?? 'Failed to submit',
        type: GlassSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(authProvider).student;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
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
            Divider(height: 1, color: AppColors.divider),
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
