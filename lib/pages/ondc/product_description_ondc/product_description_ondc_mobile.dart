// ignore_for_file: public_member_api_docs, sort_constructors_first
part of product_description_ondc_view;

class _ProductDescriptionOndcMobile extends StatefulWidget {
  final ProductOndcModel productOndcModel;
  const _ProductDescriptionOndcMobile({
    Key? key,
    required this.productOndcModel,
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

  buildPageIndicator() {
    List<Widget> list = [];
    if (widget.productOndcModel.images!.isNotEmpty) {
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
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors().brandDark : AppColors().brandLight,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  getImages() {
    if (widget.productOndcModel.images!.isNotEmpty) {
      for (var i = 0; i < widget.productOndcModel.images!.length; i++) {
        final string = widget.productOndcModel.images![i]['image_url'];
        images.add(
          OndcProductCarouselImage(imageUrl: string),
        );
      }
    } else {
      return images.add(
        OndcProductCarouselImage(imageUrl: widget.productOndcModel.symbol),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    warningLog('${widget.productOndcModel.images}');
    return Scaffold(
      key: _key,
      drawer: const NavigationDrawer(),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CarouselSlider(
              items: images,
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                child: Text(
                  'Rs ${widget.productOndcModel.value.toString()}',
                  style: TextStyle(
                      color: AppColors().brandDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.productOndcModel.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20),
                  child: Container(
                    width: 160,
                    height: 45,
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.remove),
                        ),
                        const VerticalDivider(),
                        const Text('0'),
                        const VerticalDivider(),
                        GestureDetector(
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors().brandDark,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.productOndcModel.long_description,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
