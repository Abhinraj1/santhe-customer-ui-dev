import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../API/addressSearchAPI.dart';
import '../../constants.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  PlaceApiProvider apiClient = PlaceApiProvider();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0.0),
      inputDecorationTheme: searchFieldDecorationTheme,
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: GoogleFonts.mulish(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(
          Icons.clear,
          color: Colors.grey,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.grey,
        size: 20.0,
      ),
      onPressed: () {
        //close(context, null);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("No Result Found");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // var length;
    return FutureBuilder(
        future: query == ""
            ? null
            : apiClient.fetchSuggestions(
                query, Localizations.localeOf(context).languageCode),
        builder: (context, AsyncSnapshot snapshot) => query == ''
            ? Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Enter your address',
                  style: Constant.regularGrayText16,
                ),
              )
            : snapshot.hasData
                ? snapshot.hasData
                    ? ListView.builder(
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              print(snapshot.data[index]);
                              PlaceApiProvider placeApiProvider =
                                  PlaceApiProvider();
                              placeApiProvider.getPlaceDetailFromId(
                                  snapshot.data[index].placeId);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add_location_outlined,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Column(
                                    children: [
                                      Wrap(children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.87,
                                            child: Text(
                                              snapshot.data[index].description,
                                              style: Constant.regularGrayText16,
                                              maxLines: 5,
                                            ))
                                      ]),
                                    ],
                                  )
                                ],
                              ),
                            )),
                        itemCount: snapshot.data.length,
                      )
                    : const Text('Loading...')
                : Container());
  }
}
