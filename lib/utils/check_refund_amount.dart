

checkRefundAmount({required String amountInCents, required String totalAmount}){

  double amount = int.parse(amountInCents)/100;
  double total = double.parse(totalAmount);

  if(amount - total == 0){
    return false;
  }else if(amount - total != 0){
    return (amount - total).toString();
  }else{
    return false;
  }

}