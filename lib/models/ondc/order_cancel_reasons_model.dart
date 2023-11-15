



class ReasonsModel {
  String? id;
  String? reason;
  String? code;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  ReasonsModel({this.id, this.reason, this.code, this.createdAt, this.updatedAt, this.deletedAt});

  ReasonsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    reason = json["reason"];
    code = json["code"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
  }

  static List<ReasonsModel> fromList(List<dynamic> list) {
    return list.map((map) => ReasonsModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["reason"] = reason;
    _data["code"] = code;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    return _data;
  }
}