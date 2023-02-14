import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';
import '../../core/app_colors.dart';
import '../../core/blocs/ondc/ondc_bloc.dart';
import '../../core/repositories/ondc_repository.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _textEditingController = TextEditingController();
  String productName = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OndcBloc, OndcState>(listener: (context, state) {
      if (state is SearchItemLoaded) {
        Get.back();
      }
    }, builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors().brandDark,
                    size: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 70,
                  child: TextFormField(
                    maxLength: 50,
                    controller: _textEditingController,
                    onChanged: (value) {
                      if (value.length >= 3) {
                        setState(() {
                          productName = _textEditingController.text;
                        });
                        // context.read<OndcBloc>().add(
                        //   FetchListOfShopWithSearchedProducts(
                        //     transactionId:
                        //     // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                        //     RepositoryProvider.of<OndcRepository>(
                        //         context)
                        //         .transactionId,
                        //     productName: _textEditingController.text,
                        //   ),
                        // );
                      }
                      // _searchList(
                      //   searchText: value,
                      //   mainOndcShopWidgets: shopWidgets,
                      // );
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Products here',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () {
                          context.read<OndcBloc>().add(
                                FetchListOfShopWithSearchedProducts(
                                  transactionId:
                                      // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                                      RepositoryProvider.of<OndcRepository>(
                                              context)
                                          .transactionId,
                                  productName: _textEditingController.text,
                                ),
                              );
                          setState(() {
                            productName = _textEditingController.text;
                          });
                          _textEditingController.clear();
                          ge.Get.back(
                            result: productName,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.0),
                          child: Icon(
                            CupertinoIcons.search_circle_fill,
                            size: 32,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  'Search for products',
                  style: TextStyle(
                    color: AppColors().brandDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
