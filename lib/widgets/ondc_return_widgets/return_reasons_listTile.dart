import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';

import '../../core/blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';

class ReturnReasonsListTile extends StatefulWidget {
  final List<ReasonsModel> reasons;
  final bool isReturn;
  final bool isPartialCancel;


  const ReturnReasonsListTile({Key? key, required this.reasons,
    required this.isReturn,
  required this.isPartialCancel})
      : super(key: key);

  @override
  State<ReturnReasonsListTile> createState() => _ReturnReasonsListTileState();
}

class _ReturnReasonsListTileState extends State<ReturnReasonsListTile> {

  String selectedValue = '';

  @override

  Widget build(BuildContext context) {

    return  ListView.builder(
          itemCount: widget.reasons.length,
          itemBuilder: (context, index) {
            String code = widget.reasons[index].code.toString();
            bool isSelected = selectedValue == code ? true : false;

            return

              StatefulBuilder(
                  builder: (stateContext, setInnerState) {
                    return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    child: InkWell(
                      onTap: () {

                        setInnerState((){

                          selectedValue = widget.reasons[index].code.toString();

                          setState(() {});
                        });

                        if(widget.isReturn){

                          BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
                              SelectedCodeForReturnEvent(
                                code: selectedValue,
                                context: context
                              ));

                        }else if(widget.isPartialCancel){
                          BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
                              SelectedCodeForPartialOrderCancelEvent(
                                code: selectedValue,
                              ));

                        }else{
                          BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
                              SelectedCodeEvent(
                                code: selectedValue,
                              ));
                        }
                      },
                      child: // simple usage

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.5,
                                    color: isSelected
                                        ? AppColors().primaryOrange
                                        : AppColors().grey100)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                  backgroundColor: isSelected
                                      ? AppColors().primaryOrange
                                      : AppColors().white100),
                            ),
                          ),
                          SizedBox(
                            width: 280,
                            child: Text(
                              widget.reasons[index].reason.toString(),
                              maxLines: 3,
                              style: isSelected ?
                              FontStyleManager().s16fw600Orange :
                              FontStyleManager().s16fw500
                              ,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              );

          });
  }
}
