import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flame/position.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

Future<String> concatenateImages(
  String originalData,
  String newImageData,
  Position placement,
  Selection selection,
) async {
  final original = await Flame.images.fromBase64('original', originalData);
  final newImage = await Flame.images.fromBase64('newImage', newImageData);
  Flame.images.clearCache();

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint();

  if (placement != null) {
    if (placement.x < 0 || placement.y < 0) {
      canvas.drawImage(newImage, Offset(0, 0), paint);
      final newX = newImage.width * placement.x * -1;
      final newY = newImage.height * placement.y * -1;

      canvas.drawImage(original, Offset(newX, newY), paint);
    } else {
      canvas.drawImage(original, Offset(0, 0), paint);

      final newX = original.width * placement.x;
      final newY = original.height * placement.y;

      canvas.drawImage(newImage, Offset(newX, newY), paint);
    }
  } else if (selection != null) {
    canvas.drawImageRect(
      newImage,
      Rect.fromLTWH(
        0,
        0,
        newImage.width.toDouble(),
        newImage.height.toDouble(),
      ),
      Rect.fromLTWH(
        selection.x.toDouble(),
        selection.y.toDouble(),
        selection.w.toDouble(),
        selection.h.toDouble(),
      ),
      paint,
    );
  }

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(
    max(original.width + (newImage.width * placement.x).abs().toInt(),
        newImage.width),
    max(original.height + (newImage.height * placement.y).abs().toInt(),
        newImage.height),
  );

  final byteData = await finalImage.toByteData(format: ImageByteFormat.png);
  final Uint8List bytes = Uint8List.view(byteData.buffer);

  final data = "data:image/png;base64,${base64Encode(bytes)}";
  return data;
}
