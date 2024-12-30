import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appbase/base/base_notifier.dart';
import 'package:flutter/material.dart';

class DashBoardViewModel extends BaseNotifier{

  bool searchProgress = false;
  bool hasData = false,isLoading = true;
  bool isSearching = false;

  ScrollController? scrollController;

  List<Map<String, dynamic>> filterData = [];
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> documentList = [];


  //  List<Map<String, dynamic>> documentList = [
  //   {
  //     "type": "DOC",
  //     "name": "Travel.docx",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "Document.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "dashboard.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "data.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "other.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "abc.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "xyz.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "PDF",
  //     "name": "intralogic.pdf",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "DOC",
  //     "name": "flutter.docx",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  //   {
  //     "type": "DOC",
  //     "name": "dart.docx",
  //     "uploadTime": "12/10/2024",
  //     "fileSize": "10mb"
  //   },
  // ];

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
      final dio = Dio();
      final response = await dio.get(
        'https://document-manager-sdn7.onrender.com/documents/files',
      );

      if (response.statusCode == 200) {
        final documents = response.data['data'] as List<dynamic>;
          filterData = documents.map((doc) {
            return {
              'name': doc['originalName'],
              'type': doc['filename'].endsWith('.pdf') ? 'PDF' : 'DOC',
              'uploadTime': doc['createdAt'],
              'fileSize': '${(doc['size'] / 1024).toStringAsFixed(2)} KB',
              'documentUrl': doc['document_url'],
            };
          }).toList();
        filterData = List.from(documentList);
        updateDataPresenter(filterData.isEmpty);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }

  // Future<void> fetchDocuments() async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final response = await http.get(
  //       Uri.parse("https://document-manager-sdn7.onrender.com/documents/files"),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       documentList = data.map((e) {
  //         return {
  //           "type": e["type"] ?? "Unknown",
  //           "name": e["name"] ?? "Untitled",
  //           "uploadTime": e["uploadTime"] ?? "Unknown",
  //           "fileSize": e["fileSize"] ?? "Unknown",
  //         };
  //       }).toList();
  //
  //       filterData = List.from(documentList);
  //       updateDataPresenter(false);
  //     } else {
  //       throw Exception("Failed to load documents");
  //     }
  //   } catch (e) {
  //     print("Error fetching documents: $e");
  //     documentList = [];
  //     filterData = [];
  //     updateDataPresenter(false);
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

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

  // void doSearch(String typed){
  //   final input = typed.toLowerCase().trim();
  //   filterData = documentList.where((element){
  //     final type = element["type"]!.toLowerCase();
  //     final matchesFilter = selectedFilter == "all" || type == selectedFilter;
  //     return element["name"]!.toLowerCase().contains(input) && matchesFilter;
  //   }).toList();
  //   searchProgress = filterData.length<documentList.length;
  //   sortDocuments();
  //   updateDataPresenter(false);
  // }
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