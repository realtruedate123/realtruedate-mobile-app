import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SvgIconCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String checkedSvg;
  final String uncheckedSvg;
  final double size;
  final Color? checkedColor;
  final Color? uncheckedColor;

  const SvgIconCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.checkedSvg,
    required this.uncheckedSvg,
    this.size = 24,
    this.checkedColor,
    this.uncheckedColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent, // Hides the ripple
      highlightColor: Colors.transparent, // Hides the click highlight
      borderRadius: BorderRadius.circular(6.r),
      onTap: () => onChanged(!value),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: SvgPicture.asset(
          value ? checkedSvg : uncheckedSvg,
          key: ValueKey(value),
          width: size.w,
          height: size.h,
          colorFilter: ColorFilter.mode(
            value
                ? (checkedColor ?? Theme.of(context).primaryColor)
                : (uncheckedColor ?? Colors.grey),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
