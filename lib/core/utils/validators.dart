class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    return validateRequired(value, 'Location');
  }

  static String? validateCustomerName(String? value) {
    return validateRequired(value, 'Customer name');
  }
}
