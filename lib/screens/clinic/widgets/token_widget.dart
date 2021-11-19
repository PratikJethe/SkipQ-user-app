import 'package:booktokenapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokenWidget extends StatefulWidget {
  final ClinicToken clinicToken;
  final int index;
  const TokenWidget({Key? key, required this.clinicToken, required this.index}) : super(key: key);

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  late ClinicToken clinicToken;
  late int index;
  @override
  void initState() {
    super.initState();
    clinicToken = widget.clinicToken;
    index = widget.index;
    print('Token');
    print(clinicToken.id);
    print(clinicToken.createdAt);
    print(clinicToken.updatedAt);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border:
                  (clinicToken.user != null && clinicToken.user!.id == userProvider.user.id) ? Border.all(color: R.color.primaryL1, width: 4) : null,
              color: Color.fromRGBO(224, 227, 231, 0.3),
              borderRadius: BorderRadius.circular(15)),
          width: (MediaQuery.of(context).size.width * 0.90) / 4 - 10,
          height: (MediaQuery.of(context).size.width * 0.90) / 4 + 10,
          child: Center(
            child: Container(
              height: (MediaQuery.of(context).size.width * 0.90) / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${index + 1}'),
                  if (clinicToken.user == null || clinicToken.user!.id != userProvider.user.id)
                    Text('${clinicToken.isOnline ? 'online' : 'offline'}'),
                  if (clinicToken.user != null && clinicToken.user!.id == userProvider.user.id) Text('my token'),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
