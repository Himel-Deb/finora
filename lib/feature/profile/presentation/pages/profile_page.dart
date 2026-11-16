import 'dart:io';

import 'package:finora/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/auth/logic/bloc/auth_bloc.dart';
import 'package:finora/feature/auth/logic/event/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundImage:
                  user?.photoPath != null && File(user!.photoPath!).existsSync()
                  ? FileImage(File(user.photoPath!))
                  : null,
              child:
                  user?.photoPath == null ||
                      !File(user!.photoPath!).existsSync()
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              user?.name ?? 'Paylance User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Personal Information'),
            subtitle: const Text('Manage your profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
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

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);

                          context.read<AuthBloc>().add(LogoutRequested());

                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
