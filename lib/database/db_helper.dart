/*Database initialization & helper functions*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for POC/POD data
  CollectionReference get pocPodCollection => _firestore.collection('poc_pod');

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
      throw Exception("User not logged in");
    }

    try {
      await pocPodCollection.add({
        "user_id": user.uid,
        "delivery_type": deliveryType,
        "waybill_number": waybillNumber,
        "customer_name": customerName,
        "consignee_name": consigneeName,
        "location": location,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error saving data: $e');
    }
  }

  // Function to fetch all POC/POD data for a particular user
  Future<List<Map<String, dynamic>>> fetchData() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      QuerySnapshot querySnapshot = await pocPodCollection
          .where("user_id", isEqualTo: user.uid)
          .orderBy("timestamp", descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // Function to update POC/POD data (based on document ID)
  Future<void> updateData({
    required String docId,
    required String deliveryType,
    required String waybillNumber,
    required String customerName,
    required String consigneeName,
    required String location,
  }) async {
    try {
      await pocPodCollection.doc(docId).update({
        "delivery_type": deliveryType,
        "waybill_number": waybillNumber,
        "customer_name": customerName,
        "consignee_name": consigneeName,
        "location": location,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  // Function to delete POC/POD data (based on document ID)
  Future<void> deleteData(String docId) async {
    try {
      await pocPodCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }
}
