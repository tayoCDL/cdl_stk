import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';


class DocumentPick{
   pickDocument() async {
    String result;
    String _path = '-';
    bool _pickFileInProgress = false;
    bool _iosPublicDataUTI = true;
    bool _checkByCustomExtension = false;
    bool _checkByMimeType = false;

    final _utiController = TextEditingController(
      text: 'com.sidlatau.example.mwfbak',
    );

    final _extensionController = TextEditingController(
      text: 'mwfbak',
    );

    final _mimeTypeController = TextEditingController(
      text: 'application/pdf image/png',
    );

    try {

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList(),
        allowedMimeTypes: ["application/pdf", "image/png","image/jpeg","image/jpg"],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      // setState(() {
      //   _pickFileInProgress = false;
      // });
    }

    print('this path ${_path}');
    return _path;
    // setState(() {
    //
    // });
  }

}

