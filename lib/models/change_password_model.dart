class ChangePasswordModel {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  bool isValid() {
    return newPassword.length >= 6 && newPassword == confirmPassword;
  }

  String? validationError() {
    if (newPassword.length < 6) {
      return "New password must be at least 6 characters.";
    }
    if (newPassword != confirmPassword) {
      return "New password and confirm password do not match.";
    }
    return null;
  }
}
