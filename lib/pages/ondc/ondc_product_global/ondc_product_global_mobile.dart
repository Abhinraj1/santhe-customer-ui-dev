part of "ondc_product_global_view.dart";

// import 'dart:convert';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../constants.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/blocs/ondc/ondc_bloc.dart';
// import '../../../core/loggers.dart';
// import '../../../core/repositories/ondc_repository.dart';
// import '../../../models/ondc/product_ondc.dart';
// import '../../../models/ondc/shop_model.dart';
// import '../../../models/user_profile/customer_model.dart';
// import '../../../widgets/navigation_drawer_widget.dart';
// import '../../../widgets/ondc_widgets/ondc_shop_widget.dart';
// import 'package:http/http.dart' as http;
// import '../ondc_cart/ondc_cart_view.dart';

class _OndcProductGlobalMobile extends StatefulWidget {
  final CustomerModel customerModel;
  List<OndcProductWidget> productWidget;
  List<ProductOndcModel> productOndcModel;
  String productName;

  _OndcProductGlobalMobile({
    Key? key,
    required this.customerModel,
    required this.productWidget,
    required this.productOndcModel,
    required this.productName,
  }) : super(key: key);

  @override
  State<_OndcProductGlobalMobile> createState() =>
      _OndcProductGlobalMobileState();
}

class _OndcProductGlobalMobileState extends State<_OndcProductGlobalMobile>
    with LogMixin {
  final ScrollController _controller = ScrollController();
  bool _loading = false;
  int nglobalSearch = 20;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    warningLog('product name${widget.productName}');
    _textEditingController = TextEditingController(text: widget.productName);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // Bottom poistion
        setState(() {
          nglobalSearch = nglobalSearch + 20;
        });
        warningLog('Called and limit $nglobalSearch');

        getNewProducts(
            transactionIdLocal:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
            productName: _textEditingController.text,
            productWidgetsLocal: widget.productWidget);
      }
    });
  }

  getSearchView() {
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
                child: TextField(
                  maxLength: 50,
                  controller: _textEditingController,
                  onChanged: (value) {
                    // _searchList(
                    //   searchText: value,
                    //   mainOndcShopWidgets: shopWidgets,
                    // );
                    setState(() {
                      widget.productName = _textEditingController.text;
                    });
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
                              SearchOndcItemGlobal(
                                transactionId:
                                    RepositoryProvider.of<OndcRepository>(
                                            context)
                                        .transactionId,
                                productName: _textEditingController.text,
                              ),
                            );
                        ge.Get.back();
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
  }

  getNewProducts(
      {required String transactionIdLocal,
      required String productName,
      required List<OndcProductWidget> productWidgetsLocal}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/item/nearby?transaction_id=$transactionIdLocal&search=%${widget.productName}%&limit=$nglobalSearch&offset=0');
    try {
      setState(() {
        _loading = true;
      });
      warningLog(
          'global search product $productName ${_textEditingController.text} and length of product list ${productWidgetsLocal.length}');
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('json data $responseBody');
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
      warningLog(
          'models length ${widget.productOndcModel.length} and ${searchedProducts.length}');
      List<ProductOndcModel> differenceModels = searchedProducts
          .toSet()
          .difference(widget.productOndcModel.toSet())
          .toList();
      warningLog(
          'difference of models${differenceModels.length} $differenceModels');
      List<OndcProductWidget> addableItems = [];
      for (var model in differenceModels) {
        addableItems.add(OndcProductWidget(productOndcModel: model));
      }
      warningLog('addable items${addableItems.length}');
      productWidgetsLocal.addAll(addableItems);
      warningLog('new length${productWidgetsLocal.length}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          addableItems.clear();
          widget.productWidget = productWidgetsLocal;
          widget.productOndcModel.addAll(differenceModels);
          _loading = false;
        });
      });
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OndcBloc, OndcState>(
      listener: (context, state) {
        // TODO: implement listener
        warningLog('$state');
        if (state is FetchedItemsInGlobal) {
          List<OndcProductWidget> productsWidget = [];
          for (var productModel in state.productModels) {
            productsWidget.add(
              OndcProductWidget(productOndcModel: productModel),
            );
          }
          warningLog('productWidgets $productsWidget');
          setState(() {
            widget.productOndcModel = state.productModels;
            widget.productWidget = productsWidget;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
            key: _key,
            drawer: const CustomNavigationDrawer(),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  //!something to add
                  //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
                  /*log(await AppHelpers().getToken);
                sendNotification('tesst');*/
                  _key.currentState!.openDrawer();
                  /*FirebaseAnalytics.instance.logEvent(
                  name: "select_content",
                  parameters: {
                    "content_type": "image",
                    "item_id": 'itemId',
                  },
                ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
                },
                splashRadius: 25.0,
                icon: SvgPicture.asset(
                  'assets/drawer_icon.svg',
                  color: Colors.white,
                ),
              ),
              shadowColor: Colors.orange.withOpacity(0.5),
              elevation: 10.0,
              title: const AutoSizeText(
                kAppName,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 24),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.5),
                  child: IconButton(
                    onPressed: () {
                      // if (Platform.isIOS) {
                      //   Share.share(
                      //     AppHelpers().appStoreLink,
                      //   );
                      // } else {
                      //   Share.share(
                      //     AppHelpers().playStoreLink,
                      //   );
                      // }
                      ge.Get.back();
                    },
                    splashRadius: 25.0,
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 27.0,
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Center(
                        child: Container(
                          color: Colors.white,
                          height: 30,
                          width: 320,
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Delivery to: ',
                                style: const TextStyle(fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.customerModel.address
                                        .substring(0, 25),
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  // can add more TextSpans here...
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      //! add the indicator here
                      Stack(
                        children: [
                          Image.asset(
                            'assets/newshoppingcartorange.png',
                            height: 45,
                            width: 45,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: _textEditingController,

                        onTap: () {
                          warningLog('tapped');
                          ge.Get.to(
                            getSearchView(),
                          );
                        },
                        // controller: _textEditingController,
                        // onChanged: (value) {
                        //   _searchList(
                        //     searchText: value,
                        //     mainOndcShopWidgets: shopWidgets,
                        //   );
                        // },
                        // maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Search Products here',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => ge.Get.back(),
                            child: const Icon(
                              Icons.cancel,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: GestureDetector(
                            onTap: () {
                              // context.read<OndcBloc>().add(
                              //       SearchOndcItemGlobal(
                              //           transactionId:
                              //               RepositoryProvider
                              //                       .of<OndcRepository>(
                              //                           context)
                              //                   .transactionId,
                              //           productName:
                              //               _textEditingController
                              //                   .text),
                              //     );
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${RepositoryProvider.of<OndcRepository>(context).productGlobalCount} items found'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Center(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.9,
                        //!check on spread operator
                        children: [...widget.productWidget],
                      ),
                    ),
                  ),
                  _loading ? const CircularProgressIndicator() : const Text('')
                ],
              ),
            ));
      },
    );
  }
}
