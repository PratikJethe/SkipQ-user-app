import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/search/widgets/searched_clinic.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(body: Consumer<UserProvider>(builder: (context, userProvider, _) {
          return Container(
            width: double.infinity,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchAppBar(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location_sharp,
                          color: R.color.primary,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Find nearby clinic',
                              style: R.styles.fz16FontColorPrimary,
                            ))
                      ],
                    ),
                  ),
                  SearchedClinic(),
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}
