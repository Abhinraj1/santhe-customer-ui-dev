import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/santhe_user_list_model.dart';

enum Status {
  accepted,
  maxOffer,
  noOffer,
  waiting,
  minOffer,
  expired,
  missed,
}

class OfferStatus extends StatelessWidget {
  OfferStatus({Key? key, required this.userList}) : super(key: key);
  final UserList userList;

  Status setStatus(String status) {
    if (_minOffer()) {
      return Status.minOffer;
    } else if (status == 'maxoffer') {
      return Status.maxOffer;
    } else if (status == 'nooffer' || status == 'nomerchant') {
      return Status.noOffer;
    } else if (status == 'missed') {
      return Status.missed;
    } else if (status == 'accepted' || status == 'processed') {
      return Status.accepted;
    } else if (status == 'processing' ||
        status == 'waiting' ||
        status == 'draft') {
      return Status.waiting;
    } else if (status == 'expired') {
      return Status.expired;
    } else {
      return Status.waiting;
    }
  }

  bool _minOffer() {
    return (userList.processStatus == 'minoffer' &&
            userList.custOfferWaitTime.toLocal().isBefore(DateTime.now()))
        ? true
        : false;
  }

  Widget getText(Status state) {
    switch (state) {
      case Status.noOffer:
        {
          return AutoSizeText(
            'No Offers',
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
                fontWeight: FontWeight.w400),
          );
        }

      case Status.missed:
        {
          return AutoSizeText(
            'Offers Missed',
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
                fontWeight: FontWeight.w400),
          );
        }

      case Status.accepted:
        {
          return AutoSizeText(
            'Accepted',
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.green,
                fontWeight: FontWeight.w400),
          );
        }
      case Status.maxOffer:
        {
          return AutoSizeText(
            '${userList.listOfferCounter} Offers Available',
            style: TextStyle(
                fontSize: 12.sp,
                color: AppColors().brandLight,
                fontWeight: FontWeight.w400),
          );
        }
      case Status.waiting:
        {
          return AutoSizeText(
            'Waiting for offers',
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xffFFC300),
                fontWeight: FontWeight.w400),
          );
        }
      case Status.minOffer:
        {
          return AutoSizeText(
            '${userList.listOfferCounter} ${userList.listOfferCounter < 2 ? 'Offer Available' : 'Offers Available'} ',
            style: TextStyle(
                fontSize: 12.sp,
                color: AppColors().brandLight,
                fontWeight: FontWeight.w400),
          );
        }
      case Status.expired:
        {
          return AutoSizeText(
            'Offers Expired',
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w400),
          );
        }
      default:
        {
          return const Visibility(
            visible: false,
            child: SizedBox(),
          );
        }
    }
  }

  Widget getIcon(Status state) {
    switch (state) {
      case Status.accepted:
        {
          return const Icon(
            CupertinoIcons.checkmark_alt_circle_fill,
            color: Colors.green,
          );
        }
      case Status.maxOffer:
        {
          return Icon(
            CupertinoIcons.hand_thumbsup,
            color: AppColors().brandDark,
          );
        }
      case Status.noOffer:
        {
          return const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
          );
        }

      case Status.missed:
        {
          return const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
          );
        }

      case Status.waiting:
        {
          return Icon(
            Icons.hourglass_bottom_rounded,
            color: AppColors().brandDark,
          );
        }
      case Status.minOffer:
        {
          return Icon(
            CupertinoIcons.hand_thumbsup,
            color: AppColors().brandDark,
          );
        }
      case Status.expired:
        {
          return const Icon(
            CupertinoIcons.exclamationmark_circle_fill,
            color: Colors.grey,
          );
        }
      default:
        {
          return const Visibility(visible: false, child: SizedBox());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getIcon(setStatus(userList.processStatus)),
        SizedBox(
          width: 8.sp,
        ),
        getText(setStatus(userList.processStatus)),
      ],
    );
  }
}
