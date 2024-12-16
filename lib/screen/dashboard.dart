import 'package:document_manager/comms/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../comms/navBar.dart';
import '../comms/navModel.dart';
import '../component/drawer.dart';
import '../theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];
  List<Map<String, String>> filteredDocuments = [];
  String selectedFilter = "all";
  String selectedSortOption = "Last Added";

  bool _isFabClicked = false;

  final List<Map<String, String>> documents = [
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

  bool isSearching = false;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDocuments = List.from(documents);
  }

  void _filterDocuments(String query) {
    setState(() {
      searchQuery = query;
      filteredDocuments = documents.where((document) {
        final name = document["name"]!.toLowerCase();
        final type = document["type"]!.toLowerCase();
        final matchesQuery = name.contains(query.toLowerCase());
        final matchesFilter = selectedFilter == "all" || type == selectedFilter;

        return matchesQuery && matchesFilter;
      }).toList();

      _sortDocuments(); // Apply the selected sort after filtering
    });
  }

  void _sortDocuments() {
    setState(() {
      if (selectedSortOption == "A-Z") {
        filteredDocuments.sort((a, b) =>
            a["name"]!.toLowerCase().compareTo(b["name"]!.toLowerCase()));
      } else if (selectedSortOption == "Z-A") {
        filteredDocuments.sort((a, b) =>
            b["name"]!.toLowerCase().compareTo(a["name"]!.toLowerCase()));
      } else if (selectedSortOption == "Type") {
        filteredDocuments.sort((a, b) =>
            a["type"]!.toLowerCase().compareTo(b["type"]!.toLowerCase()));
      } else {
        // Default is "Last Added" (original order)
        filteredDocuments = List.from(documents);
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
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
              title: const Text("Last Added"),
              value: "Last Added",
              groupValue: selectedSortOption,
              onChanged: (value) {
                setState(() {
                  selectedSortOption = value!;
                  _sortDocuments();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("A-Z"),
              value: "A-Z",
              groupValue: selectedSortOption,
              onChanged: (value) {
                setState(() {
                  selectedSortOption = value!;
                  _sortDocuments();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Z-A"),
              value: "Z-A",
              groupValue: selectedSortOption,
              onChanged: (value) {
                setState(() {
                  selectedSortOption = value!;
                  _sortDocuments();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Type"),
              value: "Type",
              groupValue: selectedSortOption,
              onChanged: (value) {
                setState(() {
                  selectedSortOption = value!;
                  _sortDocuments();
                });
                Navigator.pop(context);
              },
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Themer.gradient1,
        title: isSearching
            ? TextField(
                style: const TextStyle(color: Themer.white),
                controller: searchController,
                // autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search documents...",
                  hintStyle: TextStyle(color: Themer.white),
                  border: InputBorder.none,
                ),
                onChanged: (value) => _filterDocuments(value),
              )
            : const Text(
                "All Documents",
                style: TextStyle(color: Themer.white),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Themer.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                // searchController.clear();
                // _filterDocuments();
                if (!isSearching) {
                  searchQuery = "";
                  filteredDocuments =
                      List.from(documents); // Reset to all documents
                  _sortDocuments();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showSortOptions,
            color: Themer.white,
          ),
        ],
      ),
      drawer: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CustomDrawer.show(context)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color(0xFFF67DBC), // Pinkish color
                  // Color(0xFFFFC2A2), // Light orange color
                  Themer.gradient1.withOpacity(0.5),
                  Themer.gradient2.withOpacity(0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filter Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["all", "pdf", "doc", "img", "ppt", "txt"]
                        .map((filter) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(
                                  filter.toUpperCase(),
                                  style: TextStyle(
                                    color: selectedFilter == filter
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: selectedFilter == filter,
                                selectedColor: Themer.gradient1,
                                checkmarkColor: Themer.white,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedFilter =
                                        isSelected ? filter : "all";
                                    _filterDocuments(searchQuery);
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      var document = filteredDocuments[index];
                      if (selectedFilter != "all" &&
                          document["type"]!.toLowerCase() != selectedFilter) {
                        return Container(); // Skip non-matching items
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4.0, right: 10, left: 10),
                        child: Slidable(
                          endActionPane:
                              ActionPane(motion: BehindMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                Helper.showDeleteDialog(context);
                              },
                              backgroundColor: Colors.red.shade300,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              //label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Helper.showRenameDialog(context);
                              },
                              backgroundColor: Themer.gradient1,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              //label: 'Rename',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Helper.shareDocument();
                              },
                              backgroundColor: Colors.green.shade400,
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              //label: 'Share',
                            ),
                          ]),
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                document["type"] == "PDF"
                                    ? Icons.picture_as_pdf
                                    : Icons.insert_drive_file,
                                color: document["type"] == "PDF"
                                    ? Colors.red
                                    : Colors.blue,
                                size: 40,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document["name"]!),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${document["uploadTime"]}",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "${document["fileSize"]}",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.more_vert),
                              onTap: () {
                                Helper.showBottomSheet(context);
                                // Handle document selection
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
