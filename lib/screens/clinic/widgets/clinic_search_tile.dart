import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/clinic/clinic_screen.dart';
import 'package:booktokenapp/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ClinicSearchTile extends StatelessWidget {
  final Clinic clinic;
  final double? horizontalMargin;
  const ClinicSearchTile({Key? key, required this.clinic, this.horizontalMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // FocusManager.instance.primaryFocus?.unfocus();

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClinicScreen(clinic: clinic)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        shadowColor: Color.fromRGBO(112, 144, 176, 0.15),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: horizontalMargin ?? 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   clipBehavior: Clip.hardEdge,
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                //   height: MediaQuery.of(context).size.height * 0.17,
                //   width: MediaQuery.of(context).size.width * 0.25,
                //   child:
                DoctorProfileWidget(
                  url: clinic.profilePicUrl,
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width * 0.25,
                  borderRadius: 10,
                ),
                // ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${clinic.doctorName}',
                          style: R.styles.fz16Fw700,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${clinic.speciality.first}',
                          style: R.styles.fz14FontColorPrimary.merge(R.styles.fw700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                transform: Matrix4.translationValues(-5, 0, 0),
                                child: Icon(
                                  Icons.location_on,
                                  color: R.color.primary,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                    clinic.address.address,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: R.styles.fz14Fw700.merge(R.styles.fontColorBluishGrey),
                                  )),
                                  if (!clinic.address.address.contains(clinic.address.city))
                                    Container(
                                        child: Text(
                                      clinic.address.city,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: R.styles.fz14Fw700.merge(R.styles.fontColorBluishGrey),
                                    )),
                                  if (clinic.address.pincode != null)
                                    Container(
                                        child: Text(
                                      clinic.address.pincode.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: R.styles.fz14Fw700.merge(R.styles.fontColorBluishGrey),
                                    )),
                                ],
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
