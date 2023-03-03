// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:santhe/models/ondc/shipment_segregator_model.dart';
import 'package:santhe/widgets/ondc_widgets/preview_widget.dart';

class ShipmentSegregator extends StatefulWidget {
  final ShipmentSegregatorModel model;
  List<PreviewWidgetOndcItem> widgets;
  ShipmentSegregator({
    Key? key,
    required this.model,
    required this.widgets,
  }) : super(key: key);

  @override
  State<ShipmentSegregator> createState() => _ShipmentSegregatorState();
}

class _ShipmentSegregatorState extends State<ShipmentSegregator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Shipment No ${widget.model.shipmentNo.toString()}',
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            children: [...widget.widgets],
          ),
        ),
      ),
    );
  }
}
