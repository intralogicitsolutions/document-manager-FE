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
  void initState() {
    super.initState();
    //vm.filterData = List.from(vm.documentList);
    //  _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    try {
      String? token = await TokenStorage.getToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        Global.BASE_URL + 'documents/files/${Global.userId}',
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
                              : doc['filename'].endsWith('.pptx') ||
                                      doc['filename'].endsWith('.ppt')
                                  ? 'ppt'
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
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
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
      DateTime parsedDate = DateTime.parse(timestamp);
      String formattedDate = DateFormat('dd-MM-yy').format(parsedDate);

      return formattedDate;
    } catch (e) {
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
                      children: [
                        "all",
                        "pdf",
                        "doc",
                        "txt",
                        "img",
                        "ppt",
                        "other"
                      ]
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
                  child: vm.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          // reverse: true,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                         // controller: vm.scrollController,
                          itemCount: vm.filterData.length + 1,
                          itemBuilder: (context, index) {
                            if (index == vm.filterData.length) {
                              return const SizedBox(height: 80);
                            }
                            var reversedData = vm.filterData.reversed.toList();
                            var document = reversedData[index];

                           // var document = vm.filterData[index];

                            if (vm.selectedFilter != "all" &&
                                document["type"]?.toLowerCase() !=
                                    vm.selectedFilter) {
                              return Container();
                            }

                            String name =
                                document["name"] ?? "Unnamed Document";
                            if (name.contains("_")) {
                              name = name.split("_").sublist(1).join("_");
                            }
                            String type = document["type"] ?? "Unknown";
                            String uploadTime = document["uploadTime"] ?? "";
                            String formattedTime = formatUploadTime(uploadTime);
                            String fileSize =
                                document["fileSize"]?.toString() ??
                                    "Unknown Size";

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          if (document["id"] != null) {
                                            Helper.showDeleteDialog(
                                              context,
                                              document["id"],
                                              () {
                                                setState(() {
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
                                            context,
                                            document["id"],
                                            name ?? "",
                                            (docId, newFilename) {
                                              setState(() {
                                                final index = vm.filterData
                                                    .indexWhere((doc) =>
                                                        doc["id"] == docId);
                                                if (index != -1) {
                                                  vm.filterData[index]["name"] =
                                                      newFilename;
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
                                          if (document['documentUrl'] != null &&
                                              document["originalName"] !=
                                                  null) {
                                            Uint8List bytes =
                                                await getDocumentBytes(
                                                    document['documentUrl']);
                                            Helper.shareDocument(
                                                name,
                                                //document["originalName"],
                                                bytes);
                                          }
                                        },
                                        backgroundColor: Colors.green.shade400,
                                        foregroundColor: Colors.white,
                                        icon: Icons.share,
                                      ),
                                    ]),
                                child: Card(
                                  child: ListTile(
                                    //leading: ImageIcon( AssetImage('assets/icons/pdf.png'),),
                                    leading: Image.asset(
                                      document["type"]?.toLowerCase() == "pdf"
                                          ? 'assets/icons/pdf.png'
                                          : document["type"]?.toLowerCase() ==
                                                  "img"
                                              ? 'assets/icons/jpg.png'
                                              : document["type"]
                                                          ?.toLowerCase() ==
                                                      "doc"
                                                  ? 'assets/icons/doc.png'
                                                  : document["type"]
                                                              ?.toLowerCase() ==
                                                          "txt"
                                                      ? 'assets/icons/txt.png'
                                                      : document["type"]
                                                                  ?.toLowerCase() ==
                                                              "ppt"
                                                          ? 'assets/icons/pptx.png'
                                                          : 'assets/icons/other.png',
                                      height: 30,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              fileSize,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        onPressed: () async {
                                          if (document['documentUrl'] != null) {
                                            Uint8List bytes =
                                                await getDocumentBytes(
                                                    document['documentUrl']);
                                            Helper.showBottomSheet(
                                              context,
                                              bytes,
                                              document["id"],
                                              name,
                                              // document["originalName"] ?? "",
                                              (docId, newFilename) {
                                                setState(() {
                                                  // Find the document in the list and update it
                                                  final index = vm.filterData
                                                      .indexWhere((doc) =>
                                                          doc["id"] == docId);
                                                  if (index != -1) {
                                                    vm.filterData[index]
                                                        ["name"] = newFilename;
                                                  }
                                                });
                                              },
                                              () {
                                                setState(() {
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
                                        final originalName = name;
                                        print(
                                            'document url ==> ${url} , originalname ==> ${originalName}');
                                        if (url != null &&
                                            originalName != null) {
                                          final directory =
                                              await getTemporaryDirectory();
                                          final filePath =
                                              "${directory.path}/$originalName";
                                          print('file path ==> ${filePath}');
                                          final file = File(filePath);
                                          if (!file.existsSync()) {
                                            final response =
                                                await http.get(Uri.parse(url));
                                            print(
                                                'document response ==> ${response}');
                                            if (response.statusCode == 200) {
                                              await file.writeAsBytes(
                                                  response.bodyBytes);
                                            } else {
                                              throw Exception(
                                                  "Failed to download file");
                                            }
                                          }
                                          final result =
                                              await OpenFilex.open(filePath);
                                          print(
                                              'result type ==> ${result.type}');
                                          if (result.type != ResultType.done) {
                                            throw Exception(
                                                "Error opening file: ${result.message}");
                                          }
                                        } else {
                                          throw Exception("Invalid file data");
                                        }
                                      } catch (e) {
                                        print('Error is : ${e.toString()}');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Error: ${e.toString()}")),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
