import 'package:skipq/providers/clinic/clinic_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/clinic/widgets/clinic_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedClinic extends StatefulWidget {
  const SearchedClinic({Key? key}) : super(key: key);

  @override
  _SearchedClinicState createState() => _SearchedClinicState();
}

class _SearchedClinicState extends State<SearchedClinic> {
  ScrollController _scrollController = ScrollController();

  bool isPaginating = false;

  late ClinicProvider clinicProvider;
  @override
  void initState() {
    super.initState();
    clinicProvider = Provider.of<ClinicProvider>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset && !isPaginating) {
        setState(() {
          isPaginating = true;
        });

        if (clinicProvider.clinicSearchMode == ClinicSearchMode.TEXT) {
          clinicProvider
              .searchClinic(clinicProvider.serachKeyword)
              .then((value) => setState(() {
                    isPaginating = false;
                  }))
              .catchError((error) => {
                    setState(() {
                      isPaginating = false;
                    })
                  });
        } else {
          clinicProvider
              .searchNearByClinic(clinicProvider.storedLattitude, clinicProvider.storedLongitude)
              .then((value) => setState(() {
                    isPaginating = false;
                  }))
              .catchError((error) => {
                    setState(() {
                      isPaginating = false;
                    })
                  });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clinicProvider.resetSearch(ClinicSearchMode.TEXT);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(
      builder: (context, clinicProvider, _) {
        print('loading state ${clinicProvider.searchLoading}');
        return Expanded(
            child: Container(
          child: clinicProvider.searchLoading && !isPaginating
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : clinicProvider.searchedClinicList.length == 0 && clinicProvider.hasSearchedClinic
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: R.color.bluishGrey,
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'No Result Found',
                          style: R.styles.fz20Fw500,
                        ),
                      ],
                    ))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: clinicProvider.searchedClinicList.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ClinicSearchTile(
                            clinic: clinicProvider.searchedClinicList[index],
                          ),
                          if (isPaginating && index == clinicProvider.searchedClinicList.length - 1)
                            Center(
                              child: CircularProgressIndicator(
                                color: R.color.primaryL1,
                              ),
                            )
                        ],
                      ),
                    ),
        ));
      },
    );
  }
}
