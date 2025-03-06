import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:driver_app/models/data_service.dart';  // Ensure DataService is properly imported

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  List<Map<String, String>> _waybills = [];

  @override
  void initState() {
    super.initState();
    _loadWaybills();
  }

  // Load waybill numbers from both the SQLite database and local files
  Future<void> _loadWaybills() async {
    List<Map<String, String>> waybills = [];

    // Load waybill numbers from the local database
    DataService dataService = DataService();
    List<String> waybillNumbersFromDb = await dataService.getAllWaybillNumbers();
    for (var waybillNumber in waybillNumbersFromDb) {
      waybills.add({'source': 'Database', 'waybillNumber': waybillNumber});
    }

    // Load waybill numbers from local files
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    for (var file in files.whereType<File>()) {
      String content = await file.readAsString();
      String waybillNumber = _extractWaybillNumber(content);
      waybills.add({'source': 'File', 'waybillNumber': waybillNumber});
    }

    setState(() {
      _waybills = waybills;
    });
  }

  // Extract the waybill number from the file content
  String _extractWaybillNumber(String content) {
    // Assuming the waybill number is present in the content as "waybillNumber: <number>"
    RegExp regex = RegExp(r'waybillNumber:\s*(\S+)');
    var match = regex.firstMatch(content);
    return match != null ? match.group(1) ?? '' : 'Unknown';
  }

  // Simulate syncing the waybill
  void _syncWaybill(String waybillNumber) {
    // Implement the syncing logic here
    print('Syncing waybill $waybillNumber...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Waybills')),
      body: _waybills.isEmpty
          ? Center(child: Text('No local waybills found'))
          : ListView.builder(
              itemCount: _waybills.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Waybill Number: ${_waybills[index]['waybillNumber']}'),
                  subtitle: Text('Source: ${_waybills[index]['source']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.sync),
                    onPressed: () => _syncWaybill(_waybills[index]['waybillNumber']!),
                  ),
                );
              },
            ),
    );
  }
}
