import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/clinic/widgets/tab_views/token_view.dart';
import 'package:flutter/material.dart';

class ClinicTabView extends StatefulWidget {
    final Clinic clinic;

  const ClinicTabView({Key? key,required this.clinic}) : super(key: key);

  @override
  _ClinicTabViewState createState() => _ClinicTabViewState();
}

class _ClinicTabViewState extends State<ClinicTabView> with TickerProviderStateMixin {
  late TabController _tabController;

    late Clinic clinic;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      elevation: 25,
      shadowColor: Color.fromRGBO(112, 144, 176, 0.70),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 45,
              child: TabBar(
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(color: R.color.primary, borderRadius: BorderRadius.circular(5)),
                  indicatorColor: Colors.transparent,
                  labelColor: R.color.white,
                  labelStyle: R.styles.fz16Fw500,
                  unselectedLabelColor: R.color.black,
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Token"),
                    Tab(text: "Notice"),
                    Tab(text: "About"),
                  ]),
            ),
            Expanded(
              child: Container(
                //Add this to give height
                child: TabBarView(controller: _tabController, children: [
            ClinicTokenView(clinic: clinic,),
                  Container(
                    child: Text("Articles Body"),
                  ),
                  Container(
                    child: Text("User Body"),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
