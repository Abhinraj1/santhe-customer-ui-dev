import 'package:firebase_storage/firebase_storage.dart';

// class FireStorage {
//   void getFirebaseImageFolder() {
//     final storageRef = FirebaseStorage.instance.ref().child('iietm');
//     storageRef.listAll().then((result) {
//       print("heheisdededed ${result.storage}");
//     });
//   }
// }

class FireStorage {
  Future getFirebaseImageFolder() async {
    Map images = {};
    var result = await FirebaseStorage.instance.ref('item/').listAll();
    // print("-----|--------|-----" + result.items.toString());
    var arr = result.items;

    for (int i = 0; i < arr.length; i++) {
      String imgUrl =
          await FirebaseStorage.instance.ref(arr[i].fullPath).getDownloadURL();
      print(imgUrl);
      images[arr[i].fullPath] = imgUrl;
    }
    print(images);
  }
}
