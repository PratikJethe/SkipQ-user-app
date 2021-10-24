String? validateMobile(String? value) {
  if (value == null) {
    return 'Enter phone number';
  }
  if (value.trim().isEmpty) {
    return 'Enter phone number';
  }
  if (value.trim().length != 10) {
    return 'Enter valid 10 digit number';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }

  if (!RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value.toLowerCase())) {
    return 'Please enter a valid email (optional)';
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }
  if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
    return 'Please enter a valid 6-digit pincode (optional)';
  }
  return null;
}

String? validateApartment(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }
  return null;
}

String? validateCity(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }
  return null;
}
