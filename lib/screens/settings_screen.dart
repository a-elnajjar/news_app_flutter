import 'package:flutter/material.dart';

import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('Update your profile information'),
            onTap: () {
              // Navigate to Profile settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification settings'),
            onTap: () {
              // Navigate to Notification settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: const Text('Customize app theme'),
            trailing: Switch(
              value: false, // This should be a state variable in a StatefulWidget
              onChanged: (value) {
                // Handle theme change
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            subtitle: const Text('Manage privacy settings'),
            onTap: () {
              // Navigate to Privacy settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Change app language'),
            onTap: () {
              // Navigate to Language settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('App version, terms, and contact support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
