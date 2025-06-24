import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pod_model.dart';

class SyncScreenController {
  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'poc_pod.db'), version: 1);
  }

  Future<List<PodModel>> getPendingPods() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> result = await db.query('poc_pod');
    return result.map((e) => PodModel.fromMap(e)).toList();
  }

  Future<void> deletePod(int id) async {
    final db = await _getDatabase();
    await db.delete('poc_pod', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isConnected() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  Future<void> syncPod(PodModel pod) async {
    await FirebaseFirestore.instance.collection('poc_pod').add(pod.toFirestore());
    await deletePod(pod.id);
  }
}
