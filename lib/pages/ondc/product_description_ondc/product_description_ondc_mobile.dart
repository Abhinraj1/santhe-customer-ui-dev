// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously
part of product_description_ondc_view;

class _ProductDescriptionOndcMobile extends StatefulWidget {
  final ProductOndcModel productOndcModel;
  int value;
  _ProductDescriptionOndcMobile({
    Key? key,
    required this.productOndcModel,
    required this.value,
  }) : super(key: key);

  @override
  State<_ProductDescriptionOndcMobile> createState() =>
      _ProductDescriptionOndcMobileState();
}

class _ProductDescriptionOndcMobileState
    extends State<_ProductDescriptionOndcMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentPage = 0;
  List<OndcProductCarouselImage> images = [];
  Map<String, ProductOndcModel> productModels = {};
  bool _addedToCart = false;
  List<OndcCartItem> cartWidget = [];
  String cancellable = 'No';
  String returnable = 'No';
  int cartCount = 0;

  bool isSameValue = false;
  buildPageIndicator() {
    List<Widget> list = [];
    bool hasImages;
    if (widget.productOndcModel.images == null) {
      hasImages = false;
    } else {
      hasImages = true;
    }
    if (hasImages) {
      for (int i = 0; i < widget.productOndcModel.images!.length; i++) {
        list.add(i == currentPage ? _indicator(true) : _indicator(false));
      }
      return list;
    } else {
      return _indicator(true);
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
    for (var i = 0; i < widget.productOndcModel.images!.length; i++) {
      final string = widget.productOndcModel.images![i]['image_url'];
      images.add(
        OndcProductCarouselImage(imageUrl: string),
      );
    }
  }

  void add() {
    setState(() {
      widget.productOndcModel.add();
    });
  }

  void minus() {
    setState(() {
      widget.productOndcModel.minus();
    });
  }

  checkValue() {
    if (widget.productOndcModel.maximum_value !=
        widget.productOndcModel.value) {
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
    if (widget.productOndcModel.returnable == true) {
      setState(() {
        returnable = 'Yes';
      });
    } else {
      setState(() {
        returnable = 'No';
      });
    }
  }

  yesNoCancellable() {
    if (widget.productOndcModel.cancellable == true) {
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
    widget.value = 1;
    widget.productOndcModel.quantity = 1;
    cartCount =
        RepositoryProvider.of<OndcRepository>(context).totalCartItemCount;
    getImages();
    checkValue();
    yesNoCancellable();
    yesNoReturnable();
  }

  @override
  Widget build(BuildContext context) {
    warningLog('${widget.productOndcModel.cancellable}');
    final cart = RepositoryProvider.of<OndcCartRepository>(context);
    debugLog('cartCount ${widget.productOndcModel}');
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
                Get.back(result: widget.value);
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
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) async {
          warningLog('$state');
          if (state is AddedToCartList) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to Cart'),
              ),
            );
            await RepositoryProvider.of<OndcRepository>(context)
                .getCartCountMethod(
              storeLocation_id: widget.productOndcModel.storeLocationId,
            );
            setState(() {
              cartCount =
                  RepositoryProvider.of<OndcRepository>(context).cartCount;
            });
            context.read<CartBloc>().add(ResetCartEvent());
            // context.read<CartBloc>().add(
            //       UpdateCartEvent(productOndcModels: state.productOndcModels),
            //     );
          }
          if (state is ResetCartState) {
            await RepositoryProvider.of<OndcRepository>(context)
                .getCartCountMethod(
              storeLocation_id: widget.productOndcModel.storeLocationId,
            );
            setState(() {
              cartCount =
                  RepositoryProvider.of<OndcRepository>(context).cartCount;
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back(result: widget.value);
                        },
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: AppColors().brandDark,
                          size: 30,
                        ),
                      ),
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
                                  OndcCartView(
                                    storeLocation_id:
                                        widget.productOndcModel.storeLocationId,
                                  ),
                                )?.then((_) {
                                  setState(() {
                                    widget.productOndcModel.quantity;
                                  });
                                });

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
                            '₹ ${widget.productOndcModel.value.toString()}',
                            style: TextStyle(
                                color: AppColors().brandDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        : Row(
                            children: [
                              Text(
                                '₹ ${widget.productOndcModel.maximum_value}',
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
                                '₹ ${widget.productOndcModel.value.toString()}',
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
                      '${widget.productOndcModel.name}',
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
                    widget.productOndcModel.isAddedToCart!
                        ? const Text('                          ')
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10),
                            child: Container(
                              width: 160,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.white,
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
                                      ' ${widget.productOndcModel.quantity}',
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
                    widget.productOndcModel.isAddedToCart == true
                        ? Container(
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
                                'Go to cart',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (widget.productOndcModel.available >= 1) {
                                context.read<CartBloc>().add(
                                      AddToCartEvent(
                                        productOndcModel:
                                            widget.productOndcModel,
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
                                color: widget.productOndcModel.available > 0
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
                                  'Add To Cart',
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
                  child: widget.productOndcModel.available == 0
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
                            'No of items available : ${widget.productOndcModel.available}',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15),
                          ),
                        ),
                ),
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
                    child: ExpandableText(
                      '${widget.productOndcModel.long_description}',
                      trimLines: 5,

                      callback: () => Get.to(
                        () => ProductLongDescriptionView(
                          productOndcModel: widget.productOndcModel,
                        ),
                      ),
                      // callback: (val) {
                      //   Get.to(
                      //     () => ProductLongDescriptionView(
                      //       productOndcModel: widget.productOndcModel,
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
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Delivery By: ${widget.productOndcModel.time_to_ship}',
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
                      'Cancellable:  ${cancellable.toString().toUpperCase()}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Returnable:   ${returnable.toString().toUpperCase()}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.productOndcModel.returnable
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Returnable:   ${returnable.toString().toUpperCase()}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'Return picked up by seller : ${widget.productOndcModel.seller_pickup_return}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              )
                            ],
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
