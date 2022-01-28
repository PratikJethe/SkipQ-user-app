import 'package:skipq/providers/clinic/clinic_provider.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/my_tokens/widgets/visit_info.dart';
import 'package:skipq/widgets/custom_appbars.dart';
import 'package:skipq/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicUserToken extends StatefulWidget {
  final bool showAppbar;
  const ClinicUserToken({Key? key, required this.showAppbar}) : super(key: key);

  @override
  _ClinicUserTokenState createState() => _ClinicUserTokenState();
}

class _ClinicUserTokenState extends State<ClinicUserToken> {
  late bool showAppBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showAppBar = widget.showAppbar;
    WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getUserToken());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
          return clinicProvider.isUserTokenLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: R.color.primaryL1,
                ))
              : clinicProvider.hasErrorUserTokenLoading
                  ? Text('Error while loading')
                  : Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          showAppBar == true ? SearchAppBar() : backArrowAppbar(context),
                          (clinicProvider.userTokenList.isNotEmpty)
                              ? ClinicVisitInfo(clinicToken: clinicProvider.userTokenList.first)
                              : Card(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  // elevation: 10,
                                  child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      child: Center(
                                        child: Text(
                                          'No requested or pending tokens',
                                          style: R.styles.fz24Fw700,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                        ],
                      ),
                    );
        }),
      ),
    );
  }
}
