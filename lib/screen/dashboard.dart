import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:appbase/base/base_widget.dart';
import 'package:dio/dio.dart';
import 'package:document_manager/comms/helper.dart';
import 'package:document_manager/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../comms/navModel.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends BaseWidget<DashboardScreen, DashBoardViewModel> {
  late DashBoardViewModel vm;
  String searchQuery = "";

  //Uint8List bytes = await getDocumentBytes();

  @override
  // void onCreate() {
  //   super.onCreate();
  //   vm.init();
  //   //vm.fetchDocuments();
  //   _fetchDocuments();
  // }



  @override
  void initState() {
    super.initState();
    //vm.filterData = List.from(vm.documentList);
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    try {
      String? token = await TokenStorage.getToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        Global.BASE_URL+'documents/files/${Global.userId}',
      );

      if (response.statusCode == 200) {
        final documents = response.data['data'] as List<dynamic>;
        setState(() {
          vm.documentList = documents.map((doc) {
            return {
              'name': doc['originalName'],
              'type': doc['filename'].endsWith('.pdf')
                  ? 'pdf'
                  : doc['filename'].endsWith('.txt') ||
                          doc['filename'].endsWith('.rtf')
                      ? 'txt'
                      : doc['filename'].endsWith('.docx') ||
                              doc['filename'].endsWith('.doc')
                          ? 'doc'
                          : doc['filename'].endsWith('.PNG') ||
                                  doc['filename'].endsWith('.jpg')
                              ? 'img'
                              : 'other',
              'uploadTime': doc['createdAt'],
              'fileSize': '${(doc['size'] / 1024).toStringAsFixed(2)} KB',
              'documentUrl': doc['document_url'],
              'originalName': doc['originalName'],
              'id': doc["_id"],
              'fileName': doc["filename"],
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
  Widget buildContent(BuildContext context, DashBoardViewModel baseNotifier) {
    vm = baseNotifier;

    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //children: ["all", "pdf", "doc", "img", "ppt", "txt"]
                      children: ["all", "pdf", "doc", "txt", "img", "other"]
                          .map((filter) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(
                                    filter.toUpperCase(),
                                    style: TextStyle(
                                      color: vm.selectedFilter == filter
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: vm.selectedFilter == filter,
                                  selectedColor: Themer.gradient1,
                                  checkmarkColor: Themer.white,
                                  onSelected: (isSelected) {
                                    setState(() {
                                      vm.selectedFilter =
                                          isSelected ? filter : "all";
                                      vm.doSearch(searchQuery);
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: vm.filterData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == vm.filterData.length) {
                        return const SizedBox(height: 80);
                      }

                      var document = vm.filterData[index];

                      // Skip non-matching items
                      if (vm.selectedFilter != "all" &&
                          document["type"]?.toLowerCase() != vm.selectedFilter) {
                        return Container();
                      }

                      // Safely access fields with null-checks
                      String name = document["name"] ?? "Unnamed Document";
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
                                  Helper.showDeleteDialog(context, document["id"]);
                                }
                              },
                              backgroundColor: Colors.red.shade300,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Helper.showRenameDialog(
                                    context, document["fileName"] ?? "", document["originalName"] ?? "");
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
                                      Helper.showBottomSheet(context, bytes, document["id"], document["fileName"] ?? "",
                                          document["originalName"] ?? "");
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
                )


                // Expanded(
                //   child: ListView.builder(
                //     itemCount: vm.filterData.length + 1,
                //     // Add 1 to include the SizedBox
                //     itemBuilder: (context, index) {
                //       // Check if the current index is the additional one (after the last item)
                //       if (index == vm.filterData.length) {
                //         return SizedBox(
                //             height: 80); // Space after the last list item
                //       }
                //
                //       var document = vm.filterData[index];
                //
                //       // Skip non-matching items
                //       if (vm.selectedFilter != "all" &&
                //           document["type"]!.toLowerCase() !=
                //               vm.selectedFilter) {
                //         return Container();
                //       }
                //       String uploadTime = document["uploadTime"];
                //       String formattedTime = formatUploadTime(uploadTime);
                //
                //       // Return List Item
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 4.0, horizontal: 10),
                //         child: Slidable(
                //           endActionPane:
                //               ActionPane(motion: BehindMotion(), children: [
                //             SlidableAction(
                //               onPressed: (context) {
                //                 print('all document data ==> ${document}');
                //                 print('document id ==> ${document["id"]}');
                //                 Helper.showDeleteDialog(
                //                     context, document["id"]);
                //               },
                //               backgroundColor: Colors.red.shade300,
                //               foregroundColor: Colors.white,
                //               icon: Icons.delete,
                //             ),
                //             SlidableAction(
                //               onPressed: (context) {
                //                 Helper.showRenameDialog(
                //                     context,
                //                     document["fileName"],
                //                     document["originalName"]);
                //               },
                //               backgroundColor: Themer.gradient1,
                //               foregroundColor: Colors.white,
                //               icon: Icons.edit,
                //             ),
                //             SlidableAction(
                //               onPressed: (context) async {
                //                 print('document data ==> ${document}');
                //                 Uint8List bytes = await getDocumentBytes(
                //                     document['documentUrl']);
                //                 Helper.shareDocument(
                //                     document["originalName"], bytes);
                //               },
                //               backgroundColor: Colors.green.shade400,
                //               foregroundColor: Colors.white,
                //               icon: Icons.share,
                //             ),
                //           ]),
                //           child: Card(
                //             child: ListTile(
                //               leading: Icon(
                //                 document["type"] == "PDF"
                //                     ? Icons.picture_as_pdf
                //                     : Icons.insert_drive_file,
                //                 color: document["type"] == "PDF"
                //                     ? Colors.red
                //                     : Colors.blue,
                //                 size: 40,
                //               ),
                //               title: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(document["name"]!),
                //                   const SizedBox(height: 5),
                //                   Row(
                //                     children: [
                //                       Text(
                //                         formattedTime,
                //                         style: TextStyle(
                //                             color: Colors.grey[600],
                //                             fontSize: 14),
                //                         overflow: TextOverflow.ellipsis,
                //                         maxLines: 1,
                //                       ),
                //                       const SizedBox(width: 12),
                //                       Text(
                //                         "${document["fileSize"]}",
                //                         style: TextStyle(
                //                             color: Colors.grey[600],
                //                             fontSize: 14),
                //                         overflow: TextOverflow.ellipsis,
                //                         maxLines: 1,
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               trailing: SizedBox(
                //                 width: 30,
                //                 child: IconButton(
                //                   onPressed: () async {
                //                     Uint8List bytes = await getDocumentBytes(
                //                         document['documentUrl']);
                //                     Helper.showBottomSheet(context, bytes, document["id"], document["fileName"],
                //                         document["originalName"] );
                //                   },
                //                   icon: Icon(Icons.more_vert),
                //                 ),
                //               ),
                //               onTap: () async {
                //                 print('enter gesture detector');
                //                 print("Document: ${document}");
                //                 try {
                //                   final url = document["documentUrl"];
                //                   final originalName = document["originalName"];
                //                   print('original name ==> ${originalName}');
                //                   print('document url ==> ${url}');
                //
                //                   // Get the temporary directory
                //                   final directory =
                //                       await getTemporaryDirectory();
                //                   final filePath =
                //                       "${directory.path}/$originalName";
                //                   print('file path ==> ${filePath}');
                //
                //                   // Check if the file already exists
                //                   final file = File(filePath);
                //                   if (!file.existsSync()) {
                //                     // Download the file
                //                     final response =
                //                         await http.get(Uri.parse(url));
                //                     if (response.statusCode == 200) {
                //                       await file
                //                           .writeAsBytes(response.bodyBytes);
                //                     } else {
                //                       throw Exception(
                //                           "Failed to download file");
                //                     }
                //                   }
                //
                //                   // Open the file using open_filex
                //                   final result = await OpenFilex.open(filePath);
                //                   if (result.type != ResultType.done) {
                //                     throw Exception(
                //                         "Error opening file: ${result.message}");
                //                   }
                //                 } catch (e) {
                //                   // Handle errors gracefully
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text("Error: ${e.toString()}")),
                //                   );
                //                 }
                //               },
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
