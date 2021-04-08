import 'dart:html';

void selectFile(void Function(String) callback) {
  final uploadInput = FileUploadInputElement();
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    // read file content as dataURL
    final files = uploadInput.files ?? [];
    if (files.length == 1) {
      final file = files[0];
      final reader = new FileReader();

      reader.onLoadEnd.listen((e) {
        if (reader.result != null) callback(reader.result! as String);
      });
      reader.readAsDataUrl(file);
    }
  });
}
