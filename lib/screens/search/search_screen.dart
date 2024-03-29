import 'package:skipq/providers/clinic/clinic_provider.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq/screens/search/widgets/searched_clinic.dart';
import 'package:skipq/service/geolocation_service.dart';
import 'package:skipq/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ModalLoadingScreen(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(body: Consumer2<UserProvider, ClinicProvider>(builder: (context, userProvider, clinicProvider, _) {
            return Container(
              width: double.infinity,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchAppBar(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.my_location_sharp,
                            color: R.color.primary,
                          ),
                          TextButton(
                              onPressed: () async {
                                FocusScope.of(context).requestFocus(FocusNode());

                                GeolocationService geolocatorService = GeolocationService();

                                LocationPermission locationPermission = await geolocatorService.permissionStatus();

                                print(locationPermission);

                                if (locationPermission == LocationPermission.deniedForever) {
                                  Fluttertoast.showToast(
                                      msg: "Location permission is denied. go to settings and allow location access to proceed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      fontSize: 12.0);

                                  return;
                                }

                                if (locationPermission == LocationPermission.denied) {
                                  locationPermission = await Geolocator.requestPermission();
                                  if (locationPermission != LocationPermission.always && locationPermission != LocationPermission.whileInUse) {
                                    return;
                                  }
                                }

                                if (locationPermission == LocationPermission.always || locationPermission == LocationPermission.whileInUse) {
                                  clinicProvider.setSearchLoading = true;

                                  Position position = await geolocatorService.getCordinates();
                                  clinicProvider.setSearchLoading = false;

                                  if (!clinicProvider.searchLoading) {
                                    clinicProvider.resetSearch(ClinicSearchMode.LOCATION);
                                    clinicProvider.latlng = [position.latitude, position.longitude]; //store for pagination process
                                    clinicProvider.searchNearByClinic(position.latitude, position.longitude);
                                  }
                                }
                              },
                              child: Text(
                                'Find nearby clinic',
                                style: R.styles.fz16FontColorPrimary,
                              ))
                        ],
                      ),
                    ),
                    SearchedClinic(),
                  ],
                ),
              ),
            );
          })),
        ),
      ),
    );
  }
}
