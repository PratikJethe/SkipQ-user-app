import 'dart:io';
import 'package:skipq/constants/globals.dart';
import 'package:skipq/models/api_response_model.dart';
import 'package:skipq/models/user_model.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/authentication/registration_screen.dart';
import 'package:skipq/screens/drawer/drawer_widget.dart';
import 'package:skipq/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq/screens/profile/widget/profile_image.dart';
import 'package:skipq/service/firebase_services/firebase_storage_service.dart';
import 'package:skipq/service/image_service/image_service.dart';
import 'package:skipq/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum PicType { CAMERA, GALLERY, REMOVE }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String?> _updateProfilePic(ImageSource imageSource, id) async {
    File? image = await ImageService.updateProfilePic(imageSource);

    if (image != null) {
      return await FirebaseStorageService.uploadImage(image, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
          color: R.color.black,
        ),
      ),
      drawer: UserDrawer(),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        print(userProvider.user.dob);
        return Center(
          child: Container(
            // margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // height: MediaQuery.of(context).size.height*0.9,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      PicType? picType = await _showBottomSheet(userProvider.user.id);

                                      print(picType);

                                      String? url;
                                      userProvider.setShowModalLoading = true;

                                      if (picType == PicType.CAMERA) {
                                        url = await _updateProfilePic(ImageSource.camera, userProvider.user.id);

                                        if (url == null) {
                                          userProvider.setShowModalLoading = false;

                                          return;
                                        }
                                      } else if (picType == PicType.GALLERY) {
                                        url = await _updateProfilePic(ImageSource.gallery, userProvider.user.id);
                                        if (url == null) {
                                          userProvider.setShowModalLoading = false;

                                          return;
                                        }
                                      } else if (picType == PicType.REMOVE) {
                                        url = null;
                                      } else {
                                        userProvider.setShowModalLoading = false;

                                        return;
                                      }
                                      User user = userProvider.user;
                                      Map<String, dynamic> payload = {
                                        "fullName": user.fullName,
                                        "pincode": user.address?.pincode,
                                        "address": user.address?.address,
                                        "apartment": user.address?.apartment,
                                        "gender": user.gender == null ? null : user.gender.toString().split('.').last,
                                        "city": user.address?.city,
                                        "dateOfBirth": user.dob?.toIso8601String(),
                                        "coordinates": user.address?.coordinates,
                                        "profilePicUrl": url
                                      };

                                      print(payload);

                                      payload.removeWhere((key, value) => value == null);
                                      ServiceResponse serviceResponse = await userProvider.updateUser(payload);

                                      if (!serviceResponse.apiResponse.error) {
                                        userProvider.setShowModalLoading = false;

                                        Fluttertoast.showToast(
                                            msg: 'Image succesfully updated',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            fontSize: 16.0);
                                      } else {
                                        userProvider.setShowModalLoading = false;

                                        Fluttertoast.showToast(
                                            msg: serviceResponse.apiResponse.errMsg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            fontSize: 16.0);
                                      }
                                    } catch (e) {
                                      userProvider.setShowModalLoading = false;

                                      Fluttertoast.showToast(
                                          msg: 'Something went wong. try again!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                      // width: MediaQuery.of(context).size.width * 0.2,

                                      child: UserProfileWidget(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        shape: BoxShape.rectangle,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: R.styles.fz16Fw700,
                                      ),
                                      Text(userProvider.user.fullName, style: R.styles.fz16FontColorPrimary)
                                    ],
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                          infoTile('Contact', '+${userProvider.user.contact.dialCode} ${userProvider.user.contact.phoneNo}'),
                          infoTile('Email', userProvider.user.email),
                          infoTile('Address', userProvider.user.address?.address),
                          infoTile('Apartemnt', userProvider.user.address?.apartment),
                          infoTile('City', userProvider.user.address?.city),
                          infoTile('Pincode', userProvider.user.address?.pincode),
                          infoTile('Gender', userProvider.user.gender != null ? userProvider.user.gender.toString().split('.').last : null),
                          infoTile(
                              'Date of Birth',
                              userProvider.user.dob != null
                                  ? '${userProvider.user.dob!.day}/${userProvider.user.dob!.month}/${userProvider.user.dob!.year}'
                                  : null),
                          SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistrationScreen(
                                isUpdateProfile: true,
                                userProvider: userProvider,
                              )));
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primaryL1)),
                    child: Text(
                      'Edit Profile',
                      style: R.styles.fontColorWhite,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  infoTile(label, value) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: R.styles.fz16Fw700,
          ),
          Spacer(),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
            child: Text(
              value ?? '',
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: R.styles.fz16FontColorPrimary.merge(R.styles.fw500),
            ),
          )
        ],
      ),
    );
  }

  Future<PicType?> _showBottomSheet(id) {
    return showModalBottomSheet<PicType?>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )),
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () async {
                    // String? url = await _updateProfilePic(ImageSource.camera, id);
                    Navigator.of(context).pop(PicType.CAMERA);
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.collections),
                  title: Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop(PicType.GALLERY);
                    //   String? url = await _updateProfilePic(ImageSource.gallery, id);
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever_rounded),
                  title: Text('Remove'),
                  onTap: () {
                    Navigator.of(context).pop(PicType.REMOVE);
                  },
                )
              ],
            ),
          );
        });
  }
}
