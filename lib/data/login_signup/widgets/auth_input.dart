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
    // print('call textColor');
    final theme = AppTheme.of(Get.context!);
    return _hasError ? theme.alert : theme.primaryColor;
  }

 /* Color _iconColor() {
    if (_errorText != null) return AppTheme.of(Get.context!).alert;
    if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
      return AppTheme.of(Get.context!).iconTintHighlightColor; // primary
    }
    return AppTheme.of(Get.context!).iconTintColor;
  }

  Color _textColor() {
    if (_errorText != null) return AppTheme.of(Get.context!).alert;
    return AppTheme.of(Get.context!).primaryColor;
  }*/

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
              // validator: (v) {
              //   final res = widget.validator?.call(v);
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     if (_errorText != res) {
              //       setState(() => _errorText = res);
              //     }
              //   });
              //   return res;
              // },
              decoration: InputDecoration(
                // errorText: widget.errorText,
                // isDense: true,
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
                /// FLOATING LABEL
                // labelText: widget.hint,
                // floatingLabelBehavior: FloatingLabelBehavior.auto,
                // labelStyle: TextStyle(
                //   color: theme.iconTintColor,
                //   fontSize: MediaQuery.textScalerOf(context).scale(15),
                //   fontWeight: FontWeight.w400,
                // ),
                // floatingLabelStyle: TextStyle(
                //   color: _errorText != null
                //       ? theme.alert
                //       : theme.primaryColor,
                //   fontSize: MediaQuery.textScalerOf(context).scale(12),
                //   fontWeight: FontWeight.w400,
                // ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 55.w,
                  vertical: 18.h,
                ),
                // contentPadding: EdgeInsets.fromLTRB(55.w, 18.h, 55.w, 14.h),

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
                                    // Icon(
                                    //   _obscure
                                    //       ? Icons.visibility_outlined
                                    //       : Icons.visibility_off_outlined,
                                    //   color: AppTheme.of(Get.context!).iconTintColor,
                                    // ),
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

/*class AuthInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final Widget? prefixIcon;
  final TextInputType keyboardType;

  const AuthInput({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
    this.obscure = false,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF1C2A44),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFFB0B7C3),
            fontSize: 16.sp,
          ),
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
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
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 13.sp,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
*/
