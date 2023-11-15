import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/utils/get_screen_dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../core/blocs/address/address_bloc.dart';
import '../../../core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import '../../../core/cubits/hyperlocal_shoplist_cubit/hyperlocal_shoplist_cubit.dart';
import '../../../core/repositories/address_repository.dart';
import '../../../manager/font_manager.dart';
import '../../../network_call/network_call.dart';
import '../../../utils/firebase_analytics_custom_events.dart';
import '../../../widgets/custom_widgets/customScaffold.dart';
import '../../../widgets/hyperlocal_widgets/hyperlocal_shopwidget.dart';
import '../../ondc/map_text/map_text_view.dart';




class HyperlocalShophomeMobile extends StatefulWidget {
  final String? lat;
  final String? lng;
  const HyperlocalShophomeMobile({Key? key, this.lat, this.lng}) : super(key: key);

  @override
  State<HyperlocalShophomeMobile> createState() => _HyperlocalShophomeMobileState();
}

class _HyperlocalShophomeMobileState extends State<HyperlocalShophomeMobile> {
  late String flat = '';
  NetworkCall networkCall = NetworkCall();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  String? lat;
  String? lng;
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopListOffset.value = 0;
    searchShopListOffset.value = 0;
    _loadData();
      _handleScroll();
      lat = widget.lat;
      lng = widget.lng;
    AnalyticsCustomEvents().userViewedScreen(screen: "HyperLocal_Shop_List_Screen");

  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
       onRefresh: (){
         return _handleRefresh();
       },
      child: CustomScaffold(
        trailingButton: const SizedBox(),
            body: BlocBuilder<
            HyperlocalShopsCubit,
            HyperlocalShopState>(
             builder: (context, shopListState) {

              if(shopListState is HyperlocalShopLoaded &&
                  shopListState.loaded){

                shopListWidgets = [];
                shopListWidgets.addAll(shopListState.shopList);
              }
              if(shopListState is HyperlocalSearchShopLoaded){
                searchedShopListWidgets =[];
                searchedShopListWidgets.addAll(shopListState.shopList);

              }if(shopListState is HyperlocalShopInitialState){
                shopListOffset.value = 0;
                _loadData();
              }

              int count = shopListState is HyperlocalShopLoaded ?
              shopListWidgets.isEmpty ? 1 : shopListWidgets.length :
              searchedShopListWidgets.isEmpty ? 1 : searchedShopListWidgets.length;


              return shopListState is HyperlocalShopLoadingState ||
                  shopListState is HyperlocalShopInitialState ?
              const Center(
                child: CircularProgressIndicator(),
              ) :
              ListView.builder(
                  itemCount: count,
                  controller: _scrollController,
                  itemBuilder: (context,index){

                    if(index==0){
                      return  SizedBox(
                        width: getScreenDimensions(context: context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                      () => const MapTextView(
                                    whichScreen: 'Hyperlocal',
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: SizedBox(
                                  width: getScreenDimensions(context: context,horizontalPadding: 20).width,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BlocConsumer<
                                          AddressBloc,
                                          AddressState>(
                                        listener: (context, state) {

                                          if (state
                                          is GotAddressListAndIdState) {
                                            setState(() {
                                              flat = RepositoryProvider
                                                  .of<AddressRepository>(
                                                  context)
                                                  .deliveryModel
                                                  ?.flat;
                                            });
                                          }
                                        },
                                        builder: (context, state) {
                                          return SizedBox(
                                            width: getScreenDimensions(context: context,horizontalPadding: 55).width,
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Delivery to: ',
                                                style: FontStyleManager().s14fw800Grey,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                    '${(RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat)
                                                        ?? "Loading..."}',
                                                    style: FontStyleManager().s12fw700Grey,

                                                  ),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
                                              style: const TextStyle(
                                                overflow:
                                                TextOverflow.fade,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, top: 5),
                                          child: CircleAvatar(
                                            backgroundColor: AppColors().brandDark,
                                            radius: 12,
                                            child: const Icon(Icons.edit,color: Colors.white,size: 15),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SearchTextField(),

                            Text("OR",style: FontStyleManager().s16fw700,
                              textAlign: TextAlign.center,),
                            shopListState is HyperlocalShopLoaded ?
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text("Browser your local Shops",
                                style: FontStyleManager().s14fw600Grey,
                                textAlign: TextAlign.center,),
                            ) :
                                const SizedBox(),

                            shopListState is HyperlocalSearchShopLoaded ?
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text("Below are the shops that sell Searched Product",
                                style: FontStyleManager().s14fw600Grey,
                                textAlign: TextAlign.center,),
                            ) :
                            const SizedBox(),

                            shopListState is HyperlocalShopLoaded ?
                            shopListWidgets.isNotEmpty ?
                            //shopListWidgets[0]
                           HyperLocalShopWidget(hyperLocalShopModel: shopListWidgets[0])
                                :
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                              child: Text(
                                "Unfortunately, there are no shops in your neighborhood on Santhe yet."
                                    "We will notify you as soon as there are shops servicing your address.",
                                style: FontStyleManager().s14fw700Orange,
                                textAlign: TextAlign.center,
                              ),
                            ) : const SizedBox(),
                            ///End of shopList

                            shopListState is HyperlocalSearchShopLoaded ?
                            searchedShopListWidgets.isNotEmpty ?
                            HyperLocalShopWidget(
                              searchItem: shopListState.searchedItem,
                                hyperLocalShopModel: searchedShopListWidgets[0])
                                :
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                              child: Text(
                                "Unfortunately, there are no shops that sell the product you are looking for."
                                    "Please try to search for something different.",
                                style: FontStyleManager().s14fw700Orange,
                                textAlign: TextAlign.center,
                              ),
                            ) :
                            const SizedBox(),
                          ],
                        ),
                      );
                    }else if(index != shopListWidgets.length-1){
                      return
                        HyperLocalShopWidget(
                            hyperLocalShopModel:  shopListState is HyperlocalShopLoaded ?
                            shopListWidgets[index] : searchedShopListWidgets[index],
                          searchItem: shopListState is HyperlocalSearchShopLoaded ?
                          shopListState.searchedItem : null,);
                    }
                    else{
                      return
                      Column(
                        children: [
                          HyperLocalShopWidget(
                              hyperLocalShopModel:  shopListState is HyperlocalShopLoaded ?
                              shopListWidgets[index] : searchedShopListWidgets[index],
                            searchItem: shopListState is HyperlocalSearchShopLoaded ?
                            shopListState.searchedItem : null, ),
                          Obx(() {

                            if(loadingNewShops.value){
                              return const SizedBox(
                                height: 150,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }else{
                              return const SizedBox();
                            }
                          })
                        ],
                      );
                    }
                  });
            }
        ),

      ),
    );
  }


  _handleScroll() {

    _scrollController.addListener(()  {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        loadingNewShops.value = true;
        Future.delayed(const Duration(seconds: 1)).then(
                (value) => loadingNewShops.value = false );

        if(!fetchingShops.value){

          fetchingShops.value = true;

          BlocProvider.of<HyperlocalShopsCubit>(context).onScroll(
            load: true,
            searchOffset: searchShopListOffset.value,
            offset: shopListOffset.value,
            shopsList: shopListWidgets,
            searchedShopList: searchedShopListWidgets,
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
    });
  }

  _loadData() async{
    customerModel = await networkCall.getCustomerDetails();
    if(mounted){
      context.read<AddressBloc>().add(
            GetAddressListEvent(),
          );
      for(var i=0; i <=30; i++){
        if(!addressLoaded.value){
          await Future.delayed(const Duration(seconds: 2));
        }else{
          _getShops();
          break;
        }
      }
    }
  }


  _getShops() async {
    if(mounted){
          BlocProvider.of<HyperlocalShopsCubit>(context).getShops(
              load: true,
              offset: shopListOffset.value,
              shopsList: shopListWidgets,
              lat: RepositoryProvider
                  .of<AddressRepository>(
                  context)
                  .deliveryModel
                  !.lat,
              lng: RepositoryProvider
                  .of<AddressRepository>(
                  context)
                  .deliveryModel
                  !.lng);

    }
  }

  _handleRefresh() async{
    shopListWidgets = [];
    searchedShopListWidgets = [];
    searchShopListOffset.value = 0;
    shopListOffset.value = 0;


   await BlocProvider.of<HyperlocalShopsCubit>(context).getShops(
        load: true,
        offset: 0,
        shopsList: [],
        lat:  RepositoryProvider
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



class SearchTextField extends StatefulWidget {

  const SearchTextField(
      {Key? key})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  static final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
        child: BlocBuilder<HyperlocalShopsCubit, HyperlocalShopState>(
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
                is HyperlocalSearchShopLoaded
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
    shopListOffset.value =0;
    shopListWidgets = [];

    BlocProvider.of<HyperlocalShopsCubit>(context).getShops(
        load: true,
        offset: shopListOffset.value,
        shopsList: shopListWidgets,
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

    // setState(() {
    //   _searchedLoaded = false;
    // });

    _textEditingController
        .clear();

    searchedShopListWidgets = [];
  }

  _handleSearch(){

    if(_textEditingController
        .text.isNotEmpty){

      searchShopListOffset.value = 0;
      searchedShopListWidgets = [];

      AnalyticsCustomEvents().userSearchShopListScreen(
          searchedProduct: _textEditingController.text);

      BlocProvider.of<HyperlocalShopsCubit>(context).searchShops(
          load: true,
          offset: 0,
          searchedShopList: searchedShopListWidgets,
          itemName: _textEditingController.text,
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

    }else{
      _handleClose();
    }
  }
}











// // ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, use_build_context_synchronously
// part of hyperlocal_shophome_view;
//
// class _HyperlocalShophomeMobile extends StatefulWidget {
//
//   const _HyperlocalShophomeMobile();
//
//   @override
//   State<_HyperlocalShophomeMobile> createState() =>
//       _HyperlocalShophomeMobileState();
// }
//
// class _HyperlocalShophomeMobileState extends State<_HyperlocalShophomeMobile>
//     with LogMixin, TickerProviderStateMixin {
//
//   CustomerModel? customerModel;
//   String flat = '';
//   String? lat;
//   String? lng;
//   NetworkCall networkcall = NetworkCall();
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   final TextEditingController _textEditingController = TextEditingController();
//   final ScrollController _controller = ScrollController();
//   final ScrollController _shopScroll = ScrollController();
//   // final AllListController _allListController = Get.find();
//   final ProfileController _profileController = Get.find();
//   final HomeController _homeController = Get.find();
//   // final NotificationController _notificationController = Get.find();
//   final APIs apiController = Get.find();
//   List<HyperLocalShopWidget> shopWidgets = [];
//   List<HyperLocalShopWidget> searchWidgets = [];
//   List<HyperLocalShopModel> shopModels = [];
//   List<HyperLocalShopModel> searchModels = [];
//   List<HyperLocalShopModel> existingShopModels = [];
//   bool _isLoading = false;
//   bool _isSearchLoading = false;
//   bool _initializing = false;
//   int n = 0;
//   int nSearch = 0;
//   bool _showBrowseShops = false;
//   bool _showSearchText = false;
//
//   initFunction() async {
//     _homeController.homeTabController =
//         TabController(length: 3, vsync: this, initialIndex: 0);
//     sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//       statusBarColor: Colors.white,
//       statusBarBrightness: Brightness.dark,
//     ));
//     final token = await AppHelpers().getToken;
//     await _profileController.initialise();
//    // await _profileController.getOperationalStatus();
//     // _allListController.getAllList();
//     // _allListController.checkSubPlan();
//     /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
//         _connectivityController.listenConnectivity(result));*/
//     // APIs().updateDeviceToken(
//     //   AppHelpers()
//     //       .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
//     // );
//     //apiController.searchedItemResult('potato');
//     apiController.updatFCMONstart(fcmToken: token);
//     // _notificationController.fromNotification = false;
//   }
//
//   getNewShops(
//       {required List<HyperLocalShopWidget> shops, required int limit}) async {
//     String lat = RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lat;
//     String lng = RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lng;
//     final url = Uri.parse(
//         '${AppUrl().baseUrl}/santhe/hyperlocal/merchant/list?'
//             'lat=${lat}&'
//             'lang=${lng}&limit=5&offset=$limit');
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       debugLog('HyperLocal Url for Shops $url');
//       final response = await http.get(url);
//       warningLog(
//           'Response Structure ${response.statusCode} and body ${response.body}'
//               ' also url $url');
//
//       final responseBody = json.decode(response.body)['data']["rows"] as List;
//      // warningLog('Response Body Structure $responseBody');
//       List<HyperLocalShopModel> localHyperLocalShopModel = [];
//
//       localHyperLocalShopModel =  responseBody.map((map) =>
//           HyperLocalShopModel.fromMap(map)).toList();
//
//      // for (var element in responseBody) {
//         // errorLog('Checking for data in getHyperlocalShops $element');
//      //   localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
//      // }
//
//       List<HyperLocalShopWidget> newShops = [];
//
//       for (var element in localHyperLocalShopModel) {
//
//         newShops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//       }
//       infoLog('New Shops $newShops');
//
//       shops.addAll(newShops);
//       setState(() {
//         shopWidgets = shops;
//        // _isLoading = false;
//         existingShopModels.addAll(localHyperLocalShopModel);
//       });
//     } catch (e) {
//       throw HyperLocalGetShopErrorState(message: e.toString());
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   getSearchNewShop(
//       {required List<HyperLocalShopWidget> shops, required int limit}) async {
//     String lat = RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lat;
//     String lng = RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lng;
//     final url = Uri.parse(
//         '${AppUrl().baseUrl}/santhe/hyperlocal/product/search?limit=10&'
//             'offset=$nSearch&item_name=${_textEditingController.text}&'
//             'lat=${lat}&lang=${lng}}');
//     setState(() {
//       _isSearchLoading = true;
//     });
//     try {
//       debugLog('HyperLocal Url From screen for Shops $url');
//       final response = await http.get(url);
//       warningLog(
//           'Response Structure ${response.statusCode} and body ${response.body} also url $url');
//       final responseBody = json.decode(response.body)['data']['rows'] as List;
//       warningLog('Response Body Structure $responseBody');
//       List<HyperLocalShopModel> localHyperLocalShopModel = [];
//
//       for (var element in responseBody) {
//         // errorLog('Checking for data in getHyperlocalShops $element');
//         localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
//       }
//       infoLog('New models $localHyperLocalShopModel');
//       List<HyperLocalShopWidget> newShops = [];
//       for (var element in localHyperLocalShopModel) {
//         newShops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//       }
//       infoLog('New Shops $newShops');
//       shops.addAll(newShops);
//       setState(() {
//         searchWidgets = shops;
//         _isSearchLoading = false;
//       });
//     } catch (e) {
//       throw HyperLocalGetShopSearchErrorState(
//         message: e.toString(),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _initializing = true;
//     });
//     initFunction();
//     if(mounted){
//       getCustomerInfo();
//     }
//
//    if(!_isLoading) {
//       _shopScroll.addListener(() {
//         if (_shopScroll.position.pixels ==
//             _shopScroll.position.maxScrollExtent) {
//           warningLog('called');
//
//         if(mounted){
//           setState(() {
//             n = n + 5;
//           });
//           getNewShops(
//             shops: shopWidgets,
//             limit: n,
//           );
//         }
//         }
//       });
//     }
//     _controller.addListener(() {
//       if (_controller.position.pixels == _controller.position.maxScrollExtent) {
//         warningLog('Search Scroll Called');
//         setState(() {
//           nSearch = nSearch + 10;
//         });
//         getSearchNewShop(shops: searchWidgets, limit: nSearch);
//       }
//     });
//   }
//
//   getCustomerInfo() async {
//     customerModel = await networkcall.getCustomerDetails();
//     setState(() {
//       lat = customerModel!.lat;
//       lng = customerModel!.lng;
//     });
//
//     errorLog('$lat and lng $lng');
//     context.read<AddressBloc>().add(
//           GetAddressListEvent(),
//         );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//   //  final ProfileController profileController = Get.find<ProfileController>();
//     debugLog(
//         '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}');
//     return BlocConsumer<AddressBloc, AddressState>(
//       listener: (context, state) {
//         warningLog('Listening $state');
//         if (state is GotAddressListAndIdState) {
//           context.read<AddressBloc>().add(ResetAddressEvent());
//
//           context.read<HyperlocalShopBloc>().add(
//                 HyperLocalGetShopEvent(
//                     lat: RepositoryProvider.of<AddressRepository>(context)
//                         .deliveryModel!
//                         .lat,
//                     lng: RepositoryProvider.of<AddressRepository>(context)
//                         .deliveryModel!
//                         .lng),
//               );
//         }
//       },
//       builder: (context, state) {
//         return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
//           listener: (context, state) {
//             warningLog('Current State $state');
//             if (state is HyperLocalGetShopErrorState) {
//               setState(() {
//                 _initializing = false;
//               });
//             }
//             if (state is HyperLocalGetShopsState) {
//               List<HyperLocalShopWidget> localShops = [];
//               shopModels = [];
//               shopWidgets = [];
//               shopModels = state.hyperLocalShopModels;
//               warningLog('${shopModels.length}');
//               for (var element in shopModels) {
//                 localShops.add(
//                   HyperLocalShopWidget(hyperLocalShopModel: element),
//                 );
//               }
//               warningLog('$localShops');
//               setState(() {
//                 shopWidgets = localShops;
//                 existingShopModels = shopModels;
//                 _showBrowseShops = true;
//                 _showSearchText = false;
//                 _initializing = false;
//               });
//             }
//             if (state is HyperLocalGetShopSearchState) {
//               List<HyperLocalShopWidget> searchShops = [];
//               searchModels = state.searchModels;
//               for (var element in searchModels) {
//                 searchShops.add(
//                   HyperLocalShopWidget(hyperLocalShopModel: element),
//                 );
//               }
//               setState(() {
//                 searchWidgets = searchShops;
//                 _showBrowseShops = false;
//                 _showSearchText = true;
//               });
//               // context.read<HyperlocalShopBloc>().add(HyperLocalGetResetEvent());
//             }
//             if (state is HyperLocalGetShopSearchClearState) {
//               shopModels = [];
//               List<HyperLocalShopWidget> shops = [];
//               shopModels = state.previousModels;
//               for (var element in shopModels) {
//                 shops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//               }
//               setState(() {
//                 shopWidgets = shops;
//                 existingShopModels = shopModels;
//                 _showBrowseShops = true;
//                 _showSearchText = false;
//               });
//             }
//           },
//           builder: (context, state) {
//             return SizedBox(
//               width: getScreenDimensions(context: context).width,
//               height: getScreenDimensions(context: context).height,
//               child: Stack(
//                 children: [
//                   Scaffold(
//                     key: _key,
//                     drawer: const CustomNavigationDrawer(),
//                     backgroundColor: CupertinoColors.systemBackground,
//                     appBar: AppBar(
//                       leading: IconButton(
//                         onPressed: () async {
//                           //!something to add
//                           //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
//                           /*log(await AppHelpers().getToken);
//                           sendNotification('tesst');*/
//                           _key.currentState!.openDrawer();
//                           /*FirebaseAnalytics.instance.logEvent(
//                             name: "select_content",
//                             parameters: {
//                               "content_type": "image",
//                               "item_id": 'itemId',
//                             },
//                           ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
//                         },
//                         splashRadius: 25.0,
//                         icon: SvgPicture.asset(
//                           'assets/drawer_icon.svg',
//                           color: Colors.white,
//                         ),
//                       ),
//                       shadowColor: Colors.orange.withOpacity(0.5),
//                       elevation: 10.0,
//                       title: const AutoSizeText(
//                         kAppName,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             color: Colors.white,
//                             fontSize: 24),
//                       ),
//                       // actions: [
//                       //   Padding(
//                       //     padding: const EdgeInsets.only(right: 4.5),
//                       //     child: IconButton(
//                       //       onPressed: () {
//                       //         Get.to(OndcCheckOutScreenMobile());
//                       //       },
//                       //       splashRadius: 25.0,
//                       //       icon: InkWell(
//                       //         onTap: () {
//                       //           // Get.to(
//                       //           //   () => OndcIntroView(),
//                       //           // );
//                       //         },
//                       //         child: const Icon(
//                       //           Icons.home,
//                       //           color: Colors.white,
//                       //           size: 27.0,
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   )
//                       // ],
//                     ),
//                     body: state is HyperLocalGetLoadingState
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircularProgressIndicator(),
//                                 Text(
//                                   'Getting Hyperlocal shops near you',
//                                   style: TextStyle(
//                                     color: AppColors().brandDark,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : state is HyperLocalGetShopSearchClearLoadingState
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CircularProgressIndicator(),
//                                     Text(
//                                       'Loading Previous Shops',
//                                       style: TextStyle(
//                                         color: AppColors().brandDark,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : state is HyperLocalGetShopSearchLoadingState
//                                 ? Center(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         CircularProgressIndicator(),
//                                         Text(
//                                           'Getting shops servicing your search',
//                                           style: TextStyle(
//                                             color: AppColors().brandDark,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : ListView.builder(
//                                     controller:
//                                         state is HyperLocalGetShopSearchState
//                                             ? _controller
//                                             : _shopScroll,
//                                     itemBuilder: (context,index){
//                                       if(index == 0){
//                                         return
//                                           Column(
//                                             children: [
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Get.to(
//                                                         () => const MapTextView(
//                                                       whichScreen: 'Hyperlocal',
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                                   children: [
//                                                     GestureDetector(
//                                                       child: Container(
//                                                         color: CupertinoColors
//                                                             .systemBackground,
//                                                         height: MediaQuery.of(context)
//                                                             .size
//                                                             .height *
//                                                             0.133,
//                                                         width: 300,
//                                                         child: Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(
//                                                             top: 8.0,
//                                                             left: 25,
//                                                           ),
//                                                           child: BlocConsumer<
//                                                               AddressBloc,
//                                                               AddressState>(
//                                                             listener: (context, state) {
//                                                               errorLog(
//                                                                   'Address Bloc in hyperLocal$state');
//                                                               if (state
//                                                               is GotAddressListAndIdState) {
//                                                                 setState(() {
//                                                                   flat = RepositoryProvider
//                                                                       .of<AddressRepository>(
//                                                                       context)
//                                                                       .deliveryModel
//                                                                       ?.flat;
//                                                                 });
//                                                               }
//                                                             },
//                                                             builder: (context, state) {
//                                                               return Text.rich(
//                                                                 TextSpan(
//                                                                   text: 'Delivery to: ',
//                                                                   style:
//                                                                   const TextStyle(
//                                                                     fontSize: 15,
//                                                                     overflow:
//                                                                     TextOverflow
//                                                                         .ellipsis,
//                                                                   ),
//                                                                   children: <TextSpan>[
//                                                                     TextSpan(
//                                                                       text:
//                                                                       '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
//                                                                       // widget
//                                                                       //     .customerModel.address
//                                                                       //     .substring(0, 25),
//
//                                                                       style:
//                                                                       const TextStyle(
//                                                                         decorationColor:
//                                                                         Color
//                                                                             .fromARGB(
//                                                                           255,
//                                                                           77,
//                                                                           81,
//                                                                           84,
//                                                                         ),
//                                                                         fontSize: 14,
//                                                                         overflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                       ),
//                                                                     ),
//                                                                     // can add more TextSpans here...
//                                                                   ],
//                                                                 ),
//                                                                 style: TextStyle(
//                                                                   overflow:
//                                                                   TextOverflow.fade,
//                                                                   fontSize: 12,
//                                                                 ),
//                                                               );
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     //! add the indicator here
//                                                     // GestureDetector(
//                                                     //   onTap: () => ge.Get.to(
//                                                     //     OndcCartView(),
//                                                     //   ),
//                                                     //   child: Stack(
//                                                     //     children: [
//                                                     //       Image.asset(
//                                                     //         'assets/newshoppingcartorange.png',
//                                                     //         height: 45,
//                                                     //         width: 45,
//                                                     //       )
//                                                     //     ],
//                                                     //   ),
//                                                     // ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(
//                                                           right: 20, top: 5),
//                                                       child: Image.asset(
//                                                           'assets/edit.png'),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.symmetric(
//                                                     horizontal: 20.0, vertical: 8),
//                                                 child: SizedBox(
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                       0.9,
//                                                   child: TextFormField(
//                                                     controller: _textEditingController,
//                                                     inputFormatters: [
//                                                       NoLeadingSpaceFormatter(),
//                                                     ],
//                                                     onFieldSubmitted: (value) {
//                                                       context
//                                                           .read<HyperlocalShopBloc>()
//                                                           .add(
//                                                         HyperLocalGetShopSearchEvent(
//                                                             lat: RepositoryProvider
//                                                                 .of<AddressRepository>(
//                                                                 context)
//                                                                 .deliveryModel!
//                                                                 .lat,
//                                                             lng: RepositoryProvider
//                                                                 .of<AddressRepository>(
//                                                                 context)
//                                                                 .deliveryModel!
//                                                                 .lng,
//                                                             itemName:
//                                                             _textEditingController
//                                                                 .text),
//                                                       );
//                                                       _isLoading = false;
//                                                     },
//                                                     decoration: InputDecoration(
//                                                       labelText: 'Search Products here',
//                                                       isDense: true,
//                                                       border: OutlineInputBorder(
//                                                         borderRadius:
//                                                         BorderRadius.circular(20.0),
//                                                       ),
//                                                       suffixIcon: state
//                                                       is HyperLocalGetShopSearchState
//                                                           ? GestureDetector(
//                                                         onTap: () {
//                                                           context
//                                                               .read<
//                                                               HyperlocalShopBloc>()
//                                                               .add(
//                                                             HyperLocalClearSearchEventShops(
//                                                                 previousModels:
//                                                                 existingShopModels,
//                                                                 lat: RepositoryProvider.of<
//                                                                     AddressRepository>(
//                                                                     context)
//                                                                     .deliveryModel!
//                                                                     .lat,
//                                                                 lng: RepositoryProvider.of<
//                                                                     AddressRepository>(
//                                                                     context)
//                                                                     .deliveryModel!
//                                                                     .lng),
//                                                           );
//                                                           // setState(() {
//                                                           //   _searchedLoaded = false;
//                                                           // });
//                                                           // context.read<HyperlocalShopBloc>().add(
//                                                           //       ClearSearchEventShops(
//                                                           //           shopModels:
//                                                           //               existingShopModels),
//                                                           //     );
//                                                           // context
//                                                           //     .read<OndcBloc>()
//                                                           //     .add(
//                                                           //       FetchNearByShops(
//                                                           //         lat: widget
//                                                           //             .customerModel
//                                                           //             .lat,
//                                                           //         lng: widget
//                                                           //             .customerModel
//                                                           //             .lng,
//                                                           //         pincode: widget
//                                                           //             .customerModel
//                                                           //             .pinCode,
//                                                           //         isDelivery: widget
//                                                           //             .customerModel
//                                                           //             .opStats,
//                                                           //       ),
//                                                           //     );
//                                                           _textEditingController
//                                                               .clear();
//                                                         },
//                                                         child: const Icon(
//                                                             Icons.cancel),
//                                                       )
//                                                           : null,
//                                                       prefixIcon: Padding(
//                                                         padding:
//                                                         const EdgeInsets.symmetric(
//                                                             vertical: 9.0),
//                                                         child: InkWell(
//                                                           onTap: () {
//                                                             context
//                                                                 .read<
//                                                                 HyperlocalShopBloc>()
//                                                                 .add(
//                                                               HyperLocalGetShopSearchEvent(
//                                                                 lat: RepositoryProvider
//                                                                     .of<AddressRepository>(
//                                                                     context)
//                                                                     .deliveryModel!
//                                                                     .lat,
//                                                                 lng: RepositoryProvider
//                                                                     .of<AddressRepository>(
//                                                                     context)
//                                                                     .deliveryModel!
//                                                                     .lng,
//                                                                 itemName:
//                                                                 _textEditingController
//                                                                     .text,
//                                                               ),
//                                                             );
//                                                           },
//                                                           child: const Icon(
//                                                             CupertinoIcons
//                                                                 .search_circle_fill,
//                                                             size: 32,
//                                                             color: Colors.orange,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               state is HyperLocalSearchItemLoadedState
//                                                   ? Text('')
//                                                   : Center(
//                                                 child: Text(
//                                                   'OR',
//                                                   style: TextStyle(
//                                                       color: Colors.grey,
//                                                       fontSize: 15),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               _showSearchText
//                                                   ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 25.0),
//                                                 child: Align(
//                                                   alignment: Alignment.centerLeft,
//                                                   child: Text(
//                                                       'Below are the shops that sell "${_textEditingController.text.toString().capitalizeFirst}"'),
//                                                 ),
//                                               )
//                                                   : SizedBox(),
//                                               _showBrowseShops
//                                                   ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 25.0),
//                                                 child: Align(
//                                                   alignment: Alignment.centerLeft,
//                                                   child: Text(
//                                                     'Browse your local Shops',
//                                                     style: TextStyle(
//                                                       color: AppColors().black100,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                                   : SizedBox(),
//                                               SizedBox(
//                                                 height: 25,
//                                               ),
//                                               // state is HyperLocalSearchItemLoadedState
//                                               //     ? searchWidgets.isEmpty
//                                               //         ? Text('')
//
//                                               //     : Padding(
//                                               //         padding: const EdgeInsets.only(
//                                               //             left: 25.0),
//                                               //         child: Align(
//                                               //           alignment: Alignment.centerLeft,
//                                               //           child: Text(
//                                               //               'Browse your Local Shops'),
//                                               //         ),
//                                               //       ),
//
//                                               state
//                                               is HyperLocalGetShopSearchState
//                                                   ? searchWidgets.isEmpty
//                                                   ? Padding(
//                                                 padding:
//                                                 const EdgeInsets.all(
//                                                     18.0),
//                                                 child: Text(
//                                                   'Unfortunately there are no shops that sell the product you are looking for.Please try to search for something different',
//                                                   textAlign:
//                                                   TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: AppColors()
//                                                         .brandDark,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               )
//                                                   : searchWidgets[index]
//                                               // Column(
//                                               //   children: searchWidgets,
//                                               // )
//                                                   : state is HyperLocalGetShopSearchClearLoadingState
//                                                   ? Center(
//                                                 child: Column(
//                                                   children: [
//                                                     CircularProgressIndicator(),
//                                                     Text(
//                                                       'Loading Previous Shops',
//                                                       style: TextStyle(
//                                                         color: AppColors()
//                                                             .brandDark,
//                                                         fontWeight:
//                                                         FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                                   : shopWidgets.isEmpty
//                                                   ? Center(
//                                                 child: Text(
//                                                   'Unfortunately, there no shops in your neighborhood are on Santhe yet. We will notify you as soon as there are shops servicing your address.',
//                                                   textAlign:
//                                                   TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: AppColors()
//                                                         .brandDark,
//                                                     fontSize: 15,
//                                                   ),
//                                                 ),
//                                               )
//                                                   : shopWidgets[index],
//                                       // Column(
//                                       //   children: shopWidgets,
//                                       // );
//
//                                       _isLoading
//                                                   ? Column(
//                                                 children: const [
//                                                   Center(
//                                                     // heightFactor: 0.8,
//                                                     child:
//                                                     CircularProgressIndicator(),
//                                                   ),
//                                                 ],
//                                               )
//                                                   : const SizedBox(
//                                                 height: 60,
//                                               ),
//                                               const SizedBox(
//                                                 height: 50,
//                                               ),
//                                             ],
//                                           );
//
//                                       }else{
//                                         return
//                                           SizedBox(
//                                           height: getScreenDimensions(
//                                               context: context, verticalPadding: 50).height,
//                                           child: ListView.builder(
//                                             controller: state
//                                             is HyperLocalGetShopSearchState ? _controller :
//                                             _shopScroll,
//                                             itemCount: state
//                                             is HyperLocalGetShopSearchState ? searchWidgets.length :
//                                             shopWidgets.length,
//                                             itemBuilder: (context,index){
//                                               return
//                                                 state
//                                                 is HyperLocalGetShopSearchState
//                                                     ? searchWidgets.isEmpty
//                                                     ? Padding(
//                                                   padding:
//                                                   const EdgeInsets.all(
//                                                       18.0),
//                                                   child: Text(
//                                                     'Unfortunately there are no shops that sell the product you are looking for.Please try to search for something different',
//                                                     textAlign:
//                                                     TextAlign.center,
//                                                     style: TextStyle(
//                                                       color: AppColors()
//                                                           .brandDark,
//                                                       fontSize: 18,
//                                                     ),
//                                                   ),
//                                                 )
//                                                     : searchWidgets[index]
//                                                 // Column(
//                                                 //   children: searchWidgets,
//                                                 // )
//                                                     : state is HyperLocalGetShopSearchClearLoadingState
//                                                     ? Center(
//                                                   child: Column(
//                                                     children: [
//                                                       CircularProgressIndicator(),
//                                                       Text(
//                                                         'Loading Previous Shops',
//                                                         style: TextStyle(
//                                                           color: AppColors()
//                                                               .brandDark,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                                     : shopWidgets.isEmpty
//                                                     ? Center(
//                                                   child: Text(
//                                                     'Unfortunately, there no shops in your neighborhood are on Santhe yet. We will notify you as soon as there are shops servicing your address.',
//                                                     textAlign:
//                                                     TextAlign.center,
//                                                     style: TextStyle(
//                                                       color: AppColors()
//                                                           .brandDark,
//                                                       fontSize: 15,
//                                                     ),
//                                                   ),
//                                                 )
//                                                     : shopWidgets[index];
//                                                 // Column(
//                                                 //   children: shopWidgets,
//                                                 // );
//                                             },
//                                           ),
//                                         );
//                                       }
//                                     }
//
//                                   ),
//                   ),
//                   _initializing
//                       ? Material(
//                           child: Column(
//                             children: [
//                               AppBar(
//                                 leading: IconButton(
//                                   onPressed: () async {
//
//                                     //!something to add
//                                     //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
//                                     /*log(await AppHelpers().getToken);
//                         sendNotification('tesst');*/
//                                     _key.currentState!.openDrawer();
//                                     /*FirebaseAnalytics.instance.logEvent(
//                           name: "select_content",
//                           parameters: {
//                             "content_type": "image",
//                             "item_id": 'itemId',
//                           },
//                         ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
//                                   },
//                                   splashRadius: 25.0,
//                                   icon: SvgPicture.asset(
//                                     'assets/drawer_icon.svg',
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 shadowColor: Colors.orange.withOpacity(0.5),
//                                 elevation: 10.0,
//                                 title: const AutoSizeText(
//                                   kAppName,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.white,
//                                       fontSize: 24),
//                                 ),
//                                 actions: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 4.5),
//                                     child: IconButton(
//                                       onPressed: () {
//                                         // ge.Get.to(
//                                         //   () => const OndcIntroView(),
//                                         //   transition: ge.Transition.rightToLeft,
//                                         // );
//                                         // Get.off(
//                                         //     HyperlocalShophomeView(
//                                         //         lat: profileController
//                                         //             .customerDetails!.lat,
//                                         //         lng: profileController
//                                         //             .customerDetails!.lng),
//                                         //     );
//                                       },
//                                       splashRadius: 25.0,
//                                       icon: const Icon(
//                                         Icons.home,
//                                         color: Colors.white,
//                                         size: 27.0,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: MediaQuery.of(context).size.height * 0.45,
//                               ),
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   children: [
//                                     Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                     Text(
//                                       'Loading',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           color: AppColors().brandDark,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : SizedBox()
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
// }
//
//
//
// // isolateTest({required }) async{
// //   final ReceivePort _receiver = ReceivePort();
// //   try{
// //     await Isolate.spawn(add,[_receiver]
// //
// //     );
// //   }on Object{
// //     print("Error Isolate====");
// //     _receiver.close();
// //   }
// // }
