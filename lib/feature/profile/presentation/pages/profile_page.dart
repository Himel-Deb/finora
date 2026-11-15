
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Paylance User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Center(
            child: Text(
              'Personal Finance Tracker',
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 30),

          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Personal Information'),
            subtitle: Text('Manage your profile'),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacy & Security'),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Paylance'),
            subtitle: Text('Track Today. Grow Tomorrow.'),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.code),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
