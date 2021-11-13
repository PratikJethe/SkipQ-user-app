import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/search/widgets/searched_clinic.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final int currentIndex;
  final Function changeCurrentIndex;
  const SearchScreen({Key? key, required this.currentIndex, required this.changeCurrentIndex}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchAppBar(
              currentIndex: widget.currentIndex,
              changeCurrentIndex: widget.changeCurrentIndex,
            ),
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
                        'Search by Location',
                        style: R.styles.fz16FontColorPrimary,
                      ))
                ],
              ),
            ),
            SearchedClinic(),

          ],
        ),
      ),
    ));
  }
}
