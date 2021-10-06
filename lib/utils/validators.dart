 validateMobile(String? value) {
  if (value == null) {
    return 'Enter phone number';
  }
  if (value.isEmpty) {
    return 'Enter phone number';
  }
  if (value.length != 10) {
    return 'Enter valid 10 digit number';
  }
  return null;
}
