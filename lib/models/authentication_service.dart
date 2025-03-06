import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  Future<String?> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}
void checkCurrentUser() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("User is logged in. User ID: ${user.uid}");
  } else {
    print("No user is logged in.");
  }
}
