
class User {
  String? id;
  String? fullName;
  String? authProvider;
  String? fcm;
  String? address;
  String? gender;
  String? email;
  String? apartment;
  int? phoneNo;
  String? profilePicUrl;
  List<double>? coordinates;
  DateTime? dob;

  User({
    this.id,
    this.fullName,
    this.authProvider,
    this.fcm,
    this.address,
    this.gender,
    this.email,
    this.apartment,
    this.phoneNo,
    this.profilePicUrl,
    this.coordinates,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        fullName: json["fullName"],
        authProvider: json["authProvider"],
        fcm: json["fcm"],
        address: json["address"],
        gender: json["gender"],
        email: json["email"],
        apartment: json["apartment"],
        phoneNo: json["phoneNo"],
        profilePicUrl: json["profilePicUrl"],
        coordinates: json["coordinates"],
        dob: json["dateOfBirth"] != null ? DateTime.parse(json["dateOfBirth"]) : null,
      );

      
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "authProvider": authProvider,
      "fcm": fcm,
      "address": address,
      "gender": gender,
      "email": email,
      "apartment": apartment,
      "phoneNo": phoneNo,
      "profilePicUrl": profilePicUrl,
      "coordinates": coordinates,
      "dateOfBirth": dob,
    };
  }
}
