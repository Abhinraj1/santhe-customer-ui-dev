// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_shopdetails_view;

class _HyperlocalShopdetailsMobile extends StatefulWidget {
  final HyperLocalShopModel hyperLocalShopModel;

  const _HyperlocalShopdetailsMobile({required this.hyperLocalShopModel});

  @override
  State<_HyperlocalShopdetailsMobile> createState() =>
      _HyperlocalShopdetailsMobileState();
}

class _HyperlocalShopdetailsMobileState
    extends State<_HyperlocalShopdetailsMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  String productNameLocal = '';
  dynamic cartCount = 0;
  List<HyperLocalProductWidget> productWidgets = [];
  List<HyperLocalProductModel> productModels = [];
  List<HyperLocalProductWidget> searchWidgets = [];
  List<HyperLocalProductModel> searchModels = [];
  List<HyperLocalProductModel> existingModels = [];

  @override
  void initState() {
    super.initState();
    context.read<HyperlocalShopBloc>().add(
          HyperLocalGetProductOfShopEvent(
              shopId: widget.hyperLocalShopModel.id,
              lat: customerModel.lat,
              lng: customerModel.lng),
        );
  }

  @override
  Widget build(BuildContext context) {
    warningLog(
        'checking for customer info${customerModel.lat} ${customerModel.lng}');
    return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
      listener: (context, state) {
        errorLog('$state');
        if (state is HyperLocalGetProductsOfShopState) {
          List<HyperLocalProductWidget> hyperLocalProductWidgets = [];
          productModels = [];
          productModels = state.hyperLocalProductModels;
          for (var element in productModels) {
            hyperLocalProductWidgets.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
          }
          setState(() {
            productWidgets = hyperLocalProductWidgets;
            existingModels = productModels;
            cartCount = RepositoryProvider.of<HyperLocalRepository>(context)
                .cartTotalCountLocal;
          });
        }
        if (state is HyperLocalGetSearchProductsOfShopState) {
          List<HyperLocalProductWidget> productWidgets = [];
          searchWidgets = [];
          searchModels = [];
          searchModels = state.hyperLocalProductModels;
          for (var element in searchModels) {
            productWidgets.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
            setState(() {
              searchWidgets = productWidgets;
            });
          }
          // context.read<HyperlocalShopBloc>().add(
          //       HyperLocalGetResetEvent(),
          //     );
        }
        if (state is HyperLocalClearShopSearchProductState) {
          List<HyperLocalProductWidget> productWidgetsLocal = [];
          productModels = [];
          productModels = state.hyperLocalProductModels;
          existingModels = [];
          for (var element in productModels) {
            productWidgetsLocal.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
          }
          setState(() {
            productWidgets = productWidgetsLocal;
            existingModels = productModels;
          });
        }
        if (state is HyperLocalGetSearchProductsOfShopErrorState) {
          errorLog('ERROR GETTING');
          setState(() {
            searchWidgets = [];
            productWidgets = [];
            productModels = [];
            searchModels = [];
          });
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            key: _key,
            drawer: const CustomNavigationDrawer(),
            backgroundColor: CupertinoColors.systemBackground,
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
                      Get.to(const OndcCheckOutScreenMobile());
                    },
                    splashRadius: 25.0,
                    icon: InkWell(
                      onTap: () {
                        Get.to(
                          () => const OndcIntroView(),
                        );
                      },
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 27.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: state is HyperLocalGetProductsOfShopLoadingState
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                          'Getting products of shops',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : state is HyperLocalGetSearchProductsOfShopLoadingState
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            Text(
                              'Getting items',
                              style: TextStyle(
                                color: AppColors().brandDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/bannerondc.png',
                                  height: widget.hyperLocalShopModel.address
                                              .toString()
                                              .length >
                                          75
                                      ? 200
                                      : 180,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  height: widget.hyperLocalShopModel.address
                                              .toString()
                                              .length >
                                          75
                                      ? 200
                                      : 180,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  warningLog(
                                                      'Checking for search term before exiting${globalSearchtextEditingController.text}');
                                                  globalSearchtextEditingController
                                                      .clear();

                                                  Get.off(
                                                    () =>
                                                        HyperlocalShophomeView(
                                                            lat: customerModel
                                                                .lat,
                                                            lng: customerModel
                                                                .lng),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color: AppColors().white100,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AutoSizeText(
                                              '${widget.hyperLocalShopModel.name}',
                                              minFontSize: 16,
                                              style: TextStyle(
                                                color: AppColors().white100,
                                                fontSize: 22,
                                                // fontSize: widget.hyperLocalShopModel.name
                                                //             .toString()
                                                //             .length >
                                                //         60
                                                //     ? 20
                                                //     : 30,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
//! this is actually address the api returns address inside the email parameter so keep that in mind
                                            widget.hyperLocalShopModel.email ==
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/emailpng.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          "NA",
                                                          style: TextStyle(
                                                              color: AppColors()
                                                                  .white100,
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          '${widget.hyperLocalShopModel.email}',
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .white100,
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            widget.hyperLocalShopModel.upi_id ==
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/phonepng.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          "NA",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors()
                                                                .white100,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/phonepng.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          '${widget.hyperLocalShopModel.upi_id}',
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .white100,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            //! this is the email but it is interchanged with address in api response
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/emailpng.png',
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    AutoSizeText(
                                                      '${widget.hyperLocalShopModel.address}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      minFontSize: 10,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        color: AppColors()
                                                            .white100,
                                                        fontSize: 13,
                                                        // fontSize: widget.hyperLocalShopModel.name
                                                        //             .toString()
                                                        //             .length >
                                                        //         60
                                                        //     ? 20
                                                        //     : 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //! reatest

                                            //! change this to delivery
                                            AutoSizeText(
                                              widget.hyperLocalShopModel
                                                              .address !=
                                                          null &&
                                                      widget.hyperLocalShopModel
                                                              .address ==
                                                          true
                                                  ? "Home Delivery Available"
                                                  : "",
                                              minFontSize: 10,
                                              style: TextStyle(
                                                color: AppColors().white100,
                                                fontSize: 13,
                                                // fontFamily: ,
                                                // fontSize: widget.hyperLocalShopModel.name
                                                //             .toString()
                                                //             .length >
                                                //         60
                                                //     ? 20
                                                //     : 30,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                BlocConsumer<HyperlocalCartBloc,
                                    HyperlocalCartState>(
                                  listener: (context, state) async {
                                    errorLog('State Check $state');
                                    if (state is ResetHyperLocalCartState) {
                                      await RepositoryProvider.of<
                                              HyperLocalRepository>(context)
                                          .getCartCount(
                                              storeDescriptionId: widget
                                                  .hyperLocalShopModel.id);
                                      setState(() {
                                        cartCount = RepositoryProvider.of<
                                                HyperLocalRepository>(context)
                                            .cartTotalCountLocal;
                                      });
                                    }
                                  },
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        //toDo : add indicator while cart bloc implementation
                                        child: GestureDetector(
                                          onTap: () {
                                            errorLog(
                                                '${widget.hyperLocalShopModel.id}');
                                            Get.to(
                                              () => HyperlocalCartView(
                                                storeDescriptionId: widget
                                                    .hyperLocalShopModel.id,
                                              ),
                                            );
                                          },
                                          child: badges.Badge(
                                            position:
                                                badges.BadgePosition.topEnd(
                                                    top: 0, end: 3),
                                            badgeAnimation: const badges
                                                .BadgeAnimation.slide(),
                                            badgeStyle: badges.BadgeStyle(
                                              badgeColor: AppColors().brandDark,
                                            ),
                                            showBadge: true,
                                            badgeContent: Text(
                                              '$cartCount',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  AppColors().brandDark,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/newshoppingcart.png',
                                                  fit: BoxFit.fill,
                                                  height: 55,
                                                  width: 55,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    setState(
                                      () {
                                        productNameLocal =
                                            _textEditingController.text;
                                      },
                                    );
                                    context.read<HyperlocalShopBloc>().add(
                                          HyperLocalGetSearchProductsOfShopEvent(
                                            shopId:
                                                widget.hyperLocalShopModel.id,
                                            productName:
                                                _textEditingController.text,
                                            lat: customerModel.lat,
                                            lng: customerModel.lng,
                                          ),
                                        );
                                  },
                                  // onTap: () {
                                  //   ge.Get.to(getSearchView());
                                  // },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    labelText: 'Search Products',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    suffixIcon: state
                                            is HyperLocalGetSearchProductsOfShopState
                                        ? GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<HyperlocalShopBloc>()
                                                  .add(
                                                    HyperLocalGetSearchProductsClearEvent(
                                                        shopId: widget
                                                            .hyperLocalShopModel
                                                            .id,
                                                        lat: customerModel.lat,
                                                        lng: customerModel.lng),
                                                  );
                                              _textEditingController.clear();
                                            },
                                            child: const Icon(Icons.cancel),
                                          )
                                        : state is HyperLocalGetSearchProductsOfShopErrorState
                                            ? GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<
                                                          HyperlocalShopBloc>()
                                                      .add(
                                                        HyperLocalGetSearchProductsClearEvent(
                                                            shopId: widget
                                                                .hyperLocalShopModel
                                                                .id,
                                                            lat: customerModel
                                                                .lat,
                                                            lng: customerModel
                                                                .lng),
                                                      );
                                                  _textEditingController
                                                      .clear();
                                                },
                                                child: const Icon(Icons.cancel),
                                              )
                                            : const Text(''),
                                    prefixIcon: GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            productNameLocal =
                                                _textEditingController.text;
                                          },
                                        );
                                        context.read<HyperlocalShopBloc>().add(
                                              HyperLocalGetSearchProductsOfShopEvent(
                                                shopId: widget
                                                    .hyperLocalShopModel.id,
                                                productName:
                                                    _textEditingController.text,
                                                lat: customerModel.lat,
                                                lng: customerModel.lng,
                                              ),
                                            );
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 9.0),
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
                              height: 5,
                            ),
                            state is HyperLocalGetSearchProductsOfShopState
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${RepositoryProvider.of<HyperLocalRepository>(context).searchItemCount} items available',
                                      ),
                                    ),
                                  )
                                : productWidgets.isEmpty
                                    ? const Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '0 items available',
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${RepositoryProvider.of<HyperLocalRepository>(context).itemCount} items available',
                                          ),
                                        ),
                                      ),
                            state is HyperLocalGetSearchProductsOfShopState
                                ? searchWidgets.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          'Unfortunately there are no product with the search term.Please try to search for something different',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.54,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 20),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 4,
                                              mainAxisSpacing: 13,
                                              childAspectRatio: 1.0,
                                              children: [
                                                ...searchWidgets,
                                                // _searchLoading
                                                //     ? const Align(
                                                //         alignment: Alignment.center,
                                                //         child: CircularProgressIndicator(),
                                                //       )
                                                //     : const SizedBox(height: 60)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                : productWidgets.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          'Unfortunately there are no product with the search term.Please try to search for something different',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.54,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 20),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 4,
                                              mainAxisSpacing: 13,
                                              childAspectRatio: 1.0,
                                              children: [
                                                ...productWidgets,
                                                // _searchLoading
                                                //     ? const Align(
                                                //         alignment: Alignment.center,
                                                //         child: CircularProgressIndicator(),
                                                //       )
                                                //     : const SizedBox(height: 60)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
