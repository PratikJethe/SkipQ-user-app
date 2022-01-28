import 'package:skipq/constants/globals.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/clinic/widgets/clinic_info_card.dart';
import 'package:skipq/screens/clinic/widgets/clinic_info_widget.dart';
import 'package:skipq/screens/clinic/widgets/clinic_search_tile.dart';
import 'package:flutter/material.dart';

class ClinicVisitInfo extends StatefulWidget {
  final ClinicToken clinicToken;
  const ClinicVisitInfo({Key? key, required this.clinicToken}) : super(key: key);

  @override
  _ClinicVisitInfoState createState() => _ClinicVisitInfoState();
}

class _ClinicVisitInfoState extends State<ClinicVisitInfo> {
  late ClinicToken clinicToken;
  late Clinic clinic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinicToken = widget.clinicToken;
    clinic = widget.clinicToken.clinic;
    print(clinicToken.id);
    print(clinicToken.tokenStatus);
    print(clinicToken.createdAt);
    print(clinicToken.updatedAt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.symmetric(
                horizontal: 0,
              ),
              width: double.infinity,
              child: Text(
                '${clinicToken.tokenStatus == TokenStatus.REQUESTED ? 'Requested Token' : 'Pending Token'}',
                style: R.styles.fz24Fw700,
              )),
          ClinicSearchTile(
            clinic: clinic,
            horizontalMargin: 0,
          ),
        ],
      ),
    );
  }
}
