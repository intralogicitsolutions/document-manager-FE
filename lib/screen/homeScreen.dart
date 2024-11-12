import 'package:carousel_slider/carousel_slider.dart';
import 'package:document_manager/screen/homePageSlide.dart';
import 'package:document_manager/screen/notificationPage.dart';
import 'package:document_manager/screen/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import '../comms/navBar.dart';
import '../comms/navModel.dart';
import '../component/searchbar.dart';
import '../theme/theme.dart';
import "dart:math" show pi;

import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Themer.gradient1,
      //   elevation: 0,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(Icons.lock, color: Colors.white),
      //       SizedBox(width: 8),
      //       Text('Document Manager', style: TextStyle(color: Colors.white)),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Themer.gradient1,
        elevation: 0,
        title: isSearching  ?
        // SizedBox(
        //   height: 50,
        //   width: MediaQuery.of(context).size.width,
        //   child: TextField(
        //     style: const TextStyle(color: Colors.black),
        //     controller: searchController,
        //     // autofocus: true,
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //       filled: true,
        //       //contentPadding: EdgeInsets.all(16),
        //       hintText: "Search documents...",
        //       hintStyle: TextStyle(color: Colors.black),
        //       prefixIcon: Icon(Icons.search),
        //
        //     ),
        //     onChanged: (value) {},
        //   ),
        // )
        Searchbar((type) {

        })
            :const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: Colors.white),
            SizedBox(width: 8),
            Text('Document Manager', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching  ? Icons.close : Icons.search,color: Themer.white,),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                // searchController.clear();
                // _filterDocuments();
                if (!isSearching) {
                  searchQuery = "";
                  // filteredDocuments = List.from(documents); // Reset to all documents
                  // _sortDocuments();
                }
              });
            },
          ),
        ],
      ),
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
            SizedBox(height: 16),
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
