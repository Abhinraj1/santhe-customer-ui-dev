import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/app_colors.dart';
import '../../core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import '../../core/repositories/hyperlocal_repository.dart';
import '../../pages/hyperlocal/hyperlocal_cart/hyperlocal_cart_view.dart';


class HyperLocalShopDetailsCartIcon extends StatefulWidget {
  final String id;
  const HyperLocalShopDetailsCartIcon({Key? key,
    required this.id}):super(key: key);

  @override
  State<HyperLocalShopDetailsCartIcon> createState() =>
      _HyperLocalShopDetailsCartIconState();
}

class _HyperLocalShopDetailsCartIconState extends
State<HyperLocalShopDetailsCartIcon> {
  dynamic cartCount = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCartCount();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalCartBloc,
        HyperlocalCartState>(
      listener: (context, state) async {

        print('State Check $state');
        if (state is ResetHyperLocalCartState) {
          await RepositoryProvider.of<
              HyperLocalRepository>(context)
              .getCartCount(
              storeDescriptionId: widget
                  .id);
          setState(() {
            cartCount = RepositoryProvider.of<
                HyperLocalRepository>(context)
                .cartTotalCountLocal;
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.topRight,
            //toDo : add indicator while cart bloc implementation
            child: GestureDetector(
              onTap: () {
                print(
                    '${widget.id}');
                Get.to(
                        () => HyperlocalCartView(
                      storeDescriptionId: widget.id,
                    ),
                    transition:
                    ge.Transition.rightToLeft);
              },
              child: badges.Badge(
                position:
                badges.BadgePosition.topEnd(
                    top: 0, end: 3),
                badgeAnimation: const badges
                    .BadgeAnimation.slide(),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: AppColors().brandDark,
                ),
                showBadge: true,
                badgeContent: Text(
                  '$cartCount',
                  style: const TextStyle(
                      color: Colors.white),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor:
                  AppColors().brandDark,
                  child: Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/cartIcon.svg",
                        fit: BoxFit.fill,
                        height: 55,
                        width: 55,
                      )
                    // Image.asset(
                    //   'assets/newshoppingcart.png',
                    //   fit: BoxFit.fill,
                    //   height: 55,
                    //   width: 55,
                    // ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  _getCartCount()async{
  print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%storeDescriptionId: =${widget.id}");
    await RepositoryProvider.of<HyperLocalRepository>(context)
        .getCartCount(
        storeDescriptionId:
        widget.id);

if(mounted){
  dynamic count =  RepositoryProvider.of<HyperLocalRepository>(context)
      .cartTotalCountLocal;
  setState(() {
    cartCount = count;
  });
}
  }
}
