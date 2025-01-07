import 'package:document_manager/comms/helper.dart';
import 'package:document_manager/dialogs/deleteConfirmationDialog.dart';
import 'package:document_manager/screen/resetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme.dart';
import 'delete_account_page.dart';
import 'feedback.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load the theme preference from SharedPreferences
  _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save the theme preference
  _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
       title: Text("Setting", style: TextStyle(fontSize: 20,color: Colors.white),),
       backgroundColor: Themer.gradient1,
       leading: IconButton(
         icon: SvgPicture.asset(
           "assets/images/ios-back-arrow.svg",
           colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
         ),
         onPressed: () {
           Navigator.pop(context);
         },
       ),
     ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Enable Dark Mode', style: TextStyle(color: Themer.textColor , fontSize: 18),),
            trailing: SizedBox(
              width: 30,
              child: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                    _saveThemePreference(value);
                    _toggleTheme();
                  });
                },
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Change Password', style: TextStyle(color: Themer.textColor,fontSize: 18),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined , color: Themer.textColor,size: 18,),
          ),
          Divider(),
          ListTile(
            title: Text('Feedback', style: TextStyle(color: Themer.textColor,fontSize: 18),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RatingReviewPage()),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined , color: Themer.textColor,size: 18,),
          ),
          Divider(),
          ListTile(
            title: Text('Delete Account', style: TextStyle(color: Themer.textColor,fontSize: 18),),
            onTap: () {
              // showDeleteConfirmationDialog(context);
              Helper.showDeleteConfirmationDialog(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => DeleteAccountPage()),
              // );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined , color: Themer.textColor,size: 18,),
          ),
          Divider(),

        ],
      ),
    );
  }

  void _toggleTheme() {
    if (_isDarkMode) {
      ThemeData.dark();
    } else {
      ThemeData.light();
    }
  }
}

