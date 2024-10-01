import 'package:flutter/material.dart';

class ToggleListView extends StatefulWidget {
  @override
  _ToggleListViewState createState() => _ToggleListViewState();
}

class _ToggleListViewState extends State<ToggleListView> {
  // Sample data for the ListView
  final List<Map<String, dynamic>> items = [
    {"name": "John Doe", "image": "assets/avatar1.png", "toggle": true},
    {"name": "Jane Smith", "image": "assets/avatar2.png", "toggle": false},
    {"name": "Alex Johnson", "image": "assets/avatar3.png", "toggle": true},
    {"name": "Mary Williams", "image": "assets/avatar4.png", "toggle": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListView with Toggle and Avatars')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(items[index]['image']),
              radius: 25, // Adjust radius for avatar size
            ),
            title: Text(items[index]['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (items[index]['toggle']) // Toggle button for specific items
                  Switch(
                    value: items[index]['toggle'],
                    onChanged: (value) {
                      setState(() {
                        items[index]['toggle'] = value;
                      });
                    },
                  ),
                Icon(Icons.chevron_right), // ">" icon on the right
              ],
            ),
            onTap: () {
              // Handle list item tap, if needed
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ToggleListView(),
  ));
}
