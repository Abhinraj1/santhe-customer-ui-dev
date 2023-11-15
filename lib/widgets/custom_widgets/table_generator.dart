import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../manager/font_manager.dart';


class TableGenerator extends StatelessWidget {
  final List<TableModel> tableRows;
  final double? horizontalPadding;
  final double? verticalPadding;
  const TableGenerator({Key? key, required this.tableRows,
    this.horizontalPadding, this.verticalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 15.0,
          vertical: verticalPadding ?? 0.0
      ),
      child: Table(
        children: List.generate(tableRows.length,
                (index) {
          return   TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(tableRows[index].title,style: FontStyleManager().s14fw600Grey),
                ),
                tableRows[index].data != null ?
                Text(tableRows[index].data ?? "N/A",
                    style: tableRows[index].dataTextStyle ?? FontStyleManager().s14fw700Grey,
                    textAlign: TextAlign.right) : const SizedBox(),

              ]
          );
                } ),
      ),
    );
  }
}


class TableModel{
  final String title;
  final String? data;
  final TextStyle? dataTextStyle;
  TableModel({required this.title, this.data,this.dataTextStyle});
}