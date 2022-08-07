import 'navigation_drawer_tile.dart';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/nav_bar_pages/edit_profile_customer.dart';
import 'package:santhe/pages/nav_bar_pages/privacy_policy_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/nav_bar_pages/about_us_page.dart';
import '../pages/nav_bar_pages/contact_us_page.dart';
import '../pages/nav_bar_pages/faq_page.dart';
import '../pages/nav_bar_pages/terms_condition_page.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Drawer(
      elevation: 2.0,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(28.0),
      //   bottomRight: Radius.circular(28.0),
      // )),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  left: 6.0,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashRadius: 25.0,
                  icon: SvgPicture.asset(
                    'assets/drawer_icon.svg',
                    fit: BoxFit.scaleDown,
                    height: 18.0,
                    color: Colors.orange,
                  ),
                ),
              )),
          const Padding(
            padding:
                EdgeInsets.only(top: 18.0, left: 10, right: 10.0, bottom: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 60.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70.0,
                child: Icon(
                  CupertinoIcons.person_solid,
                  color: Colors.orange,
                  size: 100.0,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 8.0 + 16,
                      right: 8.0,
                    ),
                    child: Icon(
                      CupertinoIcons.pencil_circle_fill,
                      color: Colors.transparent,
                    ),
                  ),
                  GetBuilder(
                    init: profileController,
                    id: 'navDrawer',
                    builder: (builder) {
                      CustomerModel currentUser =
                          profileController.customerDetails ??
                              fallback_error_customer;
                      return Expanded(
                        child: AutoSizeText(
                          currentUser.customerName,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.w300),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => const EditCustomerProfile());
                      },
                      icon: const Icon(CupertinoIcons.pencil_circle_fill,
                          color: Colors.orange),
                      iconSize: 28.0,
                    ),
                  ),
                ],
              ),
              Text(
                '+91 ${AppHelpers().getPhoneNumberWithoutCountryCode}',
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 3),
          const Divider(
            indent: 20.0,
            endIndent: 20.0,
            thickness: 1.1,
          ),
          SizedBox(height: screenHeight * 3),
          NavigationDrawerTile(
            icon: CupertinoIcons.question,
            tileText: 'FAQ',
            onPress: () {
              // Navigator.pop(context);
              Get.to(() => const FAQPage());
            },
          ),
          NavigationDrawerTile(
            icon: CupertinoIcons.phone_fill,
            tileText: 'Contact Us/Feedback',
            onPress: () {
              // Navigator.pop(context);
              Get.to(() => const ContactUsPage());
            },
          ),
          NavigationDrawerTile(
            icon: Icons.star,
            tileText: 'Rate Us',
            onPress: () {
              if (Platform.isIOS) {
                launchUrl(
                  Uri.parse(
                      'https://apps.apple.com/in/app/santhe/id1637209002'),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                launchUrl(
                  Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.santhe.customer'),
                  mode: LaunchMode.externalNonBrowserApplication,
                );
              }
            },
          ),
          NavigationDrawerTile(
            icon: Icons.people,
            tileText: 'About Us',
            onPress: () {
              // Navigator.pop(context);
              Get.to(() => const AboutUsPage());
            },
          ),
          NavigationDrawerTile(
            icon: CupertinoIcons.checkmark_shield_fill,
            tileText: 'Terms & Conditions',
            onPress: () {
              // Navigator.pop(context);
              Get.to(() => const TermsAndConditionsPage());
            },
          ),
          NavigationDrawerTile(
            icon: CupertinoIcons.lock_shield_fill,
            tileText: 'Privacy Policy',
            onPress: () {
              // Navigator.pop(context);
              Get.to(() => const PrivacyPolicyPage());
            },
          ),
        ],
      ),
    );
  }
}
