import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class AuthInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Widget icon;
  final TextInputType keyboardType;
  final String? errorText;
  final bool enabled;
  final VoidCallback? onChanged;

  const AuthInput({
    super.key,
    required this.hint,
    required this.controller,
    required this.icon,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  final FocusNode _focusNode = FocusNode();
  bool _obscure = true;
  // String? _errorText;
  bool get _hasError => widget.errorText != null;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color _iconColor() {
    final theme = AppTheme.of(Get.context!);

    if (_hasError) return theme.alert;
    if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
      return theme.iconTintHighlightColor;
    }
    return theme.iconTintColor;
  }

  Color _textColor() {
    final theme = AppTheme.of(Get.context!);
    return _hasError ? theme.alert : theme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.r),

              /// 🔥 DROP SHADOW
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword && _obscure,
              enabled: widget.enabled,
              // onChanged: (_) => widget.onChanged?.call(),
              style: TextStyle(
                fontSize: MediaQuery.textScalerOf(context).scale(16),
                color: _textColor(),
                  fontWeight: FontWeight.w300
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: theme.iconTintColor,
                  fontSize: MediaQuery.textScalerOf(context).scale(15),
                  fontWeight: FontWeight.w400
                ),
                constraints: BoxConstraints(
                  maxHeight: 58.h,
                  minHeight: 58.h
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 55.w,
                  vertical: 18.h,
                ),
                /// LEFT ICON
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _iconColor(),
                      BlendMode.srcIn,
                    ),
                    child: widget.icon,
                  ),
                ),

                /// PASSWORD EYE
                suffixIcon: widget.isPassword
                    ? Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: GestureDetector(
                                    onTap: () => setState(() => _obscure = !_obscure),
                                    child: AppIcons.getEyeOnIcon(context, size: 24)
                                  ),
                    )
                    : null,
                suffixIconConstraints: BoxConstraints(
                  minWidth: 24.w,
                  minHeight: 24.h,
                ),

                /// REMOVE ALL BORDERS
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),

                errorStyle: TextStyle(
                  fontSize: 13,
                  color: theme.alert,
                ),
              ),
            ),
          ),

          _hasError
              ? Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    AppTextFont(
                      widget.errorText ?? '',
                      font: AppFontType.lato,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: theme.alert,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              )
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}