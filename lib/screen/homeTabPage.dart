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
import '../theme/theme.dart';
import "dart:math" show pi;

import 'dashboard.dart';
import 'homeScreen.dart';
import 'notificationPage.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  int selectedTab = 0;
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
    setState(() {
      selectedTab = index;
    });
    _pageController?.jumpToPage(index);
  }
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final XFile? pickedImage = await _picker.pickImage(source: pickedSource);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
    }
  }
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
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: items.map((item) => item.page).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
        child: Material(
          //color: Colors.purple,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: Themer.gradient1),
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 10,
          // shadowColor: Colors.purple,
          child: Container(
            height: 64.0,
            width: 64.0,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 3, color: Themer.gradient1),
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: Themer.gradient1,
              onPressed: () {

              },
              //  child: const Icon(Icons.add, color: Themer.white,size: 26,),
              child: CircularMenu(
                toggleButtonSize: 28,
                toggleButtonColor: Themer.gradient1,
                toggleButtonAnimatedIconData: !isMenuOpen? AnimatedIcons.add_event : AnimatedIcons.menu_close,
                toggleButtonMargin: 10,
                alignment: Alignment.bottomCenter,
                startingAngleInRadian: 1.10 * pi,
                endingAngleInRadian: 1.90 * pi,
                key: key,
                items: [
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.picture_as_pdf,
                    onTap: () {},
                    color: Colors.green,
                    iconColor: Colors.white,
                  ),
                  CircularMenuItem(
                    padding: 7,
                    margin: 7,
                    icon: Icons.camera_alt,
                    onTap: () => pickImage,
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
        ),
      ),

      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
        onTap: onTabSelected,
      ),
    );
  }
}







