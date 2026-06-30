import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class CartInfoBanner extends StatelessWidget {
  const CartInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF005049),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFf89F5E7),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Request status can be tracked in your history once submitted by the library staff.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
