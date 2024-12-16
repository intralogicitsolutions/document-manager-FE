import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../component/searchbar.dart';
import '../theme/theme.dart';
import 'documentViewer.dart';

class FolderDetailPage extends StatefulWidget {
  final String? folderName;

  const FolderDetailPage({Key? key, this.folderName}) : super(key: key);

  @override
  _FolderDetailPageState createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  final List<File> _files = [];
  bool isSearching  = false;

  String searchQuery = "";

  final TextEditingController searchController = TextEditingController();

  Future<void> _addDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions:  ['pdf', 'ppt', 'doc', 'xml', 'txt', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _files.add(File(result.files.single.path!));
      });
    }
  }

  Future<void> _addFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _files.add(File(image.path));
      });
    }
  }

  Future<void> _addFromCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _files.add(File(photo.path));
      });
    }
  }

  void _openFile(File file) async {
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the file.")),
      );
    }
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'pptx':
        return Icons.slideshow;
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_fields;
      case 'xml':
        return Icons.code;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.file_copy; // Default icon for unknown file types
    }
  }

  Color _getFileIconColor(String extension) {
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'pptx':
        return Colors.blue;
      case 'docx':
        return Colors.green;
      case 'txt':
        return Colors.orange;
      case 'xml':
        return Colors.purple;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.teal;
      default:
        return Colors.grey; // Default color for unknown file types
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Themer.gradient1,
        title: isSearching  ?
        Searchbar((type) {

        }) :Text(widget.folderName??'', style: TextStyle(color: Themer.white)),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Themer.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching  ? Icons.close : Icons.search,color: Themer.white,),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                // searchController.clear();
                // _filterDocuments();
                if (!isSearching) {
                  searchQuery = "";
                  // filteredDocuments = List.from(documents); // Reset to all documents
                  // _sortDocuments();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Themer.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text('Add Document'),
                      onTap: () {
                        _addDocument();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Add from Gallery'),
                      onTap: () {
                        _addFromGallery();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Add from Camera'),
                      onTap: () {
                        _addFromCamera();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _files.isEmpty
          ? Center(
          child: Container(child: Lottie.asset('assets/animation/no_data.json', width: 150)))
          : ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          File file = _files[index];
          String fileName = file.path.split('/').last;
          String fileExtension = fileName.split('.').last.toLowerCase();

          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            elevation: 5,
            child: ListTile(
              leading: Icon(
                _getFileIcon(fileExtension),
                color: _getFileIconColor(fileExtension),
              ),
              title: Text(
                  fileName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () => _openFile(file),
            ),
          );
        },
      ),
    );
  }
}
