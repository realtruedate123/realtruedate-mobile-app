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

Future<File> ProcessCapturedImage({
  required File file,
  required bool isFrontCamera,
}) async {
  final bytes = await file.readAsBytes();

  final decoded = img.decodeImage(bytes);
  if (decoded == null) return file;

  // Fix EXIF orientation
  img.Image processed = img.bakeOrientation(decoded);

  // Remove mirror effect for front camera
  if (isFrontCamera) {
    processed = img.flipHorizontal(processed);
  }

  final newFile = File(file.path);
  await newFile.writeAsBytes(
    img.encodeJpg(processed, quality: 95),
  );

  return newFile;
}