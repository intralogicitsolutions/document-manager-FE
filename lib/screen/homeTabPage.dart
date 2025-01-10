import 'dart:io';

import 'package:appbase/base/base_widget.dart';
import 'package:dio/dio.dart';
import 'package:document_manager/comms/helper.dart';
import 'package:document_manager/screen/profilePage.dart';
import 'package:document_manager/viewmodel/dashboard_viewmodel.dart';
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
import '../global/global.dart';
import '../theme/theme.dart';
import "dart:math" show cos, pi, sin;

import 'dashboard.dart';
import 'homeScreen.dart';
import 'notificationPage.dart';

class HomeTabPage extends StatefulWidget {
  final void Function(String)? onSearchChanged;
  final VoidCallback? onSearchToggle;
  final VoidCallback? onShowSortOptions;
  final TextEditingController? searchController;

  const HomeTabPage({
    Key? key,
    this.onSearchChanged,
    this.onSearchToggle,
    this.onShowSortOptions,
    this.searchController,
  }) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends BaseWidget<HomeTabPage, DashBoardViewModel>
    with SingleTickerProviderStateMixin {
  late DashBoardViewModel vm;

  int selectedTab = 0;

  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final GlobalKey<CircularMenuState> _menuKey = GlobalKey<CircularMenuState>();
  bool isMenuOpen = false;
  File? image;
  late AnimationController _controller;

  // final GlobalKey _key = GlobalKey();

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController();
    _requestPermissions();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void onTabSelected(int index) {
    // index == 1 ? _drawerKey.currentState?.openDrawer():
    setState(() {
      selectedTab = index;
      print('selected tab ==> ${selectedTab}');
    });
    _pageController?.jumpToPage(index);
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
    if (isMenuOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTapOutside() {
    if (isMenuOpen) {
      _toggleMenu();
    }
  }

  @override
  Widget buildContent(BuildContext context, DashBoardViewModel baseNotifier) {
    vm = baseNotifier;

    final screenWidth = MediaQuery.of(context).size.width;
    print('selected ==> ${selectedTab}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: selectedTab == 0 || selectedTab == 1
          ? Helper.getAppBar(context,
              title: selectedTab == 1 ? 'All Documents' : 'Document Manager',
              showIcon: selectedTab == 0 ? true : false,
              icon: selectedTab == 0 ? Icons.lock : null,
              onSearchChanged: vm.doSearch,
              isSearching: vm.isSearching,
              onSearchToggle: vm.toggleSearch,
              showSortOptions: selectedTab == 1 ? vm.showSortOptions : null,
              searchController: vm.searchController,
              shortingList: selectedTab == 1 ? true : false)
          : null,
      drawer: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CustomDrawer.show(context)),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTapOutside,
        child: Stack(
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
                //onTap: onTabSelected,
                onTap: (p0) {
                  onTabSelected(p0);
                  _handleTapOutside();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        spreadRadius: 4,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    backgroundColor: Themer.gradient1,
                    shape: CircleBorder(),
                    onPressed: _toggleMenu,
                    child: AnimatedIcon(
                      icon: isMenuOpen
                          ? AnimatedIcons.menu_close
                          : AnimatedIcons.add_event,
                      progress: _controller,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // The CircularMenu items will be shown here when the menu is open
            if (isMenuOpen)
              Positioned.fill(
                bottom: -100,
                // right: 50,
                child: Stack(
                  children: List.generate(4, (index) {
                    //final angle = index * (pi / 5);
                    final angle = pi / 4 * (index - 1.5);
                    final radius = 90.0;
                    final xPosition = radius * sin(angle);
                    final yPosition = radius * cos(angle);

                    return Positioned(
                      //bottom: yPosition,
                      bottom: 150 + yPosition,
                      left: (screenWidth / 2) + xPosition - 25,
                      // right: xPosition,
                      child: CircularMenuItem(
                        icon: [
                          Icons.picture_as_pdf,
                          Icons.camera_alt,
                          Icons.photo,
                          Icons.insert_drive_file,
                        ][index],
                        color: [
                          Colors.green,
                          Colors.orange,
                          Colors.deepPurple,
                          Colors.pink,
                        ][index],
                        onTap: () async {
                          if (index == 1) {
                            vm.addFromCamera();
                          } else if (index == 2) {
                            vm.addFromGallery();
                          } else if (index == 3) {
                            vm.addDocument();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CircularMenuItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const CircularMenuItem(
      {Key? key, required this.icon, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        shape: CircleBorder(),
        elevation: 5,
        shadowColor: color,
        child: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
