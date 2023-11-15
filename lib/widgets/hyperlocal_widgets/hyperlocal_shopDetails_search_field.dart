// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../manager/font_manager.dart';
//
//
//
// class HyperLocalShopDetailsSearchField extends StatefulWidget {
//
//   const HyperLocalShopDetailsSearchField(
//       {Key? key})
//       : super(key: key);
//
//   @override
//   State<HyperLocalShopDetailsSearchField> createState() => _SearchTextFieldState();
// }
//
// class _SearchTextFieldState extends State<HyperLocalShopDetailsSearchField> {
//   static final TextEditingController _textEditingController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
//         child: BlocBuilder<HyperlocalShopsCubit, HyperlocalShopState>(
//           builder: (context, state) {
//             return TextField(
//               controller: _textEditingController,
//               style: FontStyleManager().s16fw700Brown,
//               decoration: InputDecoration(
//                 labelText: 'Search Products here',
//                 labelStyle: FontStyleManager().s16fw500,
//                 isDense: true,
//                 focusedBorder:  OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                         width: 2,
//                         color: AppColors().brandDark
//                     )),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide:   BorderSide(
//                       width: 2,
//                       color:AppColors().grey60),
//                 ),
//
//                 suffixIcon:
//                 state
//                 is HyperlocalSearchShopLoaded
//                     ? GestureDetector(
//                   onTap: () {
//                     _handleClose();
//                   },
//                   child: const Icon(
//                       Icons.cancel),
//                 )
//                     : null,
//                 prefixIcon: Padding(
//                   padding:
//                   const EdgeInsets.symmetric(
//                       vertical: 9.0),
//                   child: InkWell(
//                     onTap: () {
//                       _handleSearch();
//                     },
//                     child: const Icon(
//                       CupertinoIcons
//                           .search_circle_fill,
//                       size: 32,
//                       color: Colors.orange,
//                     ),
//                   ),
//                 ),
//               ),onSubmitted: (value){
//               _handleSearch();
//             },);
//           },
//         ),
//       );
//   }
//   _handleClose(){
//
//     searchShopListOffset.value = 0;
//
//     BlocProvider.of<HyperlocalShopsCubit>(context).getShops(
//         load: true,
//         offset: shopListOffset.value,
//         shopsList: shopListWidgets,
//         lat: RepositoryProvider
//             .of<AddressRepository>(
//             context)
//             .deliveryModel
//             ?.lat,
//         lng: RepositoryProvider
//             .of<AddressRepository>(
//             context)
//             .deliveryModel
//             ?.lng
//     );
//
//     // setState(() {
//     //   _searchedLoaded = false;
//     // });
//
//     _textEditingController
//         .clear();
//
//     searchedShopListWidgets = [];
//   }
//
//   _handleSearch(){
//
//     if(_textEditingController
//         .text.isNotEmpty){
//
//       BlocProvider.of<HyperlocalShopsCubit>(context).searchShops(
//           load: true,
//           offset: searchShopListOffset.value,
//           searchedShopList: searchedShopListWidgets,
//           itemName: _textEditingController.text,
//           lat: RepositoryProvider
//               .of<AddressRepository>(
//               context)
//               .deliveryModel
//               ?.lat,
//           lng: RepositoryProvider
//               .of<AddressRepository>(
//               context)
//               .deliveryModel
//               ?.lng
//       );
//
//     }else{
//       _handleClose();
//     }
//   }
// }
//
