import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// Hide Email
String maskEmail(String email) {
  if (!email.contains('@')) return email;

  final parts = email.split('@');
  final username = parts[0];
  final domain = parts[1];

  if (username.length <= 2) {
    return '${username[0]}*@$domain';
  }

  final firstChar = username[0];
  final lastChar = username[username.length - 1];
  final masked = '*' * (username.length - 2);

  return '$firstChar$masked$lastChar@$domain';
}

/// Email validation
bool? validateEmail(String? value) {
  const pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return false;//'Please enter an email address';
  } else if (!regex.hasMatch(value)) {
    return false;//'Enter a valid email address';
  } else {
    return true; // Return null if the email is valid
  }
}

/// Convert file size KB, MB & GB
String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

/// Convert strin
String shortenFileName(
    String fileName, {
      double maxWidth = 100,
      TextStyle style = const TextStyle(),
    }) {
  // if (maxWidth == null) return fileName;

  final dot = fileName.lastIndexOf('.');
  if (dot == -1) return fileName;

  final painter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  String left = fileName.substring(0, dot);
  final right = fileName.substring(dot);

  for (; left.isNotEmpty; left = left.substring(0, left.length - 1)) {
    final text = '$left…$right';
    painter.text = TextSpan(text: text, style: style);
    painter.layout(maxWidth: maxWidth);
    if (!painter.didExceedMaxLines) return text;
  }

  return '…$right';
}