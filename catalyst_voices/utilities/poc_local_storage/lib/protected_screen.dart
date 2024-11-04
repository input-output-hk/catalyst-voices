// ignore_for_file: use_build_context_synchronously, discarded_futures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_local_storage/main.dart';

class ProtectedScreen extends StatefulWidget {
  const ProtectedScreen({super.key});

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  List<String> _certificates = [];
  bool _isLoading = true;
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protected Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_reset),
            onPressed: _showResetPasswordConfirmation,
            tooltip: 'Reset Password',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the protected screen!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickAndStoreCertificates,
              icon: const Icon(Icons.add),
              label: const Text('Pick and Store Certificates'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stored Certificates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _certificates.isEmpty
                      ? const Center(child: Text('No certificates stored yet.'))
                      : ListView.builder(
                          itemCount: _certificates.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_certificates[index]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () async =>
                                        _showCertificateDetails(
                                      _certificates[index],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async => _deleteCertificate(
                                      _certificates[index],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _deleteCertificate(String certificateName) async {
    try {
      await certificateRepo.deleteCertificate(certificateName);
      await _loadCertificates();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete certificate')),
      );
    }
  }

  Future<void> _loadCertificates() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final certificates = await certificateRepo.getStoredCertificateNames();
      setState(() {
        _certificates = certificates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndStoreCertificates() async {
    final password = await _promptForPassword(
      'Enter a password to encrypt the certificates',
    );
    if (password != null && password.isNotEmpty) {
      try {
        if (await certificateRepo.verifyPassword(password)) {
          final storedCertificates =
              await certificateRepo.pickAndStoreCertificates(password);
          if (storedCertificates.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${storedCertificates.length} certificate(s) stored',
                ),
              ),
            );
            await _loadCertificates();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No certificates were selected or stored',
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed. Incorrect password.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is required to store certificates'),
        ),
      );
    }
  }

  Future<String?> _promptForPassword(String message) async {
    _passwordController.clear();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () =>
                  Navigator.of(context).pop(_passwordController.text),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    try {
      await certificateRepo.deleteAllCertificates();
      await certificateRepo.deletePassword();
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to reset password and delete certificates'),
        ),
      );
    }
  }

  Future<void> _showCertificateDetails(String certificateName) async {
    final password = await _promptForPassword(
      'Enter the password to view certificate details',
    );
    if (password != null) {
      try {
        if (await certificateRepo.verifyPassword(password)) {
          final certificateContent = await certificateRepo.getCertificate(
            certificateName,
            password,
          );
          if (certificateContent != null && certificateContent.isNotEmpty) {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Certificate Details: $certificateName'),
                  content:
                      SingleChildScrollView(child: Text(certificateContent)),
                  actions: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '''Failed to load certificate. Certificate might be empty or not found.''',
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load certificate. Error: $e'),
          ),
        );
      }
    }
  }

  Future<void> _showResetPasswordConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you want to reset your password?'),
                SizedBox(height: 10),
                Text('This action will:'),
                Text('• Delete your current password'),
                Text('• Delete all stored certificates'),
                Text('• Log you out of the application'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetPassword();
              },
            ),
          ],
        );
      },
    );
  }
}
