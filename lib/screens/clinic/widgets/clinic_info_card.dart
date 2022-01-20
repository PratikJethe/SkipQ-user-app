import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:flutter/material.dart';

class ClinicInfoCard extends StatefulWidget {
  final Clinic clinic;

  const ClinicInfoCard({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicInfoCardState createState() => _ClinicInfoCardState();
}

class _ClinicInfoCardState extends State<ClinicInfoCard> {
  late Clinic clinic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 10,
      shadowColor: Color.fromRGBO(112, 144, 176, 0.60),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 10),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'About Doctor',
                //         style: R.styles.fz16FontColorPrimary,
                //       ),
                //       Text(
                //         clinic.about ?? '',
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Text(
                //         'Location',
                //         style: R.styles.fz16FontColorPrimary,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: R.color.primaryL1,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.location_on,
                          color: R.color.primaryL1,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Container(
                            child: Text(
                              clinic.address.address ,
                              style: R.styles.fz14Fw500.merge(R.styles.fontColorWhite),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
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
