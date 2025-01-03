import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../screen/aboutUs.dart';
import '../screen/contactProfile.dart';
import '../screen/dashboard.dart';
import '../screen/delete_account_page.dart';
import '../screen/faqs.dart';
import '../screen/feedback.dart';
import '../screen/folderDetail.dart';
import '../screen/folderPage.dart';
import '../screen/forgotPassword.dart';
import '../screen/homePageSlide.dart';
import '../screen/homeScreen.dart';
import '../screen/homeTabPage.dart';
import '../screen/login.dart';
import '../screen/notificationPage.dart';
import '../screen/onboardingScreen.dart';
import '../screen/otpVerification.dart';
import '../screen/privacyPolicy.dart';
import '../screen/profilePage.dart';
import '../screen/resetPassword.dart';
import '../screen/setting.dart';
import '../theme/theme.dart';

class Helper{

  static Map<String, StatefulWidget Function(BuildContext)> routes = {
    "login": (BuildContext) => Login(),
    "forgot_password": (BuildContext) => ForgotPasswordPage(),
    "reset_password": (BuildContext) => ResetPasswordPage(),
    "dashboard": (BuildContext) => DashboardScreen(),
    "home": (BuildContext) => HomeScreen(),
    "notification_list": (BuildContext) => NotificationPage(),
    "profile": (BuildContext) => ProfilePage(),
    "about_us": (BuildContext) => AboutUsPage(),
    "contact_profile": (BuildContext) => ContactProfilePage(),
    "delete_account": (BuildContext) => DeleteAccountPage(),
    "faqs": (BuildContext) => FaqPage(),
    "feedback": (BuildContext) => RatingReviewPage(),
    "folder_detail": (BuildContext) => FolderDetailPage(),
    "folder": (BuildContext) => FolderPage(),
    "homepage_slide": (BuildContext) => HomePageSlides(),
    "home_tab": (BuildContext) => HomeTabPage(),
    "onboarding": (BuildContext) => OnboardingScreen(),
    "otp_verification": (BuildContext) => OtpVerification(),
    "privacy_policy": (BuildContext) => PrivacyPolicyPage(),
    "setting": (BuildContext) => SettingsPage(),
  };

  static  void showBottomSheet(BuildContext context, Uint8List bytes, String? docId,String? fileName, String? currentFilename ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 40.0, right: 20.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Option ', style: TextStyle(fontSize: 20),),
                  IconButton(
                      onPressed:() {
                        Navigator.pop(context);
                      },
                      icon:  Icon(Icons.close))
                ],
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showDeleteDialog(context,docId);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Rename'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showRenameDialog(context, fileName, currentFilename);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                shareDocument(currentFilename, bytes);
              },
            ),
          ],
        );
      },
    );
  }

  static void deleteDocument(String docId, BuildContext context) async {
    print('delete document id ==> ${docId}');
    final url = Global.BASE_URL +'documents/files/$docId';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // Success
        final responseBody = json.decode(response.body);
        if (responseBody["message"] == "File deleted successfully") {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('File deleted successfully'),
            ));
          }
        }
      } else {
        // Handle failure
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete file'),
          ));
        }
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while deleting the file'),
        ));
      }
    }
  }

  static void renameDocument(String fileName, String newFilename, BuildContext context) async {
    final url = Global.BASE_URL + 'documents/files/$fileName';
    final body = json.encode({
      "newFilename": newFilename,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('response body ==> ${responseBody}');
        if (responseBody["message"] == "File renamed successfully") {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('File renamed successfully'),
            ));
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to rename file'),
          ));
        }
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while renaming the file'),
        ));
      }
      }
  }


  static void showDeleteDialog(BuildContext context, String? docId) {
    print('showDeleteDialog id ==> ${docId}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete?'),
          content: Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('document id ============> ${docId}');
                Navigator.pop(context); // Close the dialog
                // Call the delete function with the filename
                deleteDocument(docId!, context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  static void showRenameDialog(BuildContext context,
      String? fileName, String? currentFilename) {
    TextEditingController _controller = TextEditingController(text: currentFilename);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Document'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                String newName = _controller.text;
                if(newName.isNotEmpty){
                  renameDocument(fileName!, newName, context);
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('New file name cannot be empty'),
                  ));
                }

              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  static shareDocument(String? originalName, Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$originalName');
    await tempFile.writeAsBytes(bytes);
     final XFile xFile = XFile(tempFile.path);

    // // Get the file path (this is just an example, update it to your actual file path)
    // String filePath = '/path/to/your/document.pdf';  // Replace with your document's path

    // Share the file using share_plus
    try {
      if (Platform.isAndroid) {
        await Share.shareXFiles([xFile], text: 'Check out this document!');
      } else if (Platform.isIOS) {
        final uri = Uri.file(tempFile.path);
        await Share.shareUri(uri,);
      }
     // await Share.shareXFiles([xFile], text: 'Check out this document!');
    } catch (e) {
      print('Error sharing document: $e');
    }
  }

  static var bottom_nav_selected = 0;

  static BottomNavigationBar getBottomBar(
      void Function(int index) bottomClick){
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Themer.gradient1,
      currentIndex: bottom_nav_selected,
      type: BottomNavigationBarType.fixed,
      onTap: bottomClick,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/round-home-24px.svg'),
          activeIcon: SvgPicture.asset(
            'assets/images/round-home-24px.svg',
            //color: Themer.textGreenColor,
            colorFilter: ColorFilter.mode(Themer.gradient1, BlendMode.srcIn),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/round-work-24px.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/round-work-24px.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.gradient1, BlendMode.srcIn),
            ),
            label: 'docs'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/edit_tm.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/edit_tm.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.gradient1, BlendMode.srcIn),
            ),
            label: 'Notification'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/round-send-24px.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/round-send-24px.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.gradient1, BlendMode.srcIn),
            ),
            label: 'profile'),
      ],
    );
  }

  static void bottomClickAction(int index, BuildContext context, Function updateState){
    if (index == bottom_nav_selected && 1 == 2) return;

    updateState((){
      bottom_nav_selected = index;
    });

    switch (index){
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPage(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
        break;
      default:
    }
  }

  static AppBar getAppBar(BuildContext context,
  {
    String title = "",
    bool? showIcon = false,
    bool shortingList = false,
    Widget? actions = null,
    bool isSearching = false,
    TextEditingController? searchController,
    void Function(String)? onSearchChanged,
    VoidCallback? onSearchToggle,
    VoidCallback? showSortOptions,
    IconData? icon,
  }){
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      // leading: drawer ?
      // Visibility(
      //     child: IconButton(onPressed: () {},
      //         icon: Icon(Icons.list))
      // ): null,
      backgroundColor: Themer.gradient1,
      title: isSearching ?
      TextField(
        style: const TextStyle(color: Themer.white),
        controller: searchController,
        // autofocus: true,
        decoration: InputDecoration(
          hintText: "Search documents...",
          hintStyle: TextStyle(color: Themer.white),
          border: InputBorder.none,
        ),
        onChanged: onSearchChanged,
      ):
      Row(
        children: [
          if(showIcon == true)...[
            Icon(icon, color: Colors.white),
            SizedBox(width: 5),
          ],
          // Icon(icon, color: Colors.white),
          // SizedBox(width: 5),
          Text(title,  style: TextStyle(color: Themer.white,fontSize: 20),),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Themer.white,
          ),
          onPressed: onSearchToggle,
        ),
        shortingList == true ?
        IconButton(
          icon: Icon(Icons.filter_list, color: Themer.white,),
          onPressed: showSortOptions,
        ): SizedBox(),
        if (actions != null) actions
      ],
    );
  }
}


