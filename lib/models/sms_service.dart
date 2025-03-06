import 'package:http/http.dart' as http;

class SmsService {
  Future<void> sendSmsNotification(String phoneNumber, String waybillNumber, String imageUrl) async {
    // Replace with your SMS sending logic
    final response = await http.post(
      Uri.parse('https://your-sms-service.com/send'),
      body: {
        'to': phoneNumber,
        'message': 'Your POD/POC with waybill number $waybillNumber has been successfully submitted. You can view the image here: $imageUrl',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send SMS notification');
    }
  }
}
