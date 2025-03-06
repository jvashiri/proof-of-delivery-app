import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'i_local_storage_service.dart';

class LocalStorageService implements ILocalStorageService {
  @override
  Future<void> saveDataLocally(Map<String, dynamic> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pending_data.json');
    List<Map<String, dynamic>> pendingData = [];

    if (await file.exists()) {
      String content = await file.readAsString();
      pendingData = List<Map<String, dynamic>>.from(json.decode(content));
    }

    pendingData.add(data);
    await file.writeAsString(json.encode(pendingData));
  }

  updateSyncStatus(data, bool bool) {}

  getPendingSyncData() {}
}
