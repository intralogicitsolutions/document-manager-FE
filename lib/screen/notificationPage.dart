import 'package:document_manager/component/searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample notification data
  final List<Map<String, String>> notifications = [
    {
      'title': 'New message from IntraLogic',
      'body': 'Hey, how are you? Let\'s meet up tomorrow.',
      'time': '2 minutes ago'
    },
    {
      'title': 'Your order has been shipped',
      'body': 'Your order #12345 has been shipped and will arrive tomorrow.',
      'time': '5 hours ago'
    },
    {
      'title': 'New comment on your post',
      'body': 'Flutter commented on your post: "Great post!"',
      'time': '1 day ago'
    },
    {
      'title': 'App update available',
      'body': 'A new version of the app is available. Please update to the latest version.',
      'time': '3 days ago'
    },
  ];

  bool isSearching  = false;

  String searchQuery = "";

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themer.gradient1,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isSearching  ?
          Searchbar((type) {

          })
              :Text('Notification', style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            elevation: 5,
            child: ListTile(
              leading: Icon(Icons.circle_notifications_rounded, color: Themer.gradient1,size: 34,),
              title: Text(
                notification['title']!,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                notification['body']!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: Text(
                notification['time']!,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Handle notification tap (e.g., navigate to the details page)
                _showNotificationDetails(context, notification);
              },
            ),
          );
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, Map<String, String> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']!),
        content: Text(notification['body']!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
