import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FileSelector {
  Future<Uint8List?> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // return File(result.files.single.path!);
      return result.files.first.bytes!;
    } else {
      return null;
    }
  }
}
