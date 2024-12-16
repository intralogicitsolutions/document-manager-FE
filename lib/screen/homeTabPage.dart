import 'dart:io';

import 'package:document_manager/screen/profilePage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:document_manager/screen/homePageSlide.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../comms/navBar.dart';
import '../comms/navModel.dart';
import '../component/drawer.dart';
import '../component/searchbar.dart';
import '../theme/theme.dart';
import "dart:math" show pi;

import 'dashboard.dart';
import 'homeScreen.dart';
import 'notificationPage.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  int selectedTab = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  GlobalKey<CircularMenuState>? key;
  bool isMenuOpen = false;
  File? image;

  final List<NavModel> items = [
    NavModel(page: HomeScreen(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: DashboardScreen(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: NotificationPage(), navKey: GlobalKey<NavigatorState>()),
    NavModel(page: ProfilePage(), navKey: GlobalKey<NavigatorState>()),
  ];

   PageController? _pageController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _requestPermissions();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void onTabSelected(int index) {
    // index == 1 ? _drawerKey.currentState?.openDrawer():
    setState(() {
      selectedTab = index;
    });
    _pageController?.jumpToPage(index);
  }
  // Future<void> pickImage() async {
    // final ImagePicker _picker = ImagePicker();
    //
    // final pickedSource = await showDialog<ImageSource>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Select Image Source', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context, ImageSource.camera),
    //           child: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
    //         ),
    //         TextButton(
    //           onPressed: () => Navigator.pop(context, ImageSource.gallery),
    //           child: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
    //         ),
    //       ],
    //     );
    //   },
    // );
    //
    // if (pickedSource != null) {
    //   final XFile? pickedImage = await _picker.pickImage(source: pickedSource);
    //
    //   if (pickedImage != null) {
    //     setState(() {
    //       image = File(pickedImage.path);
    //     });
    //   }
    // }
  // }
  Future<void> _pickImage(ImageSource source) async {
    try {
      print('Enter pick image');
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        print('Picked image: ${image.path}');
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
      if (result != null) {
        final String? filePath = result.files.single.path;
        print('Picked document: $filePath');
        // You can handle the selected document here
      }
    } catch (e) {
      print("Error picking document: $e");
    }
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
     // appBar: selectedTab == 1 ? AppBar(title: Text('Al Documents'),): null,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: items.map((item) => item.page).toList(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
              child: NavBar(
                pageIndex: selectedTab,
                onTap: onTabSelected,
              ),
          ),
          Align(
            // bottom: 70.0,
            // left: MediaQuery.of(context).size.width / 2 - 32,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularMenu(
                toggleButtonSize: 30,
                toggleButtonPadding: 10,
                toggleButtonColor: Themer.gradient1,
                toggleButtonAnimatedIconData: !isMenuOpen? AnimatedIcons.add_event : AnimatedIcons.menu_close,
                toggleButtonMargin: 10,
                alignment: Alignment.bottomCenter,
                startingAngleInRadian: 1.10 * pi,
                endingAngleInRadian: 1.90 * pi,
                toggleButtonBoxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                    blurRadius: 8,
                    spreadRadius: 2
                  )
                ],
                key: key,
                items: [
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.picture_as_pdf,
                    onTap: () {

                    },
                    color: Colors.green,
                    iconColor: Colors.white,
                  ),
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.camera_alt,
                    onTap: () { _pickImage(ImageSource.camera);},
                    color: Colors.orange,
                    iconColor: Colors.white,
                  ),
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.photo,
                    onTap: () { _pickImage(ImageSource.gallery);},
                    color: Colors.deepPurple,
                    iconColor: Colors.white,
                  ),
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.insert_drive_file,
                    onTap: _pickDocument,
                    color: Colors.pink,
                    iconColor: Colors.white,
                  ),
                ],
                toggleButtonOnPressed: _toggleMenu,

              ),
            ),
          ),

        ],
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
      //     child: Material(
      //       //color: Colors.purple,
      //       shape: RoundedRectangleBorder(
      //         side: const BorderSide(width: 3, color: Themer.gradient1),
      //         borderRadius: BorderRadius.circular(100),
      //       ),
      //       elevation: 10,
      //       // shadowColor: Colors.purple,
      //       child: Container(
      //         height: 64.0,
      //         width: 64.0,
      //         child: FloatingActionButton(
      //           shape: RoundedRectangleBorder(
      //             side: const BorderSide(width: 3, color: Themer.gradient1),
      //             borderRadius: BorderRadius.circular(100),
      //           ),
      //           backgroundColor: Themer.gradient1,
      //           onPressed: () {
      //             _toggleMenu;
      //           },
      //           //  child: const Icon(Icons.add, color: Themer.white,size: 26,),
      //           child: CircularMenu(
      //             toggleButtonSize: 25,
      //             toggleButtonPadding: 10,
      //             toggleButtonColor: Themer.gradient1,
      //             toggleButtonAnimatedIconData: !isMenuOpen? AnimatedIcons.add_event : AnimatedIcons.menu_close,
      //             toggleButtonMargin: 10,
      //             alignment: Alignment.bottomCenter,
      //             startingAngleInRadian: 1.10 * pi,
      //             endingAngleInRadian: 1.90 * pi,
      //             key: key,
      //             items: [
      //               CircularMenuItem(
      //                 padding: 7,
      //                 margin: 7,
      //                 icon: Icons.picture_as_pdf,
      //                 onTap: () {
      //                   print('pdf click');
      //                 },
      //                 color: Colors.green,
      //                 iconColor: Colors.white,
      //               ),
      //               CircularMenuItem(
      //                 padding: 7,
      //                 margin: 7,
      //                 icon: Icons.camera_alt,
      //                 onTap: () => pickImage,
      //                 color: Colors.orange,
      //                 iconColor: Colors.white,
      //               ),
      //               CircularMenuItem(
      //                 padding: 7,
      //                 margin: 7,
      //                 icon: Icons.photo,
      //                 onTap: () { _pickImage(ImageSource.gallery);},
      //                 color: Colors.deepPurple,
      //                 iconColor: Colors.white,
      //               ),
      //               CircularMenuItem(
      //                 padding: 7,
      //                 margin: 7,
      //                 icon: Icons.insert_drive_file,
      //                 onTap: _pickDocument,
      //                 color: Colors.pink,
      //                 iconColor: Colors.white,
      //               ),
      //             ],
      //             toggleButtonOnPressed: _toggleMenu,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: NavBar(
      //   pageIndex: selectedTab,
      //   onTap: onTabSelected,
      // ),
    );
  }
}


class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addArc(
      Rect.fromLTWH(0, size.height / 2, size.width, size.height), // Half-circle
      pi, // Start angle
      pi, // Sweep angle
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
  }