import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart'; // Use this to open unsupported file types

class DocumentViewer extends StatelessWidget {
  final File file;

  const DocumentViewer({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fileName = file.path.split('/').last;
    final String fileExtension = fileName.split('.').last.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: _buildDocumentView(context, fileExtension),
    );
  }

  Widget _buildDocumentView(BuildContext context, String fileExtension) {
    if (fileExtension == 'pdf') {
      return PdfView(
        controller: PdfController(document: PdfDocument.openFile(file.path)),
      );
    } else if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
      return PhotoView(
        imageProvider: FileImage(file),
      );
    } else if (fileExtension == 'txt') {
      return FutureBuilder<String>(
        future: file.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading document'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(snapshot.data ?? ''),
              ),
            );
          }
        },
      );
    } else {
      // For unsupported formats, use `open_filex` to open with an external application
      return Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await OpenFilex.open(file.path);
            if (result.type != ResultType.done) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Could not open the file.")),
              );
            }
          },
          child: Text('Open with external app'),
        ),
      );
    }
  }
}
