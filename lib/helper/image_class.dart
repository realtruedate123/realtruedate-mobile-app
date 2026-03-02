import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> flipImage(File file) async {
  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes);

  if (original == null) return file;

  final flipped = img.flipHorizontal(original);

  final flippedFile = await file.writeAsBytes(
    img.encodeJpg(flipped),
  );

  return flippedFile;
}