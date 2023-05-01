

class CategoryModel{
  String? detail;
  String? code;
  CategoryModel({this.detail,this.code});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    detail = json["detail"];
    code = json["code"];
  }
  static List<CategoryModel> fromList(List<dynamic> list) {
    return list.map((map) => CategoryModel.fromJson(map)).toList();
  }

}