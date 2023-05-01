import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';

import '../../../manager/font_manager.dart';
import '../../../manager/imageManager.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../utils/priceFormatter.dart';


class SelectProductScreen extends StatelessWidget {
  final SingleOrderModel store;
  const SelectProductScreen({Key? key,
    required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.red,
        body: SizedBox(
          width: 300,
          height: 500,
          child: ListView.builder(
              itemBuilder: (context, index){

                print("index ========================= $index");
             CartItemPrices item =  store.quotes!.first.cartItemPrices![index];

             print("INSIDE LISTVIEW BUILDER =============== "
                 "${item.type} ${store.quotes!.first.
             cartItemPrices!.length}");


            if(item.type.toString() == "item"){
              return Padding(
                padding: const EdgeInsets.symmetric
                  (horizontal: 10, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 8.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 100,
                        width: 5,
                      ),
                      item.symbol != null &&
                         item.symbol != ""
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                          item.symbol,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                          ImgManager().emptyCart,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                                width: 185,
                                child: AutoSizeText(
                                  item.title.toString(),
                                  style: FontStyleManager().s14fw500Brown,
                                  minFontSize: 12,
                                  maxFontSize: 14,
                                  maxLines: 2,
                                )
                            ),


                            /// Row to Show Net Quantity and Units
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.netQuantity != null ?

                                  '${item.netQuantity.toString()} , ' :
                                  "",
                                  style: FontStyleManager().s10fw500Brown,
                                ),
                                Text(
                                  '${item
                                      .quantity} units',
                                  style: FontStyleManager().s10fw500Brown,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            //! new field for cancel...check for tracking status and
                          ],
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(left: 2.0,right: 5),
                        child: SizedBox(
                          width: 50,
                          child: AutoSizeText(
                            "₹${priceFormatter(value: item.price.
                            toString())}",
                            maxFontSize: 16,
                            minFontSize: 10,
                            style: FontStyleManager().s16fw600Grey,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 6),
                    ],
                  ),
                ),
              );

            }
            else{
             SizedBox();
            }
          },
            itemCount: store.quotes!.first.cartItemPrices!.length,
          ),
        ));
  }
}
