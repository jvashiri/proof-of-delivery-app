import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendEmailNotification(String driverEmail, String waybillNumber, String imageUrl) async {
    // Replace with your email sending logic
    final response = await http.post(
      Uri.parse('https://your-email-service.com/send'),
      body: {
        'to': driverEmail,
        'subject': 'POD/POC Submission Successful',
        'body': 'Your POD/POC with waybill number $waybillNumber has been successfully submitted. You can view the image here: $imageUrl',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email notification');
    }
  }
}
