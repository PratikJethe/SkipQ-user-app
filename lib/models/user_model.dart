import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/general_model/contact_model.dart';
import 'package:booktokenapp/models/general_model/uaer_address_model.dart';

class User {
  String id;
  String fullName;
  String authProvider;
  String fcm;
  Address? address;
  Enum gender;
  String? email;
  Contact contact;
  String? profilePicUrl;
  DateTime? dob;

  User({
    required this.id,
    required this.fullName,
    required this.authProvider,
    required this.fcm,
    this.address,
    required this.gender,
    required this.contact,
    this.email,
    this.profilePicUrl,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"].toString(),
        fullName: json["fullName"],
        authProvider: json["authProvider"],
        fcm: json["fcm"],
        address: json["address"] != null ? Address.fromJson(json["address"]) : null,
        gender: resolveGender(json["gender"]),
        email: json["email"],
        contact: Contact.fromJson(json["contact"]),
        profilePicUrl: json["profilePicUrl"],
        dob: json["dateOfBirth"] != null ? DateTime.parse(json["dateOfBirth"]) : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "authProvider": authProvider,
      "fcm": fcm,
      "address": address?.toJson(),
      "gender": resolveReverseGender(gender),
      "email": email,
      "contact": contact.toJson(),
      "profilePicUrl": profilePicUrl,
      "dateOfBirth": dob,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

resolveGender(String? gender) {
  if (gender == null) {
    return Gender.NONE;
  }
  if (gender == "MALE") {
    return Gender.MALE;
  }
  if (gender == "FEMALE") {
    return Gender.FEMALE;
  }
  if (gender == "OTHER") {
    return Gender.OTHER;
  }
}

resolveReverseGender(Enum gender) {
  if (gender == Gender.NONE) {
    return null;
  }
  if (gender ==  Gender.MALE) {
    return "MALE";
  }
  if (gender == Gender.FEMALE) {
    return "FEMALE";
  }
  if (gender == Gender.OTHER) {
    return "OTHER";
  }
}
