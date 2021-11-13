import 'package:booktokenapp/providers/clinic/clinic_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/widgets/textfield_borders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget {
  final int currentIndex;
  final Function changeCurrentIndex;
  const SearchAppBar({Key? key, required this.currentIndex, required this.changeCurrentIndex}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(
      builder: (context, clinicProvider, _) => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: GestureDetector(
                  onTap: () {
                    print(widget.currentIndex);
                    if (widget.currentIndex != 1) {
                      widget.changeCurrentIndex(1);
                    }
                  },
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: R.color.primaryL1,
                    style: R.styles.fz16FontColorBlack,
                    cursorHeight: 20,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        clinicProvider.searchClinic(value);
                      }
                    },
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15, bottom: 23),
                      enabled: widget.currentIndex == 1,

                      border: InputBorder.none,
                      constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                      hintStyle: R.styles.fz16FontColorPrimary,
                      hintText: 'Search by name, location, address, pincode and speaciality',

                      filled: true,
                      fillColor: R.color.lightGreyish,
                      prefixIcon: Icon(
                        Icons.search,
                        color: R.color.primaryL2,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.currentIndex != 1) SizedBox(width: 10),
            (widget.currentIndex != 1)
                ? Icon(
                    Icons.account_circle,
                    size: 40,
                    color: R.color.primary,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
