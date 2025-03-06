import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isSyncing = false;
  String _syncStatus = 'Not Synced';

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing...';
    });

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _syncStatus = 'No internet connection. Please try again later.';
        _isSyncing = false;
      });
      return;
    }

    // Implement your sync logic here
    // For example, upload local files to Firebase Storage
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    for (var file in files) {
      if (file is File) {
        final storageRef = FirebaseStorage.instance.ref().child('poc_pod/${file.path.split('/').last}');
        await storageRef.putFile(file);
        // Optionally, delete the local file after successful upload
        await file.delete();
      }
    }

    setState(() {
      _syncStatus = 'Sync completed successfully';
      _isSyncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Sync Data')),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_syncStatus),
            SizedBox(height: 20),
            _isSyncing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _syncData,
                    child: Text('Sync Now'),
                  ),
          ],
        ),
      ),
    );
  }
}
