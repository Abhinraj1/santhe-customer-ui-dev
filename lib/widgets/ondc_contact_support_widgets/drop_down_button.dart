import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import '../../models/ondc/support_contact_models.dart';


class CustomDropDownButton extends StatefulWidget {
  final List<String>? options;
  final String title;
  final List<CategoryModel>? list;
  final Function(String code) selectedCode;



   const CustomDropDownButton({Key? key,
      this.options, required this.title,
     required this.selectedCode, this.list,
     }) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {

  late List<DropdownMenuItem<String>> menuItems ;
  var selectedOption ;



  @override
   initState() {
    // TODO: implement initState
    super.initState();
    if(widget.options != null){

      menuItems =  widget.options!.map((e)  {

        return DropdownMenuItem(
            onTap: (){
              print("SELECTED CODE ============== ${e}");

              widget.selectedCode(e);
            },
            value: e,
            child: Text(
                e.toString()
            ));
      }).toList();
    }

   else if(widget.list != null){

     menuItems =  widget.list!.map((e)  {

       return DropdownMenuItem(
           onTap: (){
             widget.selectedCode(e.code!);
             print("SELECTED CODE ============== ${e.code}");
           },
           value: e.detail,
           child: Text(
               e.detail.toString()
           ));
     }).toList();
    }

  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(widget.title,
                  style: FontStyleManager().s16fw600Orange),
            )),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors().grey60,
                width: 1
              ),
              color: AppColors().white100
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 8.0),
              child: DropdownButton(
                    isExpanded: true,
                     borderRadius: BorderRadius.circular(15),
                  iconSize: 45,
                  iconEnabledColor: AppColors().grey80,

                  value: selectedOption,

                    underline: const SizedBox(),

                      hint: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text( "",
                              style: FontStyleManager().s20fw700Black,),
                          ),

                      style: FontStyleManager().s20fw700Black,
                      items:
                       menuItems,
                      onChanged: (selected){

                        setState(() {
                          selectedOption = selected.toString();
                        });
                        print("SELECTED Value in ${widget.title} IS ============"
                            "================22====== ${selectedOption}");
                      }
                  )
            ),
          ),
        ),
      ],
    );
  }
}
