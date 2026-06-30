import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/providers/borrow_request_provider.dart';
import 'package:libratrack_application/features/admin/widgets/request_card.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BorrowRequestProvider>().loadRequests(status: 'pending');
    });
  }

  Future<void> _approve(int id) async {
    final ok = await context.read<BorrowRequestProvider>().approve(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Request approved!' : 'Failed to approve'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _reject(int id) async {
    final ok = await context.read<BorrowRequestProvider>().reject(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Request rejected.' : 'Failed to reject'),
        backgroundColor: ok ? Colors.red : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.bgcolor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF1A1A2E),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'LibraTrack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.search_rounded, color: AppColors.navy, size: 26),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: Consumer<BorrowRequestProvider>(
                builder: (context, provider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Borrow Requests',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage incoming loan requests from students and faculty.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              _TabButton(
                                label: 'Pending (${provider.requests.length})',
                                selected: _selectedTab == 0,
                                onTap: () {
                                  setState(() => _selectedTab = 0);
                                  provider.loadRequests(status: 'pending');
                                },
                              ),
                              _TabButton(
                                label: 'All Records',
                                selected: _selectedTab == 1,
                                onTap: () {
                                  setState(() => _selectedTab = 1);
                                  provider.loadRequests();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (provider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (provider.error != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Text(provider.error!),
                            ),
                          )
                        else if (provider.requests.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 56,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No pending requests',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.requests.length,
                            itemBuilder: (_, index) {
                              final req = provider.requests[index];
                              return RequestCard(
                                requestModel: req,
                                onApprove: () => _approve(req.id),
                                onReject: () => _reject(req.id),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? const Color(0xFF1A1A2E) : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
