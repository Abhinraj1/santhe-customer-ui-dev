// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
part of hyperlocal_productdescription_view;

class _HyperlocalProductdescriptionMobile extends StatefulWidget {
  final HyperLocalProductModel hyperLocalProductModel;
  const _HyperlocalProductdescriptionMobile({
    required this.hyperLocalProductModel,
  });

  @override
  State<_HyperlocalProductdescriptionMobile> createState() =>
      _HyperlocalProductdescriptionMobileState();
}

class _HyperlocalProductdescriptionMobileState
    extends State<_HyperlocalProductdescriptionMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentPage = 0;
  List<OndcProductCarouselImage> images = [];
  bool _addedToCart = false;
  String cancellable = 'No';
  String returnable = 'No';
  String sellerPickupReturn = "No";
  int cartCount = 0;

  bool isSameValue = false;
  buildPageIndicator() {
    List<Widget> list = [];
    bool hasImages;
    if (widget.hyperLocalProductModel.images == null) {
      hasImages = false;
    } else {
      hasImages = true;
    }
    if (hasImages) {
      for (int i = 0; i < widget.hyperLocalProductModel.images!.length; i++) {
        list.add(i == currentPage ? _indicator(true) : _indicator(false));
      }
      return list;
    } else {
      return list;
    }
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      height: isActive ? 8.0 : 5.0,
      width: isActive ? 8.0 : 5.0,
      decoration: BoxDecoration(
          color: isActive ? AppColors().brandDark : AppColors().brandLight,
          shape: BoxShape.circle
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(12),
          // ),
          ),
    );
  }

  getImages() {
    if (widget.hyperLocalProductModel.images != null) {
      debugLog(
          'Checking for images length${widget.hyperLocalProductModel.images.length}');
      for (var i = 0; i < widget.hyperLocalProductModel.images!.length; i++) {
        final string = widget.hyperLocalProductModel.images![i]['image_url'];
        // errorLog('Image String $string');
        images.add(
          OndcProductCarouselImage(imageUrl: string),
        );
      }
    }
  }

  void add() {
    setState(() {
      widget.hyperLocalProductModel.add();
    });
  }

  void minus() {
    setState(() {
      widget.hyperLocalProductModel.minus();
    });
  }

  checkValue() {
    if (widget.hyperLocalProductModel.mrp !=
        widget.hyperLocalProductModel.offer_price) {
      setState(() {
        isSameValue = false;
      });
    } else {
      setState(() {
        isSameValue = true;
      });
    }
  }

  yesNoReturnable() {
    if (widget.hyperLocalProductModel.returnable == true) {
      setState(() {
        returnable = 'Yes';
      });
    } else {
      setState(() {
        returnable = 'No';
      });
    }
  }

  yesNoSellerPickUpReturn() {
    if (widget.hyperLocalProductModel.return_pickup == true) {
      setState(() {
        sellerPickupReturn = 'Yes';
      });
    } else {
      setState(() {
        sellerPickupReturn = 'No';
      });
    }
  }

  yesNoCancellable() {
    if (widget.hyperLocalProductModel.cancellable == true) {
      setState(() {
        cancellable = 'Yes';
      });
    } else {
      setState(() {
        cancellable = 'No';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // widget.value = 1;
    widget.hyperLocalProductModel.quantity = 1;
    cartCount = RepositoryProvider.of<HyperLocalRepository>(context)
        .cartTotalCountLocal;
    getImages();
    checkValue();
    yesNoCancellable();
    yesNoReturnable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const nv.CustomNavigationDrawer(),
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
              fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {
                Get.back();
                // if (Platform.isIOS) {
                //   Share.share(
                //     AppHelpers().appStoreLink,
                //   );
                // } else {
                //   Share.share(
                //     AppHelpers().playStoreLink,
                //   );
                // }
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
      body: BlocConsumer<HyperlocalCartBloc, HyperlocalCartState>(
        listener: (context, state) async {
          debugLog('State check $state');
          if (state is AddToCartHyperLocalState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to Cart'),
              ),
            );
            await RepositoryProvider.of<HyperLocalRepository>(context)
                .getCartCount(
                    storeDescriptionId:
                        widget.hyperLocalProductModel.storeDescriptionId);
            setState(() {
              cartCount = RepositoryProvider.of<HyperLocalRepository>(context)
                  .cartTotalCountLocal;
            });
            context.read<HyperlocalCartBloc>().add(ResetHyperCartEvent());
          }
          if (state is ResetHyperLocalCartState) {
            await RepositoryProvider.of<HyperLocalRepository>(context)
                .getCartCount(
                    storeDescriptionId:
                        widget.hyperLocalProductModel.storeDescriptionId);
            setState(() {
              cartCount = RepositoryProvider.of<HyperLocalRepository>(context)
                  .cartTotalCountLocal;
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButton(leftPadding: 5),

                      //! Navigation not allowed for now due to shopmodel trouble
                      Stack(
                        children: [
                          badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: 0, end: 2),
                            badgeAnimation: const badges.BadgeAnimation.slide(),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: AppColors().white100,
                            ),
                            showBadge: true,
                            badgeContent: Text(
                              '$cartCount',
                              style: TextStyle(color: AppColors().brandDark),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await Get.to(
                                  HyperlocalCartView(
                                    storeDescriptionId: widget
                                        .hyperLocalProductModel
                                        .storeDescriptionId,
                                  ),
                                )?.then(
                                  (_) {
                                    setState(() {
                                      widget.hyperLocalProductModel.quantity;
                                    });
                                  },
                                );

                                warningLog('something');
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors().brandDark,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                        ],
                      )
                    ],
                  ),
                ),
                CarouselSlider(
                  items: images,
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    initialPage: currentPage,
                    onPageChanged: (index, reason) {
                      warningLog('$index');
                      setState(() {
                        currentPage = index;
                      });
                    },
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildPageIndicator(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: isSameValue
                        ? Text(
                            '₹ ${widget.hyperLocalProductModel.offer_price.toString()}',
                            style: TextStyle(
                                color: AppColors().brandDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        : Row(
                            children: [
                              Text(
                                '₹ ${widget.hyperLocalProductModel.mrp}',
                                style: TextStyle(
                                    color: AppColors().grey100,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '₹ ${widget.hyperLocalProductModel.offer_price.toString()}',
                                style: TextStyle(
                                    color: AppColors().brandDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.hyperLocalProductModel.name}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    widget.hyperLocalProductModel.isAddedToCart!
                        ? const Text('                          ')
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10),
                            child: Container(
                              width: 160,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: add,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                    ),
                                    Text(
                                      ' ${widget.hyperLocalProductModel.quantity}',
                                      style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    GestureDetector(
                                      onTap: minus,
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    widget.hyperLocalProductModel.isAddedToCart == true
                        ? GestureDetector(
                            onTap: () async {
                              await Get.to(
                                HyperlocalCartView(
                                  storeDescriptionId: widget
                                      .hyperLocalProductModel
                                      .storeDescriptionId,
                                ),
                              )?.then((_) {
                                setState(() {
                                  widget.hyperLocalProductModel.quantity;
                                });
                              });

                              warningLog('something');
                            },
                            child: Container(
                              width: 160,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors().white100,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors().brandDark,
                                    offset: Offset(0, 1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'GO TO CART',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (widget.hyperLocalProductModel.inventory >=
                                  1) {
                                context.read<HyperlocalCartBloc>().add(
                                      AddToCartHyperLocalEvent(
                                        hyperLocalProductModel:
                                            widget.hyperLocalProductModel,
                                      ),
                                    );
                                setState(() {
                                  _addedToCart = true;
                                });
                                debugLog('Count$cartCount');
                              }
                            },
                            child: Container(
                              width: 160,
                              height: 45,
                              decoration: BoxDecoration(
                                color:
                                    widget.hyperLocalProductModel.inventory > 0
                                        ? AppColors().brandDark
                                        : AppColors().grey40,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: widget.hyperLocalProductModel.inventory == 0
                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No items available',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No of items available : ${widget.hyperLocalProductModel.inventory}',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15),
                          ),
                        ),
                ),
                widget.hyperLocalProductModel.description.toString() != "null"
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15, top: 15),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Description : ')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                child: ExpandableText(
                                    '${widget.hyperLocalProductModel.description}',
                                    trimLines: 5,
                                    callback: () {}
                                    // Get.to(
                                    //   () => ProductLongDescriptionView(
                                    //       hyperLocalProductModel:
                                    //           widget.hyperLocalProductModel),
                                    // ),
                                    // callback: (val) {
                                    //   Get.to(
                                    //     () => ProductLongDescriptionView(
                                    //       hyperLocalProductModel: widget.hyperLocalProductModel,
                                    //     ),
                                    //   );
                                    // },
                                    // style: const TextStyle(fontSize: 15),
                                    // colorClickableText: Colors.pink,
                                    // trimMode: TrimMode.Line,
                                    // trimCollapsedText: 'Show more',
                                    // trimExpandedText: 'Show less',
                                    // lessStyle: const TextStyle(
                                    //   fontSize: 14,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    // moreStyle: const TextStyle(
                                    //   fontSize: 14,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : const SizedBox(),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Delivery By: ${widget.hyperLocalProductModel.delivery_time}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //todo : cancellable field to be edited
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Cancellable:  ${cancellable.toString().capitalizeFirst}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                ///@Abhi
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 15.0),
                //     child: Text(
                //       'Returnable:   ${returnable.toString().toUpperCase()}',
                //       style: const TextStyle(fontSize: 15),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                widget.hyperLocalProductModel.returnable == true
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Returnable:   ${returnable.toString().capitalizeFirst}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Return picked up by seller : '
                                  '$sellerPickupReturn',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          );
        },
      ),
    );
  }
}
