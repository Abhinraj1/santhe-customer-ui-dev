// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
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
  GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentPage = 0;
  List<OndcProductCarouselImage> images = [];
  Map<String, ProductOndcModel> productModels = {};
  bool _addedToCart = false;
  List<OndcCartItem> cartWidget = [];
  String cancellable = 'No';
  String returnable = 'No';

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

  yesNoCancellable() {
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

  yesNoReturnable() {
    if (widget.productOndcModel.return_window == true) {
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
    getImages();
    checkValue();
    yesNoCancellable();
    yesNoReturnable();
  }

  @override
  Widget build(BuildContext context) {
    // warningLog('${widget.productOndcModel.maximum}');
    final cart = RepositoryProvider.of<OndcCartRepository>(context);
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
        listener: (context, state) {
          // warningLog('$state');
          if (state is AddedToCartList) {
            context.read<CartBloc>().add(
                  UpdateCartEvent(productOndcModels: state.productOndcModels),
                );
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
                          GestureDetector(
                            onTap: () async {
                              await Get.to(
                                OndcCartView(
                                  storeLocation_id:
                                      widget.productOndcModel.storeLocationId,
                                ),
                              );
                              setState(() {
                                widget.productOndcModel.quantity;
                              });
                            },
                            child: Image.asset(
                              'assets/newshoppingcartorange.png',
                              height: 35,
                              width: 35,
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
                                    color: AppColors().brandDark,
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
                    Padding(
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
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            productOndcModel: widget.productOndcModel),
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
                      'Returnable:   ${cancellable.toString().toUpperCase()}',
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
