import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santhe/models/santhe_user_list_model.dart';

enum Status {
  accepted,
  maxOffer,
  noOffer,
  waiting,
  minOffer,
  expired,
}

class OfferStatus extends StatelessWidget {
  OfferStatus({Key? key, required this.userList}) : super(key: key) {
    setStatus(userList.processStatus);
  }

  final UserList userList;
  Status state = Status.noOffer;

  void setStatus(String status) {
    if (status == 'nooffer' || status == 'nomerchants') {
      state = Status.noOffer;
    } else if (status == 'accepted' || status == 'processed') {
      state = Status.accepted;
    } else if (status == 'processing' ||
        status == 'waiting' ||
        status == 'draft') {
      state = Status.waiting;
    } else if (_minOffer()) {
      state == Status.minOffer;
    } else if (status == 'expired') {
      state = Status.expired;
    } else if (_maxOffer()) {
      state == Status.maxOffer;
    }
  }

  bool _minOffer() {
    return (userList.processStatus == 'minoffer' &&
            userList.custOfferWaitTime.toLocal().isBefore(DateTime.now()))
        ? true
        : false;
  }

  bool _maxOffer() {
    return (userList.processStatus == 'maxoffer' &&
            userList.custOfferWaitTime.toLocal().isBefore(DateTime.now()))
        ? true
        : false;
  }

  Widget getText() {
    switch (state) {
      case Status.noOffer:
        {
          return AutoSizeText(
            'No Offers',
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontWeight: FontWeight.w400),
          );
        }

      case Status.accepted:
        {
          return AutoSizeText(
            'Accepted',
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.green,
                fontWeight: FontWeight.w400),
          );
        }
      case Status.maxOffer:
        {
          return AutoSizeText(
            '${userList.listOfferCounter} Offers Available',
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.green,
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
                fontSize: 14.sp,
                color: const Color(0xffFFC300),
                fontWeight: FontWeight.w400),
          );
        }
      case Status.expired:
        {
          return AutoSizeText(
            'Offers Missed',
            style: TextStyle(
                fontSize: 14.sp,
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

  Widget getIcon() {
    switch(state){
      case Status.accepted:{
        return Icon(
          CupertinoIcons.checkmark_alt_circle_fill,
          color: Colors.green,
          size: 18.sp,
        );
      }
      case Status.maxOffer: {
        return Icon(
          CupertinoIcons.hand_thumbsup_fill,
          color: Colors.deepPurple,
          size: 18.sp,
        );
      }
      case Status.noOffer: {
        return Icon(
          CupertinoIcons.xmark_circle_fill,
          color: Colors.red,
          size: 18.sp,
        );
      }
      case Status.waiting: {
        return Icon(
          Icons.hourglass_bottom_rounded,
          color: Colors.orangeAccent,
          size: 18.sp,
        );
      }
      case Status.minOffer: {
        return Icon(
          CupertinoIcons.hand_thumbsup,
          color: Colors.orangeAccent,
          size: 18.sp,
        );
      }
      case Status.expired: {
        return Icon(
          CupertinoIcons.exclamationmark_circle_fill,
          color: Colors.grey,
          size: 18.sp,
        );
      }
      default: {
        return const Visibility(
            visible: false,
            child: SizedBox()
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getText(),
        getIcon()
      ],
    );
  }
}
