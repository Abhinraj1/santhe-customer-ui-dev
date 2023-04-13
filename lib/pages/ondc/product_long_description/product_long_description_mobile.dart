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
              color: Colors.transparent,
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
                  color: Colors.transparent,
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
              const Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
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
                        color: Colors.black, fontWeight: FontWeight.bold),
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
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Generic Name : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.generic_name}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.net_quantity != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Net quantity : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.net_quantity}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.packer_name != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Manufacturer Name: ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.packer_name}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const SizedBox(),
              widget.productOndcModel.packer_address != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Manufacturer Address : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.packer_address}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const SizedBox(),
              widget.productOndcModel.nutritional_info != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Nutritional Info : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.nutritional_info}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.additives_info != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Additives Info : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.additives_info}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.brand_owner_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Brand Owner FSSAI License Number : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.brand_owner_FSSAI_license_no}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.other_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Other FSSAI License Number : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.other_FSSAI_license_no}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
              widget.productOndcModel.importer_FSSAI_license_no != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              text: 'Importer FSSAI license Number : ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.productOndcModel.importer_FSSAI_license_no}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                    )
                  : const Text(''),
            ],
          ),
        ));
  }
}
