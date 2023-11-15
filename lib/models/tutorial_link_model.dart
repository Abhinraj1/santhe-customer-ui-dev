


class TutorialLinkModel {
  String? id;
  String? title;
  String? url;
  dynamic type;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  TutorialLinkModel({this.id, this.title, this.url, this.type, this.createdAt, this.updatedAt, this.deletedAt});

  TutorialLinkModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    url = json["url"];
    type = json["type"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
  }

  static List<TutorialLinkModel> fromList(List<dynamic> list) {
    return list.map((map) => TutorialLinkModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["url"] = url;
    _data["type"] = type;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    return _data;
  }
}