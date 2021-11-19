import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/general_model/contact_model.dart';
import 'package:booktokenapp/models/general_model/uaer_address_model.dart';
import 'package:booktokenapp/utils/date_converter.dart';
import 'package:booktokenapp/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id;
  String fullName;
  String authProvider;
  String fcm;
  Address? address;
  Gender? gender;
  String? email;
  Contact contact;
  String? profilePicUrl;

  @JsonKey(name: 'dateOfBirth', fromJson: utcToLocalOptional)
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
