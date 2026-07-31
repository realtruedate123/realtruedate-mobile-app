import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class InterestSelectionWidget extends StatefulWidget {
  final List<String> interests;
  final List<String> initialSelected;
  final ValueChanged<List<String>>? onChanged;

  const InterestSelectionWidget({
    super.key,
    required this.interests,
    this.initialSelected = const [],
    this.onChanged,
  });

  @override
  State<InterestSelectionWidget> createState() =>
      _InterestSelectionWidgetState();
}

class _InterestSelectionWidgetState extends State<InterestSelectionWidget> {
  late List<String> selectedInterests;

  @override
  void initState() {
    super.initState();
    selectedInterests = List.from(widget.initialSelected);
  }

  // 👈 ADD THIS METHOD
  @override
  void didUpdateWidget(covariant InterestSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Whenever initialSelected changes from the controller/API, update internal state
    if (oldWidget.initialSelected != widget.initialSelected) {
      setState(() {
        selectedInterests = List.from(widget.initialSelected);
      });
    }
  }

  void _toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
    if (widget.onChanged != null) {
      widget.onChanged!(selectedInterests);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFont(
          'Interest',
          font: AppFontType.inter,
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: theme.primaryColor,
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: widget.interests.map((interest) {
              final isSelected = selectedInterests.contains(interest);

              return GestureDetector(
                onTap: () => _toggleSelection(interest),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: theme.border,
                    ),
                  ),
                  child: AppTextFont(
                    interest,
                    font: AppFontType.manrope,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : theme.iconTintColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}