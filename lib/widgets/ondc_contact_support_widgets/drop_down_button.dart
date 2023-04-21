import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';


class CustomDropDownButton extends StatefulWidget {
  final List<String> options;
  final String title;
  final Function(String) onChanged;
   CustomDropDownButton({Key? key, required this.options, required this.title,
     required this.onChanged}) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {

  late List<DropdownMenuItem<String>> menuItems ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuItems = List.generate(widget.options.length,
            (index) => DropdownMenuItem(
            value: widget.options[index],
            child: Text(
                widget.options[index]
            )));
  }


  String selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(widget.title,style: FontStyleManager().s16fw600Orange),
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
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButton(
                isExpanded: true,
                borderRadius: BorderRadius.circular(15),
                underline: SizedBox(),
                  iconSize: 45,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(selectedOption,style: FontStyleManager().s20fw700Grey,),
                  ),
                  style: FontStyleManager().s14fw600Grey,
                  iconEnabledColor: AppColors().grey80,
                  items: menuItems,
                  onChanged: (selected){
                  widget.onChanged(selected.toString());

                  setState(() {
                    selectedOption = selected.toString();
                  });

                    print("SELECTED Value in ${widget.title} IS ============"
                        "====================== ${selected}");

                  }
              ),
            ),
          ),
        ),
      ],
    );
  }
}
