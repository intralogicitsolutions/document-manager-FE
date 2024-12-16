import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ContactProfilePage extends StatefulWidget {
  @override
  State<ContactProfilePage> createState() => _ContactProfilePageState();
}

class _ContactProfilePageState extends State<ContactProfilePage> {
  Widget contactInfoRow(String label, String info) {
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
            child: Text(
              info,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Icon(
                            Icons.call,
                            color: Themer.white,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Themer.gradient1,
                          child: Icon(
                            Icons.chat,
                            color:  Themer.white,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Themer.gradient1,
                          child: Icon(
                            Icons.email,
                            color:  Themer.white,
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
                    contactInfoRow("Website", "www.documentmanager.co.in"),
                    contactInfoRow("Email", "support@documentmanager.com"),
                    contactInfoRow("Phone", "+91 1234567890"),
                    contactInfoRow("Social", "IntraLogic itSolutions"),
                    SizedBox(height: 20,),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
