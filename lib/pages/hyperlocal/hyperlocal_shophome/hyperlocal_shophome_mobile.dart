// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
part of hyperlocal_shophome_view;

class _HyperlocalShophomeMobile extends StatefulWidget {
  final String lat;
  final String lng;
  const _HyperlocalShophomeMobile({
    required this.lat,
    required this.lng,
  });

  @override
  State<_HyperlocalShophomeMobile> createState() =>
      _HyperlocalShophomeMobileState();
}

class _HyperlocalShophomeMobileState extends State<_HyperlocalShophomeMobile>
    with LogMixin {
  CustomerModel? customerModel;
  String flat = '';
  String? lat;
  String? lng;
  NetworkCall networkcall = NetworkCall();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  List<HyperLocalShopWidget> shopWidgets = [];
  List<HyperLocalShopWidget> searchWidgets = [];
  List<HyperLocalShopModel> shopModels = [];
  List<HyperLocalShopModel> searchModels = [];
  List<HyperLocalShopModel> existingShopModels = [];
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(
          GetAddressListEvent(),
        );
    context
        .read<HyperlocalShopBloc>()
        .add(HyperLocalGetShopEvent(lat: widget.lat, lng: widget.lng));
  }

  getCustomerInfo() async {
    customerModel = await networkcall.getCustomerDetails();
    setState(() {
      lat = customerModel!.lat;
      lng = customerModel!.lng;
    });
    errorLog('$lat and lng $lng');
  }

  @override
  Widget build(BuildContext context) {
    debugLog(
        '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}');
    return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
      listener: (context, state) {
        warningLog('Current State $state');
        if (state is HyperLocalGetShopsState) {
          List<HyperLocalShopWidget> localShops = [];
          shopModels = [];
          shopWidgets = [];
          shopModels = state.hyperLocalShopModels;
          warningLog('${shopModels.length}');
          for (var element in shopModels) {
            localShops.add(
              HyperLocalShopWidget(hyperLocalShopModel: element),
            );
          }
          warningLog('$localShops');
          setState(() {
            shopWidgets = localShops;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                    // if (Platform.isIOS) {
                    //   Share.share(
                    //     AppHelpers().appStoreLink,
                    //   );
                    // } else {
                    //   Share.share(
                    //     AppHelpers().playStoreLink,
                    //   );
                    // }
                    /// ge.Get.back();
                    Get.to(OndcCheckOutScreenMobile());
                  },
                  splashRadius: 25.0,
                  icon: InkWell(
                    onTap: () {
                      Get.to(
                        () => OndcIntroView(),
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
          body: state is HyperLocalGetLoadingState
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        'Getting Hyperlocal shops near you',
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
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const MapTextView(),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  color: CupertinoColors.systemBackground,
                                  height: MediaQuery.of(context).size.height *
                                      0.125,
                                  width: 340,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 25,
                                    ),
                                    child:
                                        BlocConsumer<AddressBloc, AddressState>(
                                      listener: (context, state) {
                                        errorLog(
                                            'Address Bloc in hyperLocal$state');
                                        if (state is GotAddressListAndIdState) {
                                          setState(() {
                                            flat = RepositoryProvider.of<
                                                    AddressRepository>(context)
                                                .deliveryModel
                                                ?.flat;
                                          });
                                        }
                                      },
                                      builder: (context, state) {
                                        return Text.rich(
                                          TextSpan(
                                            text: 'Delivery to: ',
                                            style:
                                                const TextStyle(fontSize: 15),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
                                                // widget
                                                //     .customerModel.address
                                                //     .substring(0, 25),

                                                style: const TextStyle(
                                                  decorationColor:
                                                      Color.fromARGB(
                                                          255, 77, 81, 84),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //! add the indicator here
                            // GestureDetector(
                            //   onTap: () => ge.Get.to(
                            //     OndcCartView(),
                            //   ),
                            //   child: Stack(
                            //     children: [
                            //       Image.asset(
                            //         'assets/newshoppingcartorange.png',
                            //         height: 45,
                            //         width: 45,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20, top: 5),
                              child: Image.asset('assets/edit.png'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 1),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: _textEditingController,
                            onFieldSubmitted: (value) {
                              // context.read<OndcBloc>().add(
                              //       FetchListOfShopWithSearchedProducts(
                              //         productName: _textEditingController.text
                              //             .toString(),
                              //       ),
                              //     );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search Products here',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              suffixIcon:
                                  state is HyperLocalSearchItemLoadedState
                                      ? GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   _searchedLoaded = false;
                                            // });
                                            // context.read<HyperlocalShopBloc>().add(
                                            //       ClearSearchEventShops(
                                            //           shopModels:
                                            //               existingShopModels),
                                            //     );
                                            // context
                                            //     .read<OndcBloc>()
                                            //     .add(
                                            //       FetchNearByShops(
                                            //         lat: widget
                                            //             .customerModel
                                            //             .lat,
                                            //         lng: widget
                                            //             .customerModel
                                            //             .lng,
                                            //         pincode: widget
                                            //             .customerModel
                                            //             .pinCode,
                                            //         isDelivery: widget
                                            //             .customerModel
                                            //             .opStats,
                                            //       ),
                                            //     );
                                            _textEditingController.clear();
                                          },
                                          child: const Icon(Icons.cancel),
                                        )
                                      : null,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9.0),
                                child: InkWell(
                                  onTap: () {
                                    // context.read<OndcBloc>().add(
                                    //       FetchListOfShopWithSearchedProducts(
                                    //         productName: _textEditingController
                                    //             .text
                                    //             .toString(),
                                    //       ),
                                    //     );
                                  },
                                  child: const Icon(
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
                      SizedBox(
                        height: 10,
                      ),
                      state is HyperLocalSearchItemLoadedState
                          ? Text('')
                          : Center(
                              child: Text(
                                'OR',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      // state is HyperLocalSearchItemLoadedState
                      //     ? searchWidgets.isEmpty
                      //         ? Text('')
                      //         : Padding(
                      //             padding:
                      //                 const EdgeInsets.only(
                      //                     left: 25.0),
                      //             child: Align(
                      //               alignment:
                      //                   Alignment.centerLeft,
                      //               child: Text(
                      //                   'Below are the shops that sell "${_textEditingController.text.toString().capitalizeFirst}"'),
                      //             ),
                      //           )
                      //     : Padding(
                      //         padding: const EdgeInsets.only(
                      //             left: 25.0),
                      //         child: Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Text(
                      //               'Browse your Local Shops'),
                      //         ),
                      //       ),
                      ...shopWidgets
                    ],
                  ),
                ),
        );
      },
    );
  }
}
