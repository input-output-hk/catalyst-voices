import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'secure_certificate_repository.dart';

class ProtectedScreen extends StatefulWidget {
  const ProtectedScreen({super.key});

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  final _certificateRepo = SecureCertificateRepository();
  List<String> _certificates = [];
  bool _isLoading = true;

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
            onPressed: _resetPassword,
            tooltip: 'Reset Password',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteCertificate(
                                  _certificates[index],
                                ),
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
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _deleteCertificate(String certificateName) async {
    await _certificateRepo.deleteCertificate(certificateName);
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    setState(() {
      _isLoading = true;
    });
    final certificates = await _certificateRepo.getStoredCertificateNames();
    setState(() {
      _certificates = certificates;
      print('Loaded certificates: $_certificates');
      _isLoading = false;
    });
  }

  Future<void> _pickAndStoreCertificates() async {
    final storedCertificates =
        await _certificateRepo.pickAndStoreCertificates();
    if (storedCertificates.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${storedCertificates.length} certificate(s) stored'),
        ),
      );
      _loadCertificates();
    }
  }

  Future<void> _resetPassword() async {
    await _certificateRepo.deletePassword();
    if (mounted) {
      context.go('/');
    }
  }
}
