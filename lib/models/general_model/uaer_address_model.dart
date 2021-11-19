class Address {
  String? address;
  String? apartment;
  String? pincode;
  String? city;
  List<double>? coordinates;

  Address({this.address, this.apartment, this.coordinates, this.pincode, this.city});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      address: json["address"],
      apartment: json["apartment"],
      pincode: json["pincode"],
      city: json["city"],
      coordinates: json["geometry"] != null ? [json["geometry"]["coordinates"][0].toDouble(), json["geometry"]["coordinates"][1].toDouble()] : null);

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "pincode": pincode,
      "apartment": apartment,
      "coordinates": coordinates,
      "city": city,
    };
  }
}
