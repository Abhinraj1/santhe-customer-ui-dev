// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of product_long_description_view;

class _ProductLongDescriptionMobile extends StatefulWidget {
  ProductOndcModel productOndcModel;

  _ProductLongDescriptionMobile({required this.productOndcModel});

  @override
  State<_ProductLongDescriptionMobile> createState() =>
      _ProductLongDescriptionMobileState();
}

class _ProductLongDescriptionMobileState
    extends State<_ProductLongDescriptionMobile> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: AppColors().brandDark,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.productOndcModel.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors().brandDark,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '${widget.productOndcModel.long_description}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              widget.productOndcModel.generic_name != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Generic Name: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            '${widget.productOndcModel.generic_name}',
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.net_quantity != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Net Quantity: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            '${widget.productOndcModel.net_quantity}',
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.packer_name != null ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const AutoSizeText(
                      'Manufacturer name : ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      widget.productOndcModel.packer_name ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ) :
              SizedBox(),

              widget.productOndcModel.packer_address != null ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const AutoSizeText(
                      'Manufacturer Address : ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(
                      width: 200,
                      child: AutoSizeText(
                        widget.productOndcModel.packer_address ?? "",
                        style: const TextStyle(
                        fontSize: 15,
                      ),
                      ),
                    ),
                  ],
                ),
              ):
              SizedBox(),

              widget.productOndcModel.nutritional_info != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Nutritional Info: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            widget.productOndcModel.nutritional_info,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.additives_info != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Additives Info: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            widget.productOndcModel.additives_info,
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.brand_owner_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Brand Owner FSSAI LICENSE NUMBER: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            widget
                                .productOndcModel.brand_owner_FSSAI_license_no,
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.other_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Other FSSAI License Number: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            widget.productOndcModel.other_FSSAI_license_no,
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.importer_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const AutoSizeText(
                            'Importer FSSAI License Number: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            widget.productOndcModel.importer_FSSAI_license_no,
                            style:  const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
            ],
          ),
        ));
  }
}
