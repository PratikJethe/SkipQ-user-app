import 'dart:ffi';

import 'package:booktokenapp/config/app_config.dart';
import 'package:booktokenapp/constants/cities_list.dart';
import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/user_model.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/modal-screen/modal_loading_screen.dart';
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

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.autocompleteApiKey);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, this.uid, this.mobileNumber, this.isUpdateProfile, this.userProvider}) : super(key: key);

  final String? uid;
  final int? mobileNumber;
  final bool? isUpdateProfile;
  final UserProvider? userProvider;

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
  TextStyle errorTextStyle = R.styles.fz14.merge(TextStyle(color: Colors.red.shade700));

  String? uid;
  int? mobileNumber;
  bool? isUpdateProfile;
  UserProvider? userProvider2;
  late User user;
  String? name, email, address, apartment, pincode, dob, gender = '', city;
  List<String> genderList = ['MALE', 'FEMALE', 'OTHER', ''];
  List<double> coordinates = [];
  FcmService _fcmService = getIt.get<FcmService>();
  DateTime? selectedDate;
  DateTime initialDate = DateTime(DateTime.now().year - 10, 12, 31);

  String selectedCityFilterList = '';

  List filteredCities = [];

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: initialDate, firstDate: DateTime(1900, 1), lastDate: DateTime(DateTime.now().year - 10, 12, 31));

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

  _updateUi() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
    isUpdateProfile = widget.isUpdateProfile;
    userProvider2 = widget.userProvider;
    mobileNumber = widget.mobileNumber;
    if (isUpdateProfile == true) {
      assert(userProvider2 != null, 'userProvider cant be null if isUpdateProfile is true');
    } else {
      assert(uid != null && mobileNumber != null, 'uid and mobileNumber is required if isUpdateProfile is not true');
    }

    if (isUpdateProfile == true) {
      user = userProvider2!.user;

      name = user.fullName;
      address = user.address?.address;
      apartment = user.address?.apartment;
      city = user.address?.city;
      mobileNumber = user.contact.phoneNo;
      pincode = user.address?.pincode;
      _fullNameController.text = name!;
      _addressController.text = address ?? '';
      _apartemntController.text = apartment ?? '';
      _cityController.text = city ?? '';
      _mobileNumberController.text = mobileNumber.toString();
      _pincodeController.text = pincode ?? '';
      if (user.dob != null) {
        initialDate = user.dob!;
        selectedDate = user.dob!;
        dob = selectedDate?.toIso8601String();
        _dobController.text = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      }

      if (user.gender != null) {
        gender = user.gender.toString().split('.').last;
      }
      if (user.address?.coordinates != null) {
        coordinates = user.address!.coordinates!;
      }
    }

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
    return ModalLoadingScreen(
      child: Scaffold(
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
                            maxLength: 30,
                            cursorColor: R.color.primary,
                            cursorHeight: 25,
                            controller: _fullNameController,
                            onChanged: (value) {
                              setState(() {
                                name = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                              errorStyle:errorTextStyle,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                enabledBorder: formBorder,
                                focusedBorder: formBorder,
                                errorBorder: formErrorBorder,
                                focusedErrorBorder: formErrorBorder),
                            validator: validateName,
                          ),
                          true),
                      if (isUpdateProfile != true)
                        TextInputComponent(
                            'Contact',
                            TextFormField(
                              decoration: InputDecoration(
                                errorStyle:errorTextStyle,
                                enabledBorder: formBorder,
                                focusedBorder: formBorder,
                                disabledBorder: formBorder,
                                errorBorder: formErrorBorder,
                                focusedErrorBorder: formErrorBorder,
                             prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 50, maxHeight: 30),
                            prefixIcon: Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  border: Border(right: BorderSide(color: R.color.black)),
                                ),
                                child: Center(
                                    child: Text(
                                  '+91',
                                  style: R.styles.fz16Fw500,
                                ))),
                              ),
                              controller: _mobileNumberController,
                              enabled: false,
                            ),
                            true),
                      if (isUpdateProfile != true)
                        TextInputComponent(
                            'Email',
                            TextFormField(
                              maxLength: 40,
                              cursorColor: R.color.primary,
                              cursorHeight: 25,
                              decoration: InputDecoration(
                                errorStyle:errorTextStyle,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                          FocusScope.of(context).requestFocus(FocusNode());

                          onError(res) {
                            print(res);
                            Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                          }

                          Prediction? prediction = await PlacesAutocomplete.show(
                            context: context,
                            mode: Mode.overlay,
                            apiKey: AppConfig.autocompleteApiKey,
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
                              errorStyle:errorTextStyle,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                            errorStyle:errorTextStyle,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                        // onTap: () async {
                        //   print('pressed');
                        //   await _showBottomSheet();
                        //   _updateUi();
                        // },

                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());

                          onError(res) {
                            print(res);
                            Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                          }

                          Prediction? prediction = await PlacesAutocomplete.show(
                            context: context,
                            mode: Mode.overlay,
                            apiKey: AppConfig.autocompleteApiKey,
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
                              errorStyle:errorTextStyle,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                              errorStyle:errorTextStyle,
                                hintText: 'ex: 400012',
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                enabledBorder: formBorder,
                                focusedBorder: formBorder,
                                disabledBorder: formBorder,
                                errorBorder: formErrorBorder,
                                focusedErrorBorder: formErrorBorder),
                            controller: _pincodeController,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              setState(() {
                                pincode = value.trim();
                              });
                            },
                            validator: validatePincode,
                          ),
                          false), // auto filled or manual
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());

                          await _selectDate(context);
                        },
                        child: TextInputComponent(
                          'Date of birth',
                          TextFormField(
                            decoration: InputDecoration(
                              errorStyle:errorTextStyle,
                              suffixIcon: Icon(Icons.calendar_today_sharp),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                            "pincode": pincode,
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
                            if (isUpdateProfile == true) {
                              print({
                                "fullName": name?.trim(),
                                "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
                                "address": address == null || address!.isEmpty ? null : address,
                                "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                                "gender": gender == "" ? null : gender,
                                "city": city == null || city!.isEmpty ? null : city,
                                "dateOfBirth": dob,
                                "coordinates": coordinates.length < 2 ? null : coordinates,
                              });

                              print(coordinates.length);
                              Map<String, dynamic> payload = {
                                "fullName": name?.trim(),
                                "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
                                "address": address == null || address!.isEmpty ? null : address,
                                "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                                "gender": gender == "" ? null : gender,
                                "city": city == null || city!.isEmpty ? null : city,
                                "dateOfBirth": dob,
                                "coordinates": coordinates.length < 2 ? null : coordinates,
                                "profilePicUrl": user.profilePicUrl
                              };
                              print(payload);

                              payload.removeWhere((key, value) => value == null || value == '');
                              userprovider.setShowModalLoading = true;

                              ServiceResponse serviceResponse = await userprovider.updateUser(payload);
                              userprovider.setShowModalLoading = false;
                              if (serviceResponse.apiResponse.error) {
                                Fluttertoast.showToast(msg: "something went wrong. try again", gravity: ToastGravity.BOTTOM);

                                return;
                              }
                              Fluttertoast.showToast(msg: "Profile Update Succesfully", gravity: ToastGravity.BOTTOM);
                              Navigator.of(context).pop();
                              return;
                            } else {
                              String? token = await _fcmService.refreshToken();

                              if (token == null) {
                                Fluttertoast.showToast(msg: "something went wrong. try again", gravity: ToastGravity.BOTTOM);

                                return;
                              }

                              print({
                                "fullName": name?.trim(),
                                "email": email == null || email!.isEmpty ? null : email,
                                "phoneNo": mobileNumber,
                                "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
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
                                "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
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
                              userprovider.setShowModalLoading = true;
                              await userprovider.register(payload, context);
                              userprovider.setShowModalLoading = false;
                            }
                          }
                        },
                        child: Card(
                          child: Container(
                              width: 160,
                              height: 40,
                              color: R.color.primaryL1,
                              child: Center(
                                  child: Text(
                                '${isUpdateProfile == true ? "Update" : "Register"}',
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
      ),
    );
  }

  Future _showBottomSheet() async {
    print('pressed');

    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(width: double.infinity, height: 60, child: Center(child: Text('Select min 1 and max 3 specialities'))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search for City',
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // selectedCityFilterList = value.trim();

                        if (value.length < 2) {
                          filteredCities = cityList.where((city) {
                            return city.toString().toLowerCase().contains(value.toLowerCase());
                          }).toList();
                          setState(() {});
                        } else {
                          filteredCities = cityList.where((city) {
                            return city.toString().toLowerCase().contains(value.toLowerCase());
                          }).toList();
                          setState(() {});
                        }
                      });
                    },
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) => CheckboxListTile(
                              title: Text(filteredCities[index]),
                              value: city == filteredCities[index],
                              onChanged: (value) {
                                print(value);
                                if (value == true) {
                                  city = filteredCities[index];
                                  _cityController.text = filteredCities[index];
                                  setState(() {});
                                }
                                if (value == false) {
                                  city = null;
                                  _cityController.clear();
                                  setState(() {});
                                }
                              },
                            ))),

                TextButton(
                    onPressed: () {
                      _updateUi();
                      Navigator.pop(context);
                    },
                    child: Text('Sumbit'))
              ],
            ),
          );
        });
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
