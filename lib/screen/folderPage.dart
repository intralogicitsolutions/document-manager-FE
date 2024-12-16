import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme.dart';
import 'folderDetail.dart';


class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final List<String> _folders = []; // List to store folder names

  void _showAddFolderDialog() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Folder'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter folder name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _folders.add(_controller.text); // Add folder name to list
                  });
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themer.gradient1,
        title: Text(
          'Folder',
          style: TextStyle(color: Themer.white),
        ),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Themer.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: _folders.isNotEmpty
            ? [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _showAddFolderDialog,
          ),
        ]
            : [],
      ),
      body: _folders.isEmpty
          ? Center(
        child: GestureDetector(
          onTap: _showAddFolderDialog,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 25, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                'Add Folder',
                style: TextStyle(fontSize: 22, color: Colors.grey),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.folder, color: Colors.yellow[700]), // Folder icon
            title: Text(_folders[index]),
            onTap: () {
              // Navigate to FolderDetailPage when a folder is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetailPage(
                    folderName: _folders[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
