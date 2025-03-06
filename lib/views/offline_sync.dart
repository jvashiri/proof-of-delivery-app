import 'package:flutter/material.dart';
import 'package:driver_app/models/data_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final DataService _dataService = DataService();
  List<Map<String, dynamic>> pendingData = [];

  @override
  void initState() {
    super.initState();
    _loadPendingData();
  }

  Future<void> _loadPendingData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pending_data.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      setState(() {
        pendingData = List<Map<String, dynamic>>.from(json.decode(content));
      });
    }
  }

  Future<void> _syncData(Map<String, dynamic> data) async {
    bool isConnected = await _isConnected();
    if (isConnected) {
      try {
        await _dataService.submitData(
          data['deliveryType'],
          data['waybillNumber'],
          data['customerName'],
          data['consigneeName'],
          data['location'],
          data['phoneNumber'],
          data['driverEmail'],
          //data['imageUrl'],
          true, // isOnline
        );
        await _updateSyncStatus(data['id'], true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("POC/POD Synced Successfully")),
        );
        _loadPendingData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error syncing data: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No internet connection")),
      );
    }
  }

  Future<void> _syncAllData() async {
    bool isConnected = await _isConnected();
    if (isConnected) {
      for (var data in pendingData) {
        await _syncData(data);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No internet connection")),
      );
    }
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _updateSyncStatus(String id, bool isSynced) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pending_data.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      List<Map<String, dynamic>> pendingData = List<Map<String, dynamic>>.from(json.decode(content));

      for (var data in pendingData) {
        if (data['id'] == id) {
          data['isSynced'] = isSynced;
          break;
        }
      }

      await file.writeAsString(json.encode(pendingData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncAllData,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pendingData.length,
        itemBuilder: (context, index) {
          var data = pendingData[index];
          return Card(
            child: ListTile(
              title: Text(data['waybillNumber']),
              subtitle: Text(data['customerName']),
              trailing: IconButton(
                icon: Icon(Icons.sync),
                onPressed: () => _syncData(data),
              ),
            ),
          );
        },
      ),
    );
  }
}
