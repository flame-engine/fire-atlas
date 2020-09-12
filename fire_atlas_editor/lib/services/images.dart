import 'package:flame/position.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

Future<String> concatenateImages(
  String originalData,
  String newImageData,
  Position position,
) async {
  final original = await Flame.images.fromBase64('original', originalData);
  final newImage = await Flame.images.fromBase64('newImage', newImageData);
  Flame.images.clearCache();

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  if (position.x < 0 || position.y < 0) {
    canvas.drawImage(newImage, Offset(0, 0), Paint());
    final newX = newImage.width * position.x * -1;
    final newY = newImage.height * position.y * -1;

    canvas.drawImage(original, Offset(newX, newY), Paint());
  } else {
    canvas.drawImage(original, Offset(0, 0), Paint());

    final newX = original.width * position.x;
    final newY = original.height * position.y;

    canvas.drawImage(newImage, Offset(newX, newY), Paint());
  }

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(
    max(original.width + (newImage.width * position.x).abs().toInt(), newImage.width),
    max(original.height + (newImage.height * position.y).abs().toInt(), newImage.height),
  );

  final byteData = await finalImage.toByteData(format: ImageByteFormat.png);
  final Uint8List bytes = Uint8List.view(byteData.buffer);

  final data = "data:image/png;base64,${base64Encode(bytes)}";
  return data;
}
