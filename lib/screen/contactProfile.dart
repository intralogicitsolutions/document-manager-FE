import 'package:appbase/base/base_widget.dart';
import 'package:document_manager/viewmodel/contactprofile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

class ContactProfilePage extends StatefulWidget {
  @override
  State<ContactProfilePage> createState() => _ContactProfilePageState();
}

class _ContactProfilePageState extends BaseWidget<ContactProfilePage, ContactProfileViewModel> {
  late ContactProfileViewModel vm;

  Widget contactInfoRow(String label, Widget info, {void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Themer.gradient1,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onTap,
                child: info),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final  uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget buildContent(BuildContext context, ContactProfileViewModel baseNotifier) {

    vm = baseNotifier;

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Themer.gradient1,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Contact Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Themer.gradient1,
        child: Column(
          children: [
            // Profile Icon Section
            Container(
              color: Themer.gradient1,
              child: Column(
                children: [
                 SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.group,
                        size: 50,
                        color:  Themer.gradient1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contact Information Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Themer.gradient1,
                          child: IconButton(
                            icon: Icon(Icons.call,
                              color: Themer.white,),
                            onPressed: () {
                              vm.makeCall("1234567890");
                            },
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Themer.gradient1,
                          child: IconButton(
                            icon: Icon(Icons.chat,color:  Themer.white,),
                            onPressed: () {
                             vm.openMessenger();
                            },
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Themer.gradient1,
                          child: IconButton(
                            icon: Icon(Icons.email,
                              color:  Themer.white,),
                            onPressed: () {
                              vm.sendEmail();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    Text(
                      "Contact Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    contactInfoRow("Website", Text(
                      "www.documentmanager.co.in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87,), textAlign: TextAlign.left,),
                        onTap: () {
                      _launchURL("https://www.documentmanager.co.in");
                    }),
                    contactInfoRow("Email", Text(
                      "support@documentmanager.com", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87,), textAlign: TextAlign.left,),
                        onTap: () {
                      _launchURL("mailto:support@documentmanager.com");
                    }),
                    contactInfoRow("Phone", Text(
                      "+91 1234567890", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87,), textAlign: TextAlign.left,),
                        onTap: () {
                      _launchURL("tel:+911234567890");
                    }),
                    contactInfoRow("Social", Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.facebook, color: Themer.gradient1),
                          onPressed: () {
                            // Open Facebook
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.language, color: Themer.gradient1),
                          onPressed: () {
                            // Open Twitter
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.facebook, color: Themer.gradient1),
                          onPressed: () {
                            // Open LinkedIn
                          },
                        ),
                      ],
                    )
                    ),
                   // SizedBox(height: 20,),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      child: Text(
                        '© 2024 IntraLogic itSolutions. All rights reserved.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
