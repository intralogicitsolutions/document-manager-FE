import 'package:appbase/base/base_notifier.dart';
import 'package:flutter/material.dart';

class DashBoardViewModel extends BaseNotifier{

  bool searchProgress = false;
  bool hasData = false,isLoading = true;
  bool isSearching = false;

  List<Map<String, String>> filterData = [];
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> documentList = [
    {
      "type": "DOC",
      "name": "Travel.docx",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "Document.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "dashboard.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "data.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "other.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "abc.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "xyz.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "PDF",
      "name": "intralogic.pdf",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "DOC",
      "name": "flutter.docx",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
    {
      "type": "DOC",
      "name": "dart.docx",
      "uploadTime": "12/10/2024",
      "fileSize": "10mb"
    },
  ];

  String selectedFilter = "all";
  String selectedSortOption = "Last Added";

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

  void doSearch(String typed){
    final input = typed.toLowerCase().trim();
    filterData = documentList.where((element){
      return element["name"]!.toLowerCase().contains(input);
    }).toList();
    searchProgress = filterData.length<documentList.length;
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


}