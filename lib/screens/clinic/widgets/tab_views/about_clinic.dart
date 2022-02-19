import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/resources/resources.dart';
import 'package:flutter/material.dart';

class AboutClinic extends StatefulWidget {
  final Clinic clinic;
  const AboutClinic({Key? key, required this.clinic}) : super(key: key);

  @override
  _AboutClinicState createState() => _AboutClinicState();
}

class _AboutClinicState extends State<AboutClinic> {
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
      margin: EdgeInsets.symmetric(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text('Clinic Name', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Text('${clinic.clinicName}', style: R.styles.fz18Fw700),
            SizedBox(
              height: 10,
            ),
            Text('Speciality', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Wrap(
              // runSpacing: 5,
              key: new Key(DateTime.now().toString()),
              children: clinic.speciality
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: 5, top: 5),
                        decoration: BoxDecoration(color: R.color.primaryL1, borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: Text(
                            e,
                            style: R.styles.fz16Fw500.merge(R.styles.fontColorWhite),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Address', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Text('${clinic.address.address}', style: R.styles.fz18Fw700),
            SizedBox(
              height: 10,
            ),
            Text('Apartment', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Text('${clinic.address.apartment ?? ''}', style: R.styles.fz18Fw700),
            SizedBox(
              height: 10,
            ),
            Text('City', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Text('${clinic.address.city}', style: R.styles.fz18Fw700),
            SizedBox(
              height: 10,
            ),
            Text('Pincode', style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey)),
            Text('${clinic.address.pincode??""}', style: R.styles.fz18Fw700),
            
          ],
        ),
      ),
    );
  }
}
