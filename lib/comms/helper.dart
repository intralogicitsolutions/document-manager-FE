import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Helper{

  static  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 40.0, right: 20.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Option ', style: TextStyle(fontSize: 20),),
                  IconButton(
                      onPressed:() {
                        Navigator.pop(context);
                      },
                      icon:  Icon(Icons.close))
                ],
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showDeleteDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Rename'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showRenameDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                shareDocument();
              },
            ),
          ],
        );
      },
    );
  }
  static void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete?'),
          content: Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Perform the delete action here
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  static void showRenameDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Document'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                String newName = _controller.text;
                // Perform the rename action here with the new name
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  static shareDocument() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.png');
    // await tempFile.writeAsBytes(bytes);
     final XFile xFile = XFile(tempFile.path);

    // // Get the file path (this is just an example, update it to your actual file path)
    // String filePath = '/path/to/your/document.pdf';  // Replace with your document's path

    // Share the file using share_plus
    try {
      await Share.shareXFiles([xFile], text: 'Check out this document!');
    } catch (e) {
      print('Error sharing document: $e');
    }
  }
}

