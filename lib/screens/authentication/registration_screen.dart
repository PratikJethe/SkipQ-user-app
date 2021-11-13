import 'dart:ffi';

import 'package:booktokenapp/config/config.dart';
import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/service/firebase_services/fcm_service.dart';
import 'package:booktokenapp/service/firebase_services/firebase_service.dart';
import 'package:booktokenapp/utils/validators.dart';
import 'package:booktokenapp/widgets/custom_appbars.dart';
import 'package:booktokenapp/widgets/textfield_borders.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _apartemntController.dispose();
    _addressController.dispose();
    _dobController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backArrowAppbar(context),
      body: Consumer<UserProvider>(
        builder: (context, userprovider, _) => SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInputComponent(
                        'Name',
                        TextFormField(
                          maxLength: 20,
                          cursorColor: R.color.primary,
                          cursorHeight: 25,
                          controller: _fullNameController,
                          onChanged: (value) {
                            setState(() {
                              name = value.trim();
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              errorBorder: formErrorBorder,
                              focusedErrorBorder: formErrorBorder),
                          validator: validateName,
                        ),
                        true),
                    TextInputComponent(
                        'Contact',
                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: formBorder,
                            focusedBorder: formBorder,
                            disabledBorder: formBorder,
                            errorBorder: formErrorBorder,
                            focusedErrorBorder: formErrorBorder,
                            prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 40, maxHeight: 30),
                            prefixIcon: Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  border: Border(right: BorderSide(color: R.color.black)),
                                ),
                                child: Center(child: Text('+91'))),
                          ),
                          controller: _mobileNumberController,
                          enabled: false,
                        ),
                        true),
                    TextInputComponent(
                        'Email',
                        TextFormField(
                          maxLength: 20,
                          cursorColor: R.color.primary,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              errorBorder: formErrorBorder,
                              focusedErrorBorder: formErrorBorder),
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
                        'Address',
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              disabledBorder: formBorder,
                              errorBorder: formErrorBorder,
                              focusedErrorBorder: formErrorBorder),
                          enabled: false,
                          controller: _addressController,
                        ),
                        false,
                      ),
                    ), // auto filled or manual
                    TextInputComponent(
                      'Apartment',
                      TextFormField(
                        maxLength: 50,
                        cursorColor: R.color.primary,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            enabledBorder: formBorder,
                            focusedBorder: formBorder,
                            disabledBorder: formBorder,
                            errorBorder: formErrorBorder,
                            hintText: 'floor,wing,building,street..',
                            focusedErrorBorder: formErrorBorder),
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
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              disabledBorder: formBorder,
                              errorBorder: formErrorBorder,
                              focusedErrorBorder: formErrorBorder),
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
                    TextInputComponent(
                        'Pincode',
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'ex: 400012',
                              contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              disabledBorder: formBorder,
                              errorBorder: formErrorBorder,
                              focusedErrorBorder: formErrorBorder),
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
                        await _selectDate(context);
                      },
                      child: TextInputComponent(
                        'Date of birth',
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_today_sharp),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            enabledBorder: formBorder,
                            focusedBorder: formBorder,
                            disabledBorder: formBorder,
                            errorBorder: formErrorBorder,
                            focusedErrorBorder: formErrorBorder,
                            hintText: 'Select birth date',
                          ),
                          controller: _dobController,
                          enabled: false,
                          onChanged: (value) {},
                          validator: validateCity,
                        ),
                        false,
                      ),
                    ), // auto filled or manual

                    TextInputComponent(
                        'Gender',
                        FittedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                        fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
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
                                        fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
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
                                        fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
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
                                        fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
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
                        ),
                        false),
                    // TextInputComponent('Date of Birth', TextFormField(), true),
                    TextButton(
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
                            "coordinates": coordinates.length < 2 ? null : coordinates,
                          };
                          print(payload);
                          payload.removeWhere((key, value) => value == null || value == '');
                          await userprovider.register(payload, context);
                        }
                      },
                      child: Card(
                        child: Container(
                            width: 160,
                            height: 40,
                            color: R.color.primaryL1,
                            child: Center(
                                child: Text(
                              'Register',
                              style: R.styles.fz16Fw500.merge(TextStyle(color: Colors.white)),
                            ))),
                      ),
                    )
                  ],
                ),
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
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.fieldName,
                style: R.styles.fz16Fw500,
              ),
              SizedBox(width: 5),
              widget.isRequired ? Text('(required)') : Text('(optional)')
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(child: widget.textFormField)
        ],
      ),
    );
  }
}
