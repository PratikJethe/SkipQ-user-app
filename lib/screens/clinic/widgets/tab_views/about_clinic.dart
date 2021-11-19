import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doctor Name'),
          Text('Dr. ${clinic.doctorName}'),
          SizedBox(
            height: 10,
          ),
          Text('Clinic Name'),
          Text('${clinic.clinicName}'),
          SizedBox(
            height: 10,
          ),
          Text('Address'),
          Text('${clinic.address.address}'),
          SizedBox(
            height: 10,
          ),
          Text('Apartment'),
          Text('${clinic.address.apartment ?? ''}'),
          SizedBox(
            height: 10,
          ),
          Text('City'),
          Text('${clinic.address.city}'),
          SizedBox(
            height: 10,
          ),
          Text('Pincode'),
          Text('${clinic.address.pincode}'),
        ],
      ),
    );
  }
}
