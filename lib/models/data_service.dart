import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'email_service.dart';
import 'sms_service.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmailService _emailService = EmailService();
  final SmsService _smsService = SmsService();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'pending_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE pending_data (id INTEGER PRIMARY KEY AUTOINCREMENT, deliveryType TEXT, waybillNumber TEXT, customerName TEXT, consigneeName TEXT, location TEXT, phoneNumber TEXT, driverEmail TEXT, isSynced INTEGER)');
      },
    );
  }

  Future<void> submitData(
    String deliveryType,
    String waybillNumber,
    String customerName,
    String consigneeName,
    String location,
    String phoneNumber,
    String driverEmail,
    bool isOnline,
  ) async {
    if (isOnline) {
      try {
        await _firestore.collection('poc_pod').add({
          'deliveryType': deliveryType,
          'waybillNumber': waybillNumber,
          'customerName': customerName,
          'consigneeName': consigneeName,
          'location': location,
          'phoneNumber': phoneNumber,
          'driverEmail': driverEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        await _saveDataLocally({
          'deliveryType': deliveryType,
          'waybillNumber': waybillNumber,
          'customerName': customerName,
          'consigneeName': consigneeName,
          'location': location,
          'phoneNumber': phoneNumber,
          'driverEmail': driverEmail,
          'isSynced': 0,
        });
        print('Data saved locally due to error: $e');
        throw Exception('Failed to submit data: $e');
      }
    } else {
      await _saveDataLocally({
        'deliveryType': deliveryType,
        'waybillNumber': waybillNumber,
        'customerName': customerName,
        'consigneeName': consigneeName,
        'location': location,
        'phoneNumber': phoneNumber,
        'driverEmail': driverEmail,
        'isSynced': 0,
      });
      print('Data saved locally while offline');
    }
  }

  Future<void> _saveDataLocally(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('pending_data', data);
    print(
        'Local storage: Data inserted for waybillNumber: ${data['waybillNumber']}');
  }

  Future<List<Map<String, dynamic>>> getPendingData() async {
    final db = await database;
    return await db
        .query('pending_data', where: 'isSynced = ?', whereArgs: [0]);
  }

  Future<void> syncPendingData() async {
    final db = await database;
    List<Map<String, dynamic>> pendingData = await getPendingData();

    for (var data in pendingData) {
      try {
        await _firestore.collection('poc_pod').add({
          'deliveryType': data['deliveryType'],
          'waybillNumber': data['waybillNumber'],
          'customerName': data['customerName'],
          'consigneeName': data['consigneeName'],
          'location': data['location'],
          'phoneNumber': data['phoneNumber'],
          'driverEmail': data['driverEmail'],
          'timestamp': FieldValue.serverTimestamp(),
        });
        await db.update('pending_data', {'isSynced': 1},
            where: 'id = ?', whereArgs: [data['id']]);
        print('Data synced for waybillNumber: ${data['waybillNumber']}');
      } catch (e) {
        print(
            'Failed to sync data for waybillNumber: ${data['waybillNumber']}, Error: $e');
        continue;
      }
    }
  }

  // Method to retrieve all waybill numbers from the local database
  Future<List<String>> getAllWaybillNumbers() async {
    final db = await database;
    final result = await db.query('pending_data', columns: ['waybillNumber']);
    return result.map((e) => e['waybillNumber'] as String).toList();
  }
}
