//Data Access Object (CRUD operations)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pod_model.dart';

class PocPodDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SQLite database setup
  Future<Database> _getDatabase() async {
    final databasePath = await getDatabasesPath();
    return openDatabase(
      join(databasePath, 'pod_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE pod_table(waybillNumber TEXT PRIMARY KEY, customerName TEXT, consigneeName TEXT, location TEXT, imagePath TEXT)",
        );
      },
      version: 1,
    );
  }

  // Function to submit POC/POD data to Firestore
  Future<void> submitData({
    required String deliveryType,
    required String waybillNumber,
    required String customerName,
    required String consigneeName,
    required String location,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in.");
    }

    try {
      await _firestore.collection("poc_pod").add({
        "user_id": user.uid,
        "delivery_type": deliveryType,
        "waybill_number": waybillNumber,
        "customer_name": customerName,
        "consignee_name": consigneeName,
        "location": location,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error saving data to Firestore: ${e.toString()}');
    }
  }

  // Function to save POC/POD data locally (for offline)
  Future<void> saveToLocalOffline(PodModel pod) async {
    final db = await _getDatabase();
    await db.insert(
      'pod_table',
      pod.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to get all offline PODs
  Future<List<PodModel>> getAllOfflinePODs() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('pod_table');

    return List.generate(maps.length, (i) {
      return PodModel.fromMap(maps[i]);
    });
  }

  // Function to delete an offline POD after successful sync
  Future<void> deleteOfflinePOD(String waybillNumber) async {
    final db = await _getDatabase();
    await db.delete(
      'pod_table',
      where: 'waybillNumber = ?',
      whereArgs: [waybillNumber],
    );
  }

  // Function to sync offline POD data to Firestore when online
  Future<void> syncOfflineData() async {
    // Check for connectivity and sync data when online
    bool isOnline = await _checkInternetConnection();

    if (isOnline) {
      // Fetch locally saved PODs
      List<PodModel> offlinePods = await getAllOfflinePODs();

      // Try submitting each POD to Firestore
      for (var pod in offlinePods) {
        try {
          await submitData(
            deliveryType: pod.deliveryType,
            waybillNumber: pod.waybillNumber,
            customerName: pod.customerName,
            consigneeName: pod.consigneeName,
            location: pod.location,
          );
          await deleteOfflinePOD(pod.waybillNumber);  // Remove from local DB if successful
        } catch (e) {
          print('Failed to sync POD with Firestore: ${e.toString()}');
        }
      }
    }
  }

  // Check for internet connectivity
  Future<bool> _checkInternetConnection() async {
    // Here you could use any connectivity plugin to check for connectivity status
    // For example: Connectivity().checkConnectivity()
    // Return true if connected to the internet
    return true;  // Assuming it's online, update this check as needed
  }
}
