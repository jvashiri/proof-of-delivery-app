import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'email_service.dart';
import 'sms_service.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final EmailService _emailService = EmailService();
  // ignore: unused_field
  final SmsService _smsService = SmsService();

  Future<void> submitData(
    String deliveryType,
    String waybillNumber,
    String customerName,
    String consigneeName,
    String location,
    String phoneNumber,
    String driverEmail,
    //String imageUrl,
    bool isOnline,
  ) async {
    if (isOnline) {
      try {
        // Submit data to Firestore
        await _firestore.collection('poc_pod').add({
          'deliveryType': deliveryType,
          'waybillNumber': waybillNumber,
          'customerName': customerName,
          'consigneeName': consigneeName,
          'location': location,
          'phoneNumber': phoneNumber,
          'driverEmail': driverEmail,
          //'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

       /* // After successful submission, send notifications
        await _emailService.sendEmailNotification(
            driverEmail, waybillNumber, imageUrl);
        await _smsService.sendSmsNotification(
            phoneNumber, waybillNumber, imageUrl);*/
      } catch (e) {
        // If an error occurs, save data locally for later submission
        await _saveDataLocally({
          'deliveryType': deliveryType,
          'waybillNumber': waybillNumber,
          'customerName': customerName,
          'consigneeName': consigneeName,
          'location': location,
          'phoneNumber': phoneNumber,
          'driverEmail': driverEmail,
          //'imageUrl': imageUrl,
          'isSynced': false,
        });
        throw Exception('Failed to submit data: $e');
      }
    } else {
      // Save data locally for later submission
      await _saveDataLocally({
        'deliveryType': deliveryType,
        'waybillNumber': waybillNumber,
        'customerName': customerName,
        'consigneeName': consigneeName,
        'location': location,
        'phoneNumber': phoneNumber,
        'driverEmail': driverEmail,
        //'imageUrl': imageUrl,
        'isSynced': false,
      });
    }
  }

  Future<void> _saveDataLocally(Map<String, dynamic> data) async {
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
}
