class Contact {
  int phoneNo;
  int dialCode;

  Contact({required this.dialCode, required this.phoneNo});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(phoneNo: json["phoneNo"], dialCode: json["dialCode"]);

  Map<String, dynamic> toJson() {
    return {
      "phoneNo": phoneNo,
      "dialCode": dialCode,
    };
  }
}
