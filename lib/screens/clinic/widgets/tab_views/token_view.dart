import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicTokenView extends StatefulWidget {
  final Clinic clinic;
  const ClinicTokenView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTokenViewState createState() => _ClinicTokenViewState();
}

class _ClinicTokenViewState extends State<ClinicTokenView> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
    print('inititialted');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider.value(
          value: clinic,
          child: Consumer<Clinic>(
            builder: (context, clinicProvider, _) => Container(
              child: !clinic.hasClinicStarted ? Center(child: Text('Closed')) : Text('open'),
            ),
          )),
    );
  }
}
