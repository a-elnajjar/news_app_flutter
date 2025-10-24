import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '';
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Unable to load app information.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Version',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(_errorMessage!, style: Theme.of(context).textTheme.bodyMedium)
            else
              Text('Version $_appVersion'),
            const SizedBox(height: 16.0),
            Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Navigate to Terms and Conditions screen or show a dialog
              },
              child: const Text(
                'View Terms and Conditions',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Contact Support',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Handle contact support, e.g., open an email app or navigate to a support screen
              },
              child: const Text(
                'support@example.com',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
