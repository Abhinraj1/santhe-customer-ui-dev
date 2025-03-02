import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';

import '../../../constants.dart';
import '../../../core/app_colors.dart';
import '../../../manager/font_manager.dart';
import '../../../manager/imageManager.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../utils/priceFormatter.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';


class SelectProductScreen extends StatefulWidget {
  final SingleOrderModel store;
  const SelectProductScreen({Key? key,
    required this.store}) : super(key: key);

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  List<bool> isSelected = [];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors().grey20,
        body: Column(
          children: [
            const CustomTitleWithBackButton(
                title: "Select Product",),
            Expanded(
              child: ListView.builder(
                itemCount: widget.store.quotes!.
                first.cartItemPrices!.length,

                  itemBuilder: (context, index){

                  isSelected.addAll(List.generate( widget.store.quotes!.
                  first.cartItemPrices!.length, (index) => false
                  ));

                 CartItemPrices item =  widget.store.quotes!.
                 first.cartItemPrices![index];

                 isSelected[index] = selectedCartItemPriceId.value.
                                        contains(item.id.toString());


                if(item.type.toString() == "item"){

                  return
                    StatefulBuilder(
                      builder: (stateContext, setInnerState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric
                          (horizontal: 10, vertical: 10),
                        child: InkWell(
                          onTap: (){

                            setInnerState((){
                              isSelected[index] = !isSelected[index];
                              setState(() {});
                            });



                            if(isSelected[index]){
                              ///
                              selectedCartItemPriceId.add(item.id.toString());
                            }else{
                              selectedCartItemPriceId.removeWhere(
                                      (element) => element.contains(
                                          item.id.toString())
                              );
                            }


                            print("SELECTED selectedCartItemPriceId IS  ===================="
                                "${selectedCartItemPriceId.toString()}");
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: isSelected[index] ? BorderSide(color: Colors.green,width: 2):
                                  BorderSide.none
                            ),
                            elevation: 8.0,
                            color: Colors.white,
                            child:
                            Stack(
                              children: [
                                Row(
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
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
                                     const SizedBox(width: 6),
                                  ],
                                ),
                              isSelected[index] ?
                              const Positioned(
                                  top: 2,
                                    right: 2,
                                    child: Icon(
                                      Icons.check,size: 35,color: Colors.green,)) :
                                  SizedBox()
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );

                }
                else{
                  return
                SizedBox();
                }
              },

              ),
            ),
          ],
        ));
  }
}
