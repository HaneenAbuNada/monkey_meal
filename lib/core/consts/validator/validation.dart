class ValidationUtils {
  static final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

  static final RegExp _phoneRegExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

  static final RegExp _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates a phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!_phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates an address
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  /// Validates a date of birth (must be at least 13 years old)
  static String? validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age =
        now.year - date.year - (now.month > date.month || (now.month == date.month && now.day >= date.day) ? 0 : 1);

    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }

  /// Validates a generic required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a numeric value
  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return fieldName != null ? 'Enter a valid $fieldName' : 'Enter a valid number';
    }
    return null;
  }

  /// Validates a positive numeric value
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numericError = validateNumeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    if (double.parse(value!) <= 0) {
      return fieldName != null ? '$fieldName must be positive' : 'Value must be positive';
    }
    return null;
  }
}
