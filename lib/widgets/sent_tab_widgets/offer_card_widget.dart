import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:santhe/pages/new_tab_pages/user_list_page.dart';
import 'package:santhe/pages/no_offer_page.dart';
import 'package:santhe/widgets/offer_status_widget.dart';

import '../../controllers/getx/all_list_controller.dart';
import '../../models/new_list/user_list_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/sent_list_detail_page.dart';

class OfferCard extends StatefulWidget {
  final UserListModel userList;

  const OfferCard({
    required this.userList,
    Key? key,
  }) : super(key: key);

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  final apiController = Get.find<APIs>();

  final int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;

  final box = Boxes.getUserListDB();

  final AllListController _allListController = Get.find();

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/basket0.png';

    //image logic
    if (widget.userList.items.isEmpty) {
      imagePath = 'assets/basket0.png';
    } else if (widget.userList.items.length <= 10) {
      imagePath = 'assets/basket1.png';
    } else if (widget.userList.items.length <= 20) {
      imagePath = 'assets/basket2.png';
    } else {
      imagePath = 'assets/basket3.png';
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {
          if (widget.userList.processStatus == 'nomerchant' ||
              widget.userList.processStatus == 'nooffer' ||
              widget.userList.processStatus == 'missed') {
            Get.to(
              () => NoOfferPage(
                userList: widget.userList,
                missed: widget.userList.processStatus == 'missed',
              ),
            );
          } else {
            Get.to(
              () => SentUserListDetailsPage(
                userList: widget.userList,
                showOffers: _showOffer(),
              ),
            )?.then((value) {
              if (value != null) {
                if (value == true) {
                  widget.userList.processStatus = 'accepted';
                  final AllListController _allListController = Get.find();
                  _allListController.update(['sentList']);
                }
              }
            });
          }
        },
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.21),
                blurRadius: 15.0, // soften the shadow
                spreadRadius: 3.6, //extend the shadow
                offset: const Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
          ),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                Visibility(
                  visible: Boxes.getUserListDB().values.length < 3,
                  child: SlidableAction(
                    onPressed: (context) async {
                      /*int userListCount = 0;
                      UserList oldUserList = widget.userList;

                      UserList newImportedList = UserList(
                        createListTime: DateTime.now(),
                        custId: oldUserList.custId,
                        items: oldUserList.items,
                        listId: int.parse('$custId${userListCount + 1}'),
                        listName: '(COPY) ${oldUserList.listName}',
                        custListSentTime: oldUserList.custListSentTime,
                        custListStatus: oldUserList.custListStatus,
                        listOfferCounter: oldUserList.listOfferCounter,
                        processStatus: oldUserList.processStatus,
                        custOfferWaitTime: oldUserList.custOfferWaitTime,
                        updateListTime: DateTime.now(),
                      );

                      int response = await apiController.addCustomerList(
                          newImportedList, custId, 'new');

                      if (response == 1) {
                        box.add(newImportedList);
                        var key = -1;
                        for (int i = 0; i < box.values.length; i++) {
                          final data = box.values.toList()[i];
                          if (data.listId == newImportedList.listId) {
                            key = box.keys.toList()[i];
                          }
                        }
                        if (key != -1) {
                          Get.to(() => UserListPage(
                                listId: newImportedList.listId.toString(),
                              ));
                        } else {
                          Get.offAll(const HomePage(
                            pageIndex: 0,
                          ));
                        }
                      } else {
                        Get.dialog(const Card(
                          child: Center(
                            child: Text('Error!'),
                          ),
                        ));
                      }*/
                    },
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    autoClose: true,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              widget.userList.listName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontSize: 20.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.sp),
                              child: AutoSizeText(
                                '${widget.userList.items.length} ${widget.userList.items.length > 1 ? 'Items' : 'Item'}',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 1.sp, bottom: 8.32.sp),
                              child: AutoSizeText(
                                'Added on ${widget.userList.createListTime.day}/${widget.userList.createListTime.month}/${widget.userList.createListTime.year}',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        imagePath,
                        height: 129.sp,
                        width: 129.sp,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Added on ${widget.userList.createListTime.day}/${widget.userList.createListTime.month}/${widget.userList.createListTime.year}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xffBBBBBB),
                            fontWeight: FontWeight.w400),
                      ),
                      /*Padding(
                        padding: EdgeInsets.only(
                          right: 10.sp,
                        ),
                        child: OfferStatus(
                          userList: widget.userList,
                        ),
                      ),*/
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _showOffer() {
    return (widget.userList.processStatus == 'minoffer' &&
                widget.userList.custOfferWaitTime
                    .toLocal()
                    .isBefore(DateTime.now())) ||
            widget.userList.processStatus == 'maxoffer' ||
            widget.userList.processStatus == 'accepted' ||
            widget.userList.processStatus == 'processed'
        ? true
        : false;
  }
}
