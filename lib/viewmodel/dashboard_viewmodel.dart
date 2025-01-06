import 'dart:convert';
import 'dart:io';
import 'package:appbase/base/base_widget.dart';
import 'package:dio/dio.dart';
import 'package:document_manager/global/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:appbase/base/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../global/tokenStorage.dart';

class DashBoardViewModel extends BaseNotifier{

  bool searchProgress = false;
  bool hasData = false,isLoading = true;
  bool isSearching = false;

  ScrollController? scrollController;

  List<Map<String, dynamic>> filterData = [];
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> documentList = [];

  String selectedFilter = "all";
  String selectedSortOption = "Latest";

  void init(){
    scrollController = ScrollController();
    scrollController!.addListener(
          () {
        // pagination event
        if (scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
            !scrollController!.position.outOfRange) {
        }
      },
    );
    fetchDocuments();
    // filterData = List.from(documentList);
    // updateDataPresenter(filterData.isEmpty);
  }


  Future<void> fetchDocuments() async {
    try {
      String? token = await TokenStorage.getToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        'https://document-manager-sdn7.onrender.com/documents/files/${Global.userId}',
      );

      if (response.statusCode == 200) {
        final documents = response.data['data'] as List<dynamic>;
        documentList = documents.map((doc) {
          return {
            'name': doc['originalName'],
            'type': _getFileType(doc['originalName']),
            'uploadTime': doc['createdAt'],
            'fileSize': '${(doc['size'] / 1024).toStringAsFixed(2)} KB',
            'documentUrl': doc['document_url'],
            'id': doc["_id"],
            'fileName': doc["filename"],
          };
        }).toList();
        filterData = List.from(documentList);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }


  void updateDataPresenter(bool loading){
    isLoading = loading;
    hasData = filterData.isNotEmpty;
    notifyListeners();
  }

  @override
  void onDisposeValues() {
    hasData = documentList.isEmpty;
    filterData = documentList;
    searchProgress = false;

  }

  @override
  void onNavigated() {

  }

  Future<void> _uploadDocument(File file, String fileName) async {
    try {
      String? token = await TokenStorage.getToken();
      final dio = Dio();
      dio.options.headers['token'] = '$token';
      dio.options.validateStatus = (status) {
        return status != null && status >= 200 && status <= 403;
      };

      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'user_id': Global.userId,
      });

      final response = await dio.post(
        Global.BASE_URL + 'api/upload-document',
        data: formData,
      );

      print('statuscode response ==> ${response.statusCode} , msg ==> ${response.statusMessage}');
      if (response.statusCode == 200) {
        final responseData = response.data;
        final message = responseData['msg'] ?? 'Operation completed.';
        final uploadedDocs = responseData['body'] as List<dynamic>? ?? [];

        if (uploadedDocs.isNotEmpty) {
          for (var doc in uploadedDocs) {
            documentList.add({
              'name': doc['originalName'],
              'type': _getFileType(doc['originalName']),
              'uploadTime': doc['created_at'],
              'fileSize': '${(doc['size'] / 1024).toStringAsFixed(2)} KB',
              'documentUrl': doc['document_url'],
              'id': doc['_id'],
              'fileName': fileName,
              'userId': doc['user_id'],
            });
          }
          filterData = List.from(documentList);
          notifyListeners();
        }

        if (message.isNotEmpty) {
          ScaffoldMessenger.of(baseWidget.context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
      else if (response.statusCode == 403 && response.data['success'] == 0) {
        final message = response.data['msg'] ?? 'Duplicate documents detected.';
        ScaffoldMessenger.of(baseWidget.context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        ScaffoldMessenger.of(baseWidget.context).showSnackBar(
          SnackBar(content: Text('Failed to upload document.')),
        );
      }
    } catch (e) {
      print("Error uploading document: $e");
      ScaffoldMessenger.of(baseWidget.context).showSnackBar(
        SnackBar(content: Text('An error occurred while uploading the document.')),
      );
    }
  }

  String _getFileType(String fileName) {
    if (fileName.endsWith('.pdf')) return 'pdf';
    if (fileName.endsWith('.txt') || fileName.endsWith('.rtf')) return 'txt';
    if (fileName.endsWith('.docx') || fileName.endsWith('.doc')) return 'doc';
    if (fileName.endsWith('.PNG') || fileName.endsWith('.jpg')) return 'img';
    return 'other';
  }

  Future<void> addDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null) {
      for (var file in result.files) {
        final filePath = file.path;
        if (filePath != null) {
          final fileToUpload = File(filePath);
          await _uploadDocument(fileToUpload, file.name);
        }
      }
    }
  }

  Future<void> addFromGallery() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          final file = File(image.path);
          await _uploadDocument(file, image.name);
        }
      } else {
        print("No images selected.");
      }
    } catch (e) {
      print("Error selecting multiple images: $e");
    }
  }

  Future<void> addFromCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final file = File(photo.path);
      await _uploadDocument(file, photo.name);
    }
  }

  void doSearch(String searchQuery) {
    filterData = documentList.where((doc) {
      bool matchesType = selectedFilter == "all" ||
          doc['type']!.toLowerCase() == selectedFilter;
      bool matchesQuery = searchQuery.isEmpty ||
          doc['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();
  }

  void sortDocuments(){
    if(selectedSortOption == "A-Z"){
      filterData.sort((a,b)=>
          a["name"]!.toLowerCase().compareTo(b["name"]!.toLowerCase()));
    }
    else if (selectedSortOption == "Z-A") {
      filterData.sort((a, b) =>
          b["name"]!.toLowerCase().compareTo(a["name"]!.toLowerCase()));
    } else if (selectedSortOption == "Type") {
      filterData.sort((a, b) =>
          a["type"]!.toLowerCase().compareTo(b["type"]!.toLowerCase()));
    } else {
      filterData = List.from(documentList);
    }
    notifyListeners();
  }

  void toggleSearch(){
    isSearching = !isSearching;
    if (!isSearching) {
      searchController.clear();
      filterData = List.from(documentList);
    }
    notifyListeners();
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: baseWidget.context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 20.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shorting List',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text("Latest"),
              value: "Latest",
              groupValue: selectedSortOption,
              onChanged: (value) {
                selectedSortOption = value!;
                sortDocuments();
                notifyListeners();
                // setState(() {
                //   selectedSortOption = value!;
                //   _sortDocuments();
                // });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("A-Z"),
              value: "A-Z",
              groupValue: selectedSortOption,
              onChanged: (value) {
                selectedSortOption = value!;
                sortDocuments();
                notifyListeners();
                // setState(() {
                //   selectedSortOption = value!;
                //   _sortDocuments();
                // });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Z-A"),
              value: "Z-A",
              groupValue: selectedSortOption,
              onChanged: (value) {
                selectedSortOption = value!;
                sortDocuments();
                notifyListeners();
                // setState(() {
                //   selectedSortOption = value!;
                //   _sortDocuments();
                // });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Type"),
              value: "Type",
              groupValue: selectedSortOption,
              onChanged: (value) {
                selectedSortOption = value!;
                sortDocuments();
                notifyListeners();
                // setState(() {
                //   selectedSortOption = value!;
                //   _sortDocuments();
                // });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}