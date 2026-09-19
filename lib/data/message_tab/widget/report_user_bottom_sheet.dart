import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class ReportUserBottomSheet extends StatefulWidget {
  final String userId;
  final Function(String selectedReason, String? customText) onReportSubmit;

  const ReportUserBottomSheet({
    super.key,
    required this.userId,
    required this.onReportSubmit,
  });

  static void show({
    required BuildContext context,
    required String userId,
    required Function(String selectedReason, String? customText) onReportSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportUserBottomSheet(
        userId: userId,
        onReportSubmit: onReportSubmit,
      ),
    );
  }

  @override
  State<ReportUserBottomSheet> createState() => _ReportUserBottomSheetState();
}

class _ReportUserBottomSheetState extends State<ReportUserBottomSheet> {
  String? _selectedReason;
  final TextEditingController _customReasonController = TextEditingController();

  // final List<String> _reportReasons = [
  //   'Harassment or bullying',
  //   'Inappropriate sexual content',
  //   'Spam',
  //   'Fake/scam profile',
  //   'Hate or abusive content',
  //   'Underage user',
  //   'Other',
  // ];

  final List<String> _reportReasons = [
    'Fake',
    'Inappropriate',
    'Harassment',
    'Spam',
    'Underage',
    'Scam',
    'Other',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedReason == null) return;

    // final customText = _selectedReason == 'Other'
    //     ? _customReasonController.text.trim()
    //     : null;

    final customText = _customReasonController.text.trim();

    // Trigger parent callback with data
    widget.onReportSubmit(_selectedReason!, customText);

    // Close bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottomsheet Indicator
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Title
              AppTextFont(
                'Report User',
                font: AppFontType.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.text,
              ),
              SizedBox(height: 6.h),

              // Subtitle
              AppTextFont(
                'Why are you reporting this user?',
                font: AppFontType.nunitoSans,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.subTitleText,
              ),
              SizedBox(height: 12.h),

              // Reason Options List
              ..._reportReasons.map((reason) {
                return RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(vertical: -4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  dense: true,
                  activeColor: theme.primaryColor,
                  title: AppTextFont(
                    reason,
                    font: AppFontType.nunitoSans,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.subTitleText,
                  ),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      // widget.controller.otherTextController.text = '';
                      _selectedReason = value;
                    });
                  },
                );
              }),

              // Custom Input Textfield for "Other"
              // if (_selectedReason == 'Other') ...[
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _customReasonController, // <--- Attach it here
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Please provide more information",
                      hintStyle: TextStyle(
                        color: theme.iconTintColor,
                        fontSize: MediaQuery.textScalerOf(context).scale(15),
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: AppFontType.lato.toString(),
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              // ],

              SizedBox(height: 20.h),

              // Submit Button
              PrimaryButton(
                  title: 'Submit Report',
                  loading: false,
                  fontWeight: FontWeight.w600,
                  cornerRadius: true,
                  onTap: _selectedReason != null ? _handleSubmit : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}