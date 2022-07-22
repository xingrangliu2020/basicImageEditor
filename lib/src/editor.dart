import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'channel.dart';
import 'image_handler.dart';
import 'option/edit_options.dart';

/// The main class of ImageEditor plugin.
class ImageEditor {
  const ImageEditor._();

  /// The [image] is a source of image.
  ///
  /// The [imageEditorOption] option for edit image.
  ///
  /// The method will return a [Uint8List] as image result.
  ///
  /// If result is null, it means handle image error.
  static Future<Uint8List?> editImage({
    required Uint8List image,
    required ImageEditorOption imageEditorOption,
  }) async {
    Uint8List? tmp = image;
    for (final group in imageEditorOption.groupList) {
      if (group.canIgnore) {
        continue;
      }
      final handler = ImageHandler.memory(tmp);
      final editOption = ImageEditorOption();
      for (final option in group) {
        editOption.addOption(option);
      }
      editOption.outputFormat = imageEditorOption.outputFormat;
      tmp = await handler.handleAndGetUint8List(editOption);
    }
    return tmp;
  }

  /// The [file] is the source of image.
  ///
  /// The [imageEditorOption] is the option for edit image.
  ///
  /// The method will return a [Uint8List] as image result.
  ///
  /// If result is null, it means handle image error.
  static Future<Uint8List?> editFileImage({
    required File file,
    required ImageEditorOption imageEditorOption,
  }) async {
    Uint8List? tmp;
    bool isHandle = false;
    for (final group in imageEditorOption.groupList) {
      if (group.canIgnore) {
        continue;
      }
      final handler = ImageHandler.file(file);
      final editOption = ImageEditorOption();
      for (final option in group) {
        editOption.addOption(option);
      }
      editOption.outputFormat = imageEditorOption.outputFormat;
      tmp = await handler.handleAndGetUint8List(editOption);
      isHandle = true;
    }
    if (isHandle) {
      return tmp;
    } else {
      return file.readAsBytesSync();
    }
  }

  /// The [file] is the source of image.
  ///
  /// The [imageEditorOption] is the option for edit image.
  ///
  /// The method will return a [File] as image result.
  ///
  /// If result is null, it means handle image error.
  static Future<File?> editFileImageAndGetFile({
    required File file,
    required ImageEditorOption imageEditorOption,
  }) async {
    File? tmp = file;
    for (final group in imageEditorOption.groupList) {
      if (group.canIgnore) {
        continue;
      }
      final handler = ImageHandler.file(tmp);
      final editOption = ImageEditorOption();
      for (final option in group) {
        editOption.addOption(option);
      }
      editOption.outputFormat = imageEditorOption.outputFormat;
      final target = await _createTmpFilePath();
      tmp = await handler.handleAndGetFile(editOption, target);
    }
    return tmp;
  }

  /// The [image] is the source of image.
  ///
  /// The [imageEditorOption] is the option for edit image.
  ///
  /// The method will return a [File] as image result.
  ///
  /// If result is null, it means handle image error.
  static Future<File> editImageAndGetFile({
    required Uint8List image,
    required ImageEditorOption imageEditorOption,
  }) async {
    Uint8List? tmp = image;
    for (final group in imageEditorOption.groupList) {
      if (group.canIgnore) {
        continue;
      }
      final handler = ImageHandler.memory(tmp);
      final editOption = ImageEditorOption();
      for (final option in group) {
        editOption.addOption(option);
      }
      editOption.outputFormat = imageEditorOption.outputFormat;
      tmp = await handler.handleAndGetUint8List(editOption);
    }
    final file = File(await _createTmpFilePath());
    if (tmp != null) {
      await file.writeAsBytes(tmp);
    }
    return file;
  }

  /// The method will create a temp file path.
  static Future<String> _createTmpFilePath() async {
    final cacheDir = await NativeChannel.getCachePath();
    final name = DateTime.now().millisecondsSinceEpoch;
    return '${cacheDir.path}/$name';
  }
}
