import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ProfileInfoItem {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProfileInfoCard extends StatelessWidget {
  final List<ProfileInfoItem> items;

  const ProfileInfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Color(0xFFEEEEEE), indent: 70),
        itemBuilder: (_, index) => _InfoRow(item: items[index]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final ProfileInfoItem item;

  const _InfoRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Color(0xFFEEF1FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: AppColors.navy, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                item.value,
                style: TextStyle(fontSize: 16, color: AppColors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
