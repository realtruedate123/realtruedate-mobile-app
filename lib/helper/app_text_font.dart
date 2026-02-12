import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFontType {
  inter,
  lato,
  manrope,
  poppins,
  urbanist,
}

class AppTextFont extends StatelessWidget {
  final String text;
  final AppFontType font;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? lineHeight;

  const AppTextFont(
      this.text, {
        super.key,
        this.font = AppFontType.inter,
        this.fontSize = 16,
        this.fontWeight = FontWeight.w500,
        this.color = Colors.black,
        this.textAlign,
        this.maxLines = 1,
        this.overflow,
        this.lineHeight,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: AppFonts.get(
        context: context,
        font: font,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: lineHeight
      ),
    );
  }
}

class AppFonts {
  static TextStyle get({
    required BuildContext context,
    required AppFontType font,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    Color color = Colors.black,
    double? height,
    double? letterSpacing,
  }) {
    final scaledSize =
    MediaQuery.textScalerOf(context).scale(fontSize);

    switch (font) {
      case AppFontType.inter:
        return GoogleFonts.inter(
          fontSize: scaledSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );

      case AppFontType.lato:
        return GoogleFonts.lato(
          fontSize: scaledSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );

      case AppFontType.manrope:
        return GoogleFonts.manrope(
          fontSize: scaledSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );

      case AppFontType.poppins:
        return GoogleFonts.poppins(
          fontSize: scaledSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );

      case AppFontType.urbanist:
        return GoogleFonts.urbanist(
          fontSize: scaledSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
    }
  }
}