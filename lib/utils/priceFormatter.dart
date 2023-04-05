




String priceFormatter({required String value}){

  if(value.contains(".")){

    var split = value.split(".");

    if(split[1].length > 2){

      String finalOutput =  "${split[0]}.${split[1].toString().substring(0,2)}";

      return finalOutput;
    }

  }
  return value;


}