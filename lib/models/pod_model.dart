import 'package:cloud_firestore/cloud_firestore.dart';

class PodModel {
  final int id;
  final String deliveryType;
  final String waybill;
  final String customer;
  final String consignee;
  final String location;
  final String phoneNumber;
  final String driverEmail;

  PodModel({
    required this.id,
    required this.deliveryType,
    required this.waybill,
    required this.customer,
    required this.consignee,
    required this.location,
    required this.phoneNumber,
    required this.driverEmail,
  });

  factory PodModel.fromMap(Map<String, dynamic> map) {
    return PodModel(
      id: map['id'],
      deliveryType: map['deliveryType'] ?? '',
      waybill: map['waybill'] ?? '',
      customer: map['customer'] ?? '',
      consignee: map['consignee'] ?? '',
      location: map['location'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      driverEmail: map['driverEmail'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'deliveryType': deliveryType,
      'waybill': waybill,
      'customer': customer,
      'consignee': consignee,
      'location': location,
      'phoneNumber': phoneNumber,
      'driverEmail': driverEmail,
      'isOnline': true,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
