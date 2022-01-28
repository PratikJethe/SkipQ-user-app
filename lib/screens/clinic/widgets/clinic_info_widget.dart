import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';

class ClinicInfoWidget extends StatefulWidget {
  final Clinic clinic;

  const ClinicInfoWidget({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicInfoWidgetState createState() => _ClinicInfoWidgetState();
}

class _ClinicInfoWidgetState extends State<ClinicInfoWidget> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          // Container(
          //   clipBehavior: Clip.hardEdge,
          //   decoration: BoxDecoration(shape: BoxShape.circle),
          //   height: MediaQuery.of(context).size.height * 0.17,
          //   width: MediaQuery.of(context).size.width * 0.25,
          //   child: Image.network(
          //     clinic.profilePicUrl ?? '',
          //     fit: BoxFit.fill,
          //   ),
          // ),
          DoctorProfileWidget(
            shape: BoxShape.circle,
            url: clinic.profilePicUrl,
            height: MediaQuery.of(context).size.height * 0.17,
            width: MediaQuery.of(context).size.width * 0.25,

            // borderRadius: 10,
          ),

          SizedBox(
            width: 20,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${clinic.doctorName}',
                  style: R.styles.fz16Fw700,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${clinic.speciality.first}',
                  style: R.styles.fz14Fw500.merge(R.styles.fontColorPrimary),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: R.color.primary,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${clinic.contact.phoneNo}',
                      style: R.styles.fz16Fw500,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
