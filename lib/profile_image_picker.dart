import 'dart:typed_data';

import 'profile_image_picker_stub.dart'
    if (dart.library.html) 'profile_image_picker_web.dart' as picker;

const bool supportsProfileImagePicker = picker.supportsProfileImagePicker;

Future<Uint8List?> pickProfileImageBytes() => picker.pickProfileImageBytes();
