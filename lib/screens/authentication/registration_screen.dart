import 'dart:ffi';

import 'package:booktokenapp/config/config.dart';
import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/service/firebase_services/fcm_service.dart';
import 'package:booktokenapp/service/firebase_services/firebase_service.dart';
import 'package:booktokenapp/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Config.autocompleteApiKey);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.uid, required this.mobileNumber}) : super(key: key);

  final String uid;
  final int mobileNumber;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _apartemntController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  late String uid;
  late int mobileNumber;
  String? name, email, address, apartment, pinocde, dob, gender = '', city;
  List<String> genderList = ['MALE', 'FEMALE', 'OTHER', ''];
  List<double> coordinates = [];
  FcmService _fcmService = getIt.get<FcmService>();
  DateTime? selectedDate;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 10, 12, 31),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(DateTime.now().year - 10, 12, 31));

    if (picked == null) {
      print('picked');
      print(dob);
      selectedDate = null;
      _dobController.clear();
      dob = null;
    } else {
      dob = picked.toIso8601String();
      selectedDate = picked;
      _dobController.text = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    mobileNumber = widget.mobileNumber;
    _mobileNumberController.text = mobileNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userprovider, _) => SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInputComponent(
                      'Full Name',
                      TextFormField(
                        controller: _fullNameController,
                        onChanged: (value) {
                          setState(() {
                            name = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        validator: validateName,
                      ),
                      true),
                  TextInputComponent(
                      'Mobile Number',
                      TextFormField(
                        controller: _mobileNumberController,
                        enabled: false,
                      ),
                      true),
                  TextInputComponent(
                      'Email',
                      TextFormField(
                        controller: _emailController,
                        onChanged: (value) {
                          setState(() {
                            email = value.trim();
                          });
                        },
                        validator: validateEmail,
                      ),
                      false),
                  // TextInputComponent('Full name', TextFormField(), true),  reserverd for address via google api

                  TextInputComponent(
                      'Pincode',
                      TextFormField(
                        controller: _pincodeController,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            pinocde = value.trim();
                          });
                        },
                        validator: validatePincode,
                      ),
                      false), // auto filled or manual
                  GestureDetector(
                    onTap: () async {
                      onError(res) {
                        print(res);
                        Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                      }

                      Prediction? prediction = await PlacesAutocomplete.show(
                        context: context,
                        mode: Mode.overlay,
                        apiKey: Config.autocompleteApiKey,
                        components: [],
                        types: [],
                        onError: onError,
                        strictbounds: false,
                        hint: "Search address",
                      );

                      if (prediction == null) {
                        address = null;
                        _addressController.clear();
                        coordinates = [];
                        setState(() {});
                        return;
                      }

                      print(prediction.description);
                      _addressController.text = prediction.description!;
                      address = prediction.description!;

                      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId!);
                      final lat = detail.result.geometry?.location.lat;
                      final lng = detail.result.geometry?.location.lng;

                      if (lat != null && lng != null) {
                        coordinates = [lng, lat];
                        print(coordinates);
                      }
                    },
                    child: TextInputComponent(
                      'address',
                      TextFormField(
                        enabled: false,
                        controller: _addressController,
                      ),
                      false,
                    ),
                  ), // auto filled or manual
                  TextInputComponent(
                    'Apartment',
                    TextFormField(
                      controller: _apartemntController,
                      onChanged: (value) {
                        setState(() {
                          apartment = value.trim();
                        });
                      },
                      validator: validateApartment,
                    ),
                    false,
                  ), // auto filled or manual
                  GestureDetector(
                    onTap: () async {
                      onError(res) {
                        print(res);
                        Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                      }

                      Prediction? prediction = await PlacesAutocomplete.show(
                        context: context,
                        mode: Mode.overlay,
                        apiKey: Config.autocompleteApiKey,
                        // sessionToken: sessionToken,
                        components: [],
                        types: ['(cities)'],
                        onError: onError,
                        strictbounds: false,
                        hint: "Search City",
                      );

                      if (prediction == null) {
                        city = null;
                        _cityController.clear();
                        setState(() {});
                        return;
                      }

                      if (prediction.description != null) {
                        city = prediction.description!.split(',')[0].trim();
                        _cityController.text = city!;
                      }
                    },
                    child: TextInputComponent(
                      'City',
                      TextFormField(
                        enabled: false,
                        controller: _cityController,
                        onChanged: (value) {
                          setState(() {
                            city = value.trim();
                          });
                        },
                        validator: validateCity,
                      ),
                      false,
                    ),
                  ), // auto filled or manual
                  GestureDetector(
                    onTap: () async {
                      await _selectDate(context);
                    },
                    child: TextInputComponent(
                      'Date of birth',
                      TextFormField(
                        controller: _dobController,
                        enabled: false,
                        decoration: InputDecoration(hintText: 'Select birth date'),
                        onChanged: (value) {},
                        validator: validateCity,
                      ),
                      false,
                    ),
                  ), // auto filled or manual

                  TextInputComponent(
                      'Gender',
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 'MALE',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      print(value);
                                      gender = value.toString();
                                      setState(() {});
                                    }),
                                Text('Male')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 'FEMALE',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {});
                                      gender = value.toString();
                                    }),
                                Text('Female')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 'OTHER',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      gender = value.toString();
                                      setState(() {});
                                      print(value);
                                    }),
                                Text('Other')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: '',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      gender = '';
                                      setState(() {});
                                    }),
                                Text('None')
                              ],
                            ),
                          ],
                        ),
                      ),
                      true),
                  // TextInputComponent('Date of Birth', TextFormField(), true),
                  MaterialButton(
                    onPressed: () async {
                      print({
                        "name": name?.trim(),
                        "email": email == null || email!.isEmpty ? null : email,
                        "mobileNumber": mobileNumber,
                        "pincode": pinocde,
                        "apartment": apartment,
                        "gender": gender!.isEmpty ? null : gender,
                        "city": city,
                        "dateOfBrth": dob,
                        "fcm": '',
                        "uid": uid,
                        "address": address,
                        "coordinates": coordinates,
                      });
                      if (_formKey.currentState!.validate()) {
                        String? token = await _fcmService.refreshToken();

                        if (token == null) {
                          Fluttertoast.showToast(msg: "something went wrong. try again", gravity: ToastGravity.BOTTOM);

                          return;
                        }

                        print({
                          "fullName": name?.trim(),
                          "email": email == null || email!.isEmpty ? null : email,
                          "phoneNo": mobileNumber,
                          "pincode": pinocde == null || pinocde!.isEmpty ? null : pinocde,
                          "address": address == null || address!.isEmpty ? null : address,
                          "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                          "gender": gender == "" ? null : gender,
                          "city": city == null || city!.isEmpty ? null : city,
                          "dateOfBirth": dob,
                          "fcm": token,
                          "uid": uid,
                          "coordinates": coordinates.length < 2 ? null : coordinates,
                        });

                        print(coordinates.length);
                        Map<String, dynamic> payload = {
                          "fullName": name?.trim(),
                          "email": email == null || email!.isEmpty ? null : email,
                          "phoneNo": mobileNumber,
                          "pincode": pinocde == null || pinocde!.isEmpty ? null : pinocde,
                          "address": address == null || address!.isEmpty ? null : address,
                          "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                          "gender": gender == "" ? null : gender,
                          "city": city == null || city!.isEmpty ? null : city,
                          "dateOfBirth": dob,
                          "fcm": token,
                          "uid": uid,
                          "coordinates":  coordinates.length < 2 ? null : coordinates,
                        };
                        print(payload);
                        payload.removeWhere((key, value) => value == null || value == '');
                        await userprovider.register(payload, context);
                      }
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextInputComponent extends StatefulWidget {
  final String fieldName;
  final Widget textFormField;
  final bool isRequired;

  TextInputComponent(this.fieldName, this.textFormField, this.isRequired);

  @override
  _TextInputComponentState createState() => _TextInputComponentState();
}

class _TextInputComponentState extends State<TextInputComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(widget.fieldName), widget.textFormField],
      ),
    );
  }
}
