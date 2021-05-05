import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FileSelector {
  Future<FileModel?> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // return File(result.files.single.path!);
      var file = result.files.first;
      return FileModel(file.bytes!, file.name ?? 'my_file');
    } else {
      return null;
    }
  }
}

class FileModel {
  final Uint8List byteData;
  final String title;

  FileModel(this.byteData, this.title);
}
