// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:santhe/models/ondc/final_costing.dart';

class FinalCostingWidget extends StatelessWidget {
  final FinalCostingModel finalCostingModel;
  const FinalCostingWidget({
    Key? key,
    required this.finalCostingModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${finalCostingModel.lable}:'),
            Text('₹ ${finalCostingModel.value}')
          ],
        ),
      ),
    );
  }
}
