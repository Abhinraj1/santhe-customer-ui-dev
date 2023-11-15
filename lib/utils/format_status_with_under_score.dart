

import 'package:get/get.dart';

String statusFormatter({required String value}){
  List<String> array;

  if(value.contains("_")){

    value = value.replaceAll("_", " ");
    array = value.split(" ");
    value = "${array[0].toString().toLowerCase().capitalizeFirst}"
        " ${array[1].toLowerCase().capitalizeFirst}";
  return value;

  }
  value = value.toLowerCase().capitalizeFirst!;
   return value;

}