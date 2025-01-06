import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:appbase/base/base_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:document_manager/screen/homePageSlide.dart';
import 'package:document_manager/screen/notificationPage.dart';
import 'package:document_manager/screen/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../comms/helper.dart';
import '../comms/navBar.dart';
import '../comms/navModel.dart';
import '../component/drawer.dart';
import '../component/searchbar.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';
import "dart:math" show pi;

import '../viewmodel/dashboard_viewmodel.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  final bool? isSearching;
  const HomeScreen({super.key,
    this.isSearching});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseWidget<HomeScreen, DashBoardViewModel> {
  late DashBoardViewModel vm;
  int selectedTab = 0;
  //List<NavModel> items = [];
  GlobalKey<CircularMenuState>? key;
  bool isSearching  = false;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  final List<NavModel> items = [
    NavModel(page: HomeScreen(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: DashboardScreen(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: NotificationPage(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: ProfilePage(), navKey: GlobalKey<NavigatorState>()),
  ];

   PageController? _pageController;

  Widget buildSliderCard(String imagePath, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 100, // Adjust image size as needed
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchDocuments();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void onTabSelected(int index) {
    setState(() {
      selectedTab = index;
    });
    _pageController?.jumpToPage(index);
  }

    Future<void> _fetchDocuments() async {
      try {
        String? token = await TokenStorage.getToken();
        final dio = Dio();
        dio.options.headers['token'] = '$token';
        final response = await dio.get(
          '${Global.BASE_URL}api/get-documentlist',
        );

        if (response.statusCode == 200) {
          final documents = response.data['body'] as List<dynamic>;
          setState(() {
            vm.documentList = documents.map((doc) {
              return {
                'name': doc['originalName'],
                'type': doc['originalName'].endsWith('.pdf')
                    ? 'pdf'
                    : doc['originalName'].endsWith('.txt') ||
                    doc['originalName'].endsWith('.rtf')
                    ? 'txt'
                    : doc['originalName'].endsWith('.docx') ||
                    doc['originalName'].endsWith('.doc')
                    ? 'doc'
                    : doc['originalName'].endsWith('.PNG') ||
                    doc['originalName'].endsWith('.jpg')
                    ? 'img'
                    : 'other',
                'uploadTime': doc['created_at'],
                'fileSize': '${(doc['size'] / 1024).toStringAsFixed(2)} KB',
                'documentUrl': doc['document_url'],
                'originalName': doc['originalName'],
                'id': doc["_id"],
                //'fileName': doc["filename"],
              };
            }).toList();
            vm.filterData = List.from(vm.documentList);
          });
        }
      } catch (e) {
        print("Error fetching documents: $e");
      }
    }

  Future<Uint8List> getDocumentBytes(String fileUrl) async {
    try {
      // Make an HTTP GET request to fetch the document from the URL
      final response = await http.get(Uri.parse(fileUrl));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Return the document as bytes
        return response.bodyBytes;
      } else {
        throw Exception("Failed to load document");
      }
    } catch (e) {
      print("Error reading file: $e");
      throw Exception("Error fetching document bytes");
    }
  }

  String formatUploadTime(String timestamp) {
    try {
      // Parse the timestamp string
      DateTime parsedDate = DateTime.parse(timestamp);

      // Format to dd-MM-yy
      String formattedDate = DateFormat('dd-MM-yy').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle parsing errors if needed
      return "Invalid date";
    }
  }


  @override
  Widget buildContent(BuildContext context,  DashBoardViewModel baseNotifier) {
    vm = baseNotifier;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider section
            Container(
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [
              //       Themer.gradient1,
              //       Themer.gradient2
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              // ),
              height: 200,
              child: HomePageSlides(),
            ),
            // Document wallet info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document wallet to Empower Citizens',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'More than Millions of Indians getting benefits',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            // Documents you might need section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Document',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Scrollable Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DocumentIcon(title: 'Aadhaar Card', icon: Icons.account_box),
                        SizedBox(width: 16),
                        DocumentIcon(title: 'PAN Verification', icon: Icons.credit_card),
                        SizedBox(width: 16),
                        DocumentIcon(title: 'Vaccine Certificate', icon: Icons.verified),
                        SizedBox(width: 16),
                        DocumentIcon(title: 'Driving License', icon: Icons.directions_car),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Recent Document',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // itemCount: vm.filterData.length + 1,
              itemCount: (vm.filterData.length > 5 ? 5 : vm.filterData.length) + 1,
              itemBuilder: (context, index) {
                // if (index == vm.filterData.length) {
                //   return const SizedBox(height: 80);
                // }
                if (index == (vm.filterData.length > 5 ? 5 : vm.filterData.length)) {
                  return const SizedBox(height: 80);
                }

                int adjustedIndex = vm.filterData.length - (vm.filterData.length > 5 ? 5 : vm.filterData.length) + index;
                var document = vm.filterData[adjustedIndex];
               // var document = vm.filterData[index];

                // Skip non-matching items
                if (vm.selectedFilter != "all" &&
                    document["type"]?.toLowerCase() != vm.selectedFilter) {
                  return Container();
                }

                // Safely access fields with null-checks
                String name = document["name"] ?? "Unnamed Document";
                if (name.contains("_")) {
                  name = name.split("_").sublist(1).join("_");
                }
                String type = document["type"] ?? "Unknown";
                String uploadTime = document["uploadTime"] ?? "";
                String formattedTime = formatUploadTime(uploadTime);
                String fileSize = document["fileSize"]?.toString() ?? "Unknown Size";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                  child: Slidable(
                    endActionPane: ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          if (document["id"] != null) {
                            Helper.showDeleteDialog(context, document["id"],
                                  () {
                                setState(() {
                                  // Remove the document from the list directly
                                  vm.filterData.removeAt(index);
                                });
                              },
                            );
                          }
                        },
                        backgroundColor: Colors.red.shade300,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Helper.showRenameDialog(
                              context, document["name"] ?? "",
                            document["id"],
                                (oldFilename, newFilename) {
                              setState(() {
                                // Find the document in the list and update it
                                final index = vm.filterData.indexWhere(
                                        (doc) => doc["fileName"] == oldFilename);
                                if (index != -1) {
                                  vm.filterData[index]["name"] = newFilename;
                                }
                              });
                            },
                          );
                        },
                        backgroundColor: Themer.gradient1,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          if (document['documentUrl'] != null && document["originalName"] != null) {
                            Uint8List bytes = await getDocumentBytes(document['documentUrl']);
                            Helper.shareDocument(document["originalName"], bytes);
                          }
                        },
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                      ),
                    ]),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(
                          type == "PDF" ? Icons.picture_as_pdf : Icons.insert_drive_file,
                          color: type == "PDF" ? Colors.red : Colors.blue,
                          size: 40,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  formattedTime,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  fileSize,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 30,
                          child: IconButton(
                            onPressed: () async {
                              if (document['documentUrl'] != null) {
                                Uint8List bytes = await getDocumentBytes(document['documentUrl']);
                                Helper.showBottomSheet(context, bytes, document["id"],
                                  document["name"] ?? "",
                                    document["originalName"] ?? "",
                                      (oldFilename, newFilename) {
                                    setState(() {
                                      final index = vm.filterData.indexWhere(
                                              (doc) => doc["fileName"] == oldFilename);
                                      if (index != -1) {
                                        vm.filterData[index]["name"] = newFilename;
                                      }
                                    });
                                  },
                                      () {
                                    setState(() {
                                      // Remove the document from the list directly
                                      vm.filterData.removeAt(index);
                                    });
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                        onTap: () async {
                          try {
                            final url = document["documentUrl"];
                            final originalName = document["originalName"];

                            if (url != null && originalName != null) {
                              final directory = await getTemporaryDirectory();
                              final filePath = "${directory.path}/$originalName";

                              final file = File(filePath);
                              if (!file.existsSync()) {
                                final response = await http.get(Uri.parse(url));
                                if (response.statusCode == 200) {
                                  await file.writeAsBytes(response.bodyBytes);
                                } else {
                                  throw Exception("Failed to download file");
                                }
                              }

                              final result = await OpenFilex.open(filePath);
                              if (result.type != ResultType.done) {
                                throw Exception("Error opening file: ${result.message}");
                              }
                            } else {
                              throw Exception("Invalid file data");
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.toString()}")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

// Slider card widget for PageView
class SliderCard extends StatelessWidget {
  final String image;
  final String title;

  const SliderCard({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 150),
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Widget for displaying document statistics
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Themer.gradient1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying document icons
class DocumentIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const DocumentIcon({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Themer.gradient1),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            title,
            maxLines: 3,
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
