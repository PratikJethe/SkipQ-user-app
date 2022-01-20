import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/screens/clinic/widgets/clinic_info_card.dart';
import 'package:booktokenapp/screens/clinic/widgets/clinic_info_widget.dart';
import 'package:booktokenapp/screens/clinic/widgets/clinic_tab_view.dart';
import 'package:booktokenapp/screens/modal-screen/modal_loading_screen.dart';
import 'package:booktokenapp/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';

class ClinicScreen extends StatefulWidget {
  final Clinic clinic;
  const ClinicScreen({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicScreenState createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
  }

  @override
  Widget build(BuildContext context) {
    return ModalLoadingScreen(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
          child: Column(
            children: [
              backArrowAppbarWithTitle(context, 'Dr. ${clinic.doctorName}'),
              ClinicInfoWidget(clinic: clinic),
              ClinicInfoCard(clinic: clinic),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ClinicTabView(
                clinic: clinic,
              ))
              // ClinicInfoWidget(clinic: clinic)
            ],
          ),
        )),
      ),
    );
  }
}
