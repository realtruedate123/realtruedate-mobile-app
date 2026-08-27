import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String featureText;
  final bool isSelected;
  final bool isActivated;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.featureText,
    required this.isSelected,
    required this.isActivated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    print('isSelected $isSelected');

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextFont(
                        title,
                        font: AppFontType.inter,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      SizedBox(height: 8.0),
                      AppTextFont(
                        price,
                        font: AppFontType.inter,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5C5B9B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          AppTextFont(
                            featureText,
                            font: AppFontType.inter,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: theme.subTitleText,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF5C5B9B)
                        : const Color(0xFFEBEDF2),
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check,
                    size: 18.0,
                    color: Colors.white,
                  )
                      : null,
                ),
              ],
            ),
          ),

          // Activated badge - top right
          if (isActivated)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Activated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}