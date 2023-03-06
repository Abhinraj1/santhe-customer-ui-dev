import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santhe/manager/font_manager.dart';

import '../../../../../core/app_colors.dart';
import '../../../../../manager/imageManager.dart';


class AddressColumn extends StatelessWidget {
  final String title,
      addressType,
      address;

 final bool? hasEditButton;
     final Function()? onTap;
  const AddressColumn({Key? key, required this.title, required this.addressType,
    required this.address, this.hasEditButton, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     SizedBox(
      width: 320,
      child: Column(
        children: [
          Center(
            child: Text(title,
              style: FontStyleManager().s16fw600Orange,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0,top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(addressType,
                style: FontStyleManager().s12fw400Orange,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LimitedBox(
                      maxWidth: 275,
                      child: Text(address,
                        style: FontStyleManager().s12fw400Grey,),
                    ),
                    hasEditButton ?? false ?

                    InkWell(
                      onTap: (){

                        if(hasEditButton ?? false){
                          onTap!();
                        }


                      },
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors().primaryOrange,
                          child: Icon(Icons.edit,color: AppColors().white100,size: 14,),
                        ),
                      ),
                    ) :
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}

