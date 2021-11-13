import 'package:booktokenapp/providers/clinic/clinic_provider.dart';
import 'package:booktokenapp/screens/clinic/widgets/clinic_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedClinic extends StatefulWidget {
  const SearchedClinic({Key? key}) : super(key: key);

  @override
  _SearchedClinicState createState() => _SearchedClinicState();
}

class _SearchedClinicState extends State<SearchedClinic> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(
      builder: (context, clinicProvider, _) {
        print('loading state ${clinicProvider.searchLoading}');
        return Expanded(
            child: Container(
          child: clinicProvider.searchLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : clinicProvider.searchedClinicList.length == 0 && clinicProvider.hasSearchedClinic
                  ? Text('No doctors found')
                  : ListView.builder(
                      itemCount: clinicProvider.searchedClinicList.length,
                      itemBuilder: (context, index) => ClinicSearchTile(
                        clinic: clinicProvider.searchedClinicList[index],
                      ),
                    ),
        ));
      },
    );
  }
}
