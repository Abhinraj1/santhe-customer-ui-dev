import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationDrawerTile extends StatelessWidget {
  final String tileText;
  final IconData icon;
  final onPress;

  const NavigationDrawerTile(
      {required this.tileText,
      required this.icon,
      required this.onPress,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      focusColor: Colors.orange,
      leading: CircleAvatar(
        radius: 18.0,
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.0,
        ),
        backgroundColor: Colors.orange,
      ),
      title: Text(
        tileText,
        style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16.0,
      ),
    );
  }
}
