// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

const bool supportsProfileImagePicker = true;

Future<Uint8List?> pickProfileImageBytes() async {
  final input = html.FileUploadInputElement()..accept = 'image/*';
  final completer = Completer<Uint8List?>();

  input.onChange.listen((_) {
    final file = input.files?.isNotEmpty == true ? input.files!.first : null;
    if (file == null) {
      if (!completer.isCompleted) completer.complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.onLoadEnd.listen((_) {
      final result = reader.result;
      if (result is ByteBuffer) {
        completer.complete(Uint8List.view(result));
      } else {
        completer.complete(null);
      }
    });
    reader.readAsArrayBuffer(file);
  });

  input.click();
  return completer.future;
}
