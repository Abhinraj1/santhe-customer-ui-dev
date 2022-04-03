import 'package:cloud_firestore/cloud_firestore.dart';

import 'cat_json.dart';
import 'json.dart';

// item data feeder
// class DataFeeder {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

// feeding item data.
//   Future itemDataFeeder() async {
//     CollectionReference items = _firebaseFirestore.collection('item');
//     CollectionReference category = _firebaseFirestore.collection('category');
//
//     for (int i = 0; i < jsonData.length; i++) {
//       items.doc('${jsonData[i]['itemId']}').set({
//         'dBrandType': jsonData[i]['dBrandType'],
//         'dItemNotes': jsonData[i]['dItemNotes'],
//         'catId': category.doc('${jsonData[i]['catId']}'),
//         'createUser': jsonData[i]['createUser'],
//         'dQuantity': jsonData[i]['dQuantity'],
//         'dUnit': jsonData[i]['dUnit'],
//         'itemAlias': jsonData[i]['itemAlias'],
//         'itemId': jsonData[i]['itemId'],
//         'itemImageId': jsonData[i]['itemImageId'],
//         'itemImageTn': jsonData[i]['itemImageTn'],
//         'itemName': jsonData[i]['itemName'],
//         'status': jsonData[i]['status'],
//         'unit': jsonData[i]['unit'].toString().split(','),
//         'updateUser': jsonData[i]['updateUser']
//       });
//     }
//   }
// }

//CAT DATA
// class DataFeeder {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//
//   //feeding car data.
//   Future itemDataFeeder() async {
//     CollectionReference items = _firebaseFirestore.collection('item');
//     CollectionReference category = _firebaseFirestore.collection('category');
//
//     for (int i = 0; i < catJson.length; i++) {
//       category.doc('${catJson[i]['catId']}').set({
//         'catName': catJson[i]['catName'],
//         'catImageId': catJson[i]['catImageId'],
//         'catImageTn': catJson[i]['catImageTn'],
//         'catNotes': catJson[i]['catNotes'],
//         'catId': catJson[i]['catId'],
//         'status': catJson[i]['status'],
//         'userCreate': catJson[i]['userCreate'],
//         'userUpdate': catJson[i]['userUpdate'],
//       });
//     }
//   }
// }
