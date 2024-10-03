import 'package:flutter/material.dart';
import 'package:wallet/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<Map<String, dynamic>>? profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = SettingsService.fetchUserProfile(); // Fetch user profile
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          FutureBuilder<Map<String, dynamic>>(
            future: profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${snapshot.data!['name']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${snapshot.data!['email']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle update profile
                      },
                      child: Text('Update Profile'),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
