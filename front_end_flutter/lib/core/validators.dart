
/// Form validation utilities for the application
class Validators {
  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }


    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );


    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }


    return null;
  }


  /// Validates password (minimum 6 characters)
  /// Returns error message if invalid, null if valid
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }


    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }


    return null;
  }


  /// Validates name field (not empty)
  /// Returns error message if invalid, null if valid
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }


    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }


    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Konfirmasi password tidak boleh kosong';
  }
  if (password != confirmPassword) {
    return 'Konfirmasi password tidak cocok';
  }
  return null;
}
}


