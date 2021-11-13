import 'package:json_annotation/json_annotation.dart';
part 'clinic_address_model.g.dart';

@JsonSerializable()
class ClinicAddress {
  String address;
  String? apartment;
  String city;
  String? pincode;
  @JsonKey(fromJson: coordinatesFromJson, name: "geometry")
  List<double> coordinates;

  ClinicAddress({required this.address, this.apartment, required this.coordinates, this.pincode, required this.city});

  factory ClinicAddress.fromJson(Map<String, dynamic> json) => _$ClinicAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicAddressToJson(this);
}

List<double> coordinatesFromJson(Map<String, dynamic> json) {
  print(json);
  return [json["coordinates"][0].toDouble(), json["coordinates"][1].toDouble()];
}
