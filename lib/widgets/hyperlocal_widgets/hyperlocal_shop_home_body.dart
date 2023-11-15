import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/cubits/hyperlocal_shopDetails_cubit/hyperlocal_shop_details_cubit.dart';
import 'package:santhe/utils/get_screen_dimensions.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_shopDetails_cartIcon.dart';
import '../../core/repositories/address_repository.dart';
import '../../core/repositories/hyperlocal_repository.dart';
import '../../manager/font_manager.dart';
import '../../manager/imageManager.dart';
import '../../models/hyperlocal_models/hyperlocal_shopmodel.dart';
import '../../utils/firebase_analytics_custom_events.dart';
import '../navigation_drawer_widget.dart';
import 'hyperlocal_productwidget.dart';


class HyperLocalShopDetailsScreen extends StatefulWidget {
  final HyperLocalShopModel hyperLocalShopModel;
  final String? searchItem;

  const HyperLocalShopDetailsScreen({Key? key,
    required this.hyperLocalShopModel,
    this.searchItem}) :super(key: key);

  @override
  State<HyperLocalShopDetailsScreen> createState() => _HyperLocalShopDetailsScreenState();
}

class _HyperLocalShopDetailsScreenState extends State<HyperLocalShopDetailsScreen> {
  dynamic homeDeliveryGlo;
  final ScrollController _controller = ScrollController();
  final ScrollController _parentController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHomeDelivery();
    _initFunction();
   _handleScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        drawer: const CustomNavigationDrawer(),
      backgroundColor: CupertinoColors.systemBackground,
        appBar: AppBar(
          backgroundColor: AppColors().brandDark,
          elevation: 10.0,
          title:  AutoSizeText(
              "Santhe",
              style: FontStyleManager().kAppNameStyle
          ),
          leading: IconButton(
            onPressed: () async {
              _scaffoldKey.currentState!.openDrawer();
            },
            splashRadius: 25.0,
            icon: SvgPicture.asset(
              ImgManager().drawerIcon,
              color: Colors.white,
            ),
          ),
          shadowColor: AppColors().appBarShadow,
        ),
         resizeToAvoidBottomInset: true,
        body: CustomScrollView(
        controller: _parentController,
          slivers: [
            SliverToBoxAdapter(
                child:
                Stack(
                  children: [
                    Container(
                      width: getScreenDimensions(context: context).width,
                      height: widget.hyperLocalShopModel.address
                          .toString()
                          .length >
                          75
                          ? 215
                          : 195,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/bannerondc.png",
                              ),
                              fit: BoxFit.fill)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 48,
                          ),
                          AutoSizeText(
                            '${widget.hyperLocalShopModel.name}',
                            minFontSize: 16,
                            style: TextStyle(
                              color: AppColors().white100,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          widget.hyperLocalShopModel.address ==
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
                            child: SizedBox(
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.9,
                              child: Center(
                                child: Text(
                                  '${widget.hyperLocalShopModel.address}',
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
                          widget.hyperLocalShopModel.phone_number ==
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
                                  '${widget.hyperLocalShopModel.phone_number}',
                                  style: TextStyle(
                                    color: AppColors()
                                        .white100,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/emailpng.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  AutoSizeText(
                                    '${widget.hyperLocalShopModel.email}',
                                    textAlign:
                                    TextAlign.center,
                                    minFontSize: 10,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: AppColors()
                                          .white100,
                                      fontSize: 13,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, bottom: 3),
                            child: AutoSizeText(
                              homeDeliveryGlo == true
                                  ? "Home Delivery Available"
                                  : "No Home Delivery",
                              minFontSize: 10,
                              style: TextStyle(
                                color: AppColors().white100,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: getScreenDimensions(
                          context: context,
                          horizontalPadding: 10).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBackButton(
                          invertColors: true,leftPadding: 5,onTap: _handleBack),
                          HyperLocalShopDetailsCartIcon(
                              id: widget.hyperLocalShopModel.id)
                        ],
                      ),
                    ),
                  ],
                )
            ),

            SliverToBoxAdapter(
                child: ProductSearchTextField(
                  searchItem: widget.searchItem,
                  storeId: widget.hyperLocalShopModel.id,
                storeName: widget.hyperLocalShopModel.name.toString(),)
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Obx(
                           () {
                             if(loadingItemCount.value){
                               return Text("Loading....",
                                 style: FontStyleManager().s14fw600Grey,);
                             }else {
                               return Text("${hyperLocalProductsCount
                                   .value} items available",
                                 style: FontStyleManager().s14fw600Grey,);
                             }
                           }
                        ),
                      )
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: getScreenDimensions(context: context,verticalPadding: 230).height,
                child: BlocBuilder<HyperlocalShopDetailsCubit,
                    HyperlocalShopDetailsState>(
                  builder: (context, state) {


                    if(state is HyperlocalShopDetailsInitial){
                      shopProducts = [];
                      shopListOffset.value = 0;

                      _initFunction();

                    }if(state is HyperlocalShopDetailsProductsLoaded ||
                        state is HyperlocalShopDetailsSearchedProductsLoaded){

                      if(state is HyperlocalShopDetailsProductsLoaded){
                        shopProducts = [];
                        shopProducts.addAll(state.shopProducts);
                      }if(state is HyperlocalShopDetailsSearchedProductsLoaded){
                        searchedShopProducts = [];
                        searchedShopProducts.addAll(state.searchedShopProducts);
                      }
                      int count = _calculateCount(state: state);

                      if(state is HyperlocalShopDetailsSearchedProductsLoaded
                      && searchedShopProducts.isEmpty){
                       return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                          child: Text(
                            "Unfortunately, there are no product you are looking for. "
                                "Please try to search for something different.",
                            style: FontStyleManager().s14fw700Orange,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }else{
                        return GridView.builder(
                            controller: _controller,
                            // physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemCount: count,
                            itemBuilder: (BuildContext ctx, index) {
                              if(index == count-1){
                                return
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Obx(
                                              () {
                                            if(loadingNewProducts.value){
                                              return const Center(
                                                  child: CircularProgressIndicator());
                                            }else{
                                           if(shopProducts.length-1 == index ||
                                               searchedShopProducts.length-1 == index){
                                             return HyperLocalProductWidget(
                                               hyperLocalProductModel: state is HyperlocalShopDetailsProductsLoaded ?
                                               shopProducts[index] : searchedShopProducts[index],
                                             );
                                           }else{
                                             return const SizedBox();
                                           }

                                            }
                                          }
                                      )
                                  );

                              }else{
                                return HyperLocalProductWidget(
                                  hyperLocalProductModel: state is HyperlocalShopDetailsProductsLoaded ?
                                  shopProducts[index] : searchedShopProducts[index],

                                );
                              }
                            });
                      }
                    }else{
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 300,
                             height: 100,
                            child: Center(
                                child: CircularProgressIndicator()
                            )
                        ),
                      );
                    }
                  },
                ),
              ),
            )


            // Row(
            //   children: [
            //     // HyperLocalProductWidget(
            //     //   hyperLocalProductModel: HyperLocalProductModel(id: "sdfg",),
            //     // )
            //   ],
            // )
          ],
        )
    );
  }

 int _calculateCount({required HyperlocalShopDetailsState state}){
    if(state is HyperlocalShopDetailsProductsLoaded){
      if(shopProducts.isNotEmpty){
        if(loadingNewProducts.value){
          return shopProducts.length+1;
        }else{
          return shopProducts.length;
        }
      }else{
        return 0;
      }
    }else{
      if(loadingNewProducts.value){
        return searchedShopProducts.length+1;
      }else{
        return searchedShopProducts.length;
      }
    }
  }

  _handleBack() {
    Get.back();
  }

  _handleScroll() {
    _controller.addListener(() {

      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {


        if (!fetchingProducts.value) {
          loadingNewProducts.value = true;
          print("============================================ "
              "fetchingProducts.value = ${fetchingProducts.value}");
          fetchingProducts.value = true;

          BlocProvider.of<HyperlocalShopDetailsCubit>(context).onScroll(
              load: true,
              searchOffset: searchShopListOffset.value,
              offset: shopListOffset.value,
              productList: shopProducts,
              searchedProductList: searchedShopProducts,
              storeId: widget.hyperLocalShopModel.id,
              lat: RepositoryProvider
                  .of<AddressRepository>(
                  context)
                  .deliveryModel
                  ?.lat,
              lng: RepositoryProvider
                  .of<AddressRepository>(
                  context)
                  .deliveryModel
                  ?.lng
          );
        }
      }
      if(_controller.position.pixels == 0){
        _parentController.jumpTo(_parentController.position.minScrollExtent,);
      }
      else{
        _parentController.jumpTo(_parentController.position.maxScrollExtent,);
      }
    });
  }

  _initFunction() {
    searchShopListOffset.value =0;
    shopListOffset.value = 0;

    AnalyticsCustomEvents().userViewedShopDetailsScreen(
        shopName: widget.hyperLocalShopModel.name.toString());


   if(widget.searchItem == null){
     BlocProvider.of<HyperlocalShopDetailsCubit>(context).getProducts(
         load: true,
         offset: shopListOffset.value,
         productList: [],
         storeId: widget.hyperLocalShopModel.id,
         lat: RepositoryProvider
             .of<AddressRepository>(
             context)
             .deliveryModel
             ?.lat,
         lng: RepositoryProvider
             .of<AddressRepository>(
             context)
             .deliveryModel
             ?.lng
     );
   }
  }

  getHomeDelivery() {

    final homeDelivery =
    json.decode(widget.hyperLocalShopModel.fulfillment_type.toString());
    print('Home Delivery $homeDelivery');
    homeDeliveryGlo = homeDelivery['home_delivery'];
    print('HomeDeliveryFormatted $homeDeliveryGlo');
  }
}



class ProductSearchTextField extends StatefulWidget {
  final String storeId;
  final String storeName;
  final String? searchItem;
  const ProductSearchTextField(
      {Key? key, required this.storeId, this.searchItem, required this.storeName})
      : super(key: key);

  @override
  State<ProductSearchTextField> createState() => _ProductSearchTextFieldState();
}

class _ProductSearchTextFieldState extends State<ProductSearchTextField> {
  final TextEditingController _textEditingController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.searchItem != null){
      _textEditingController.text = widget.searchItem.toString();

      AnalyticsCustomEvents().userSearchShopDetailsScreen(
          searchedProduct: widget.searchItem.toString(),
      shopName: widget.storeName);

      _handleSearch();
    }
  }
  @override
  Widget build(BuildContext context) {

    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
        child: BlocBuilder<HyperlocalShopDetailsCubit, HyperlocalShopDetailsState>(
          builder: (context, state) {
            return TextField(
              controller: _textEditingController,
              style: FontStyleManager().s16fw700Brown,
              decoration: InputDecoration(
                labelText: 'Search Products here',
                labelStyle: FontStyleManager().s16fw500,
                isDense: true,
                focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 2,
                        color: AppColors().brandDark
                    )),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:   BorderSide(
                      width: 2,
                      color:AppColors().grey60),
                ),

                suffixIcon:
                state
                is HyperlocalShopDetailsSearchedProductsLoaded
                    ? GestureDetector(
                  onTap: () {
                    _handleClose();
                  },
                  child: const Icon(
                      Icons.cancel),
                )
                    : null,
                prefixIcon: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                      vertical: 9.0),
                  child: InkWell(
                    onTap: () {
                      _handleSearch();
                    },
                    child: const Icon(
                      CupertinoIcons
                          .search_circle_fill,
                      size: 32,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),onSubmitted: (value){
              _handleSearch();
            },);
          },
        ),
      );
  }
  _handleClose(){

    searchShopListOffset.value = 0;

    BlocProvider.of<HyperlocalShopDetailsCubit>(context).getProducts(
        load: true,
        offset: 0,
        productList: [],
        lat: RepositoryProvider
            .of<AddressRepository>(
            context)
            .deliveryModel
            ?.lat,
        lng: RepositoryProvider
            .of<AddressRepository>(
            context)
            .deliveryModel
            ?.lng, storeId: widget.storeId
    );

    // setState(() {
    //   _searchedLoaded = false;
    // });

    _textEditingController
        .clear();

    searchedShopProducts = [];
  }

  _handleSearch(){

    if(_textEditingController
        .text.isNotEmpty){

      BlocProvider.of<HyperlocalShopDetailsCubit>(context).searchProducts(
          load: true,
       searchOffset: 0,
          searchedProductList: [],
          itemName: _textEditingController.text.trim(),
          lat: RepositoryProvider
              .of<AddressRepository>(
              context)
              .deliveryModel
              ?.lat,
          lng: RepositoryProvider
              .of<AddressRepository>(
              context)
              .deliveryModel
              ?.lng,
          storeId: widget.storeId
      );

    }else{
      _handleClose();
    }
  }
}



