
class HyperLocalPaymentModel {
  bool? success;
  String? code;
  String? message;
  Data? data;

  HyperLocalPaymentModel({this.success, this.code, this.message, this.data});

  HyperLocalPaymentModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  static List<HyperLocalPaymentModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => HyperLocalPaymentModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["code"] = code;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? merchantId;
  String? merchantTransactionId;
  InstrumentResponse? instrumentResponse;

  Data({this.merchantId, this.merchantTransactionId, this.instrumentResponse});

  Data.fromJson(Map<String, dynamic> json) {
    merchantId = json["merchantId"];
    merchantTransactionId = json["merchantTransactionId"];
    instrumentResponse = json["instrumentResponse"] == null ? null : InstrumentResponse.fromJson(json["instrumentResponse"]);
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Data.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["merchantId"] = merchantId;
    _data["merchantTransactionId"] = merchantTransactionId;
    if(instrumentResponse != null) {
      _data["instrumentResponse"] = instrumentResponse?.toJson();
    }
    return _data;
  }
}

class InstrumentResponse {
  String? type;
  RedirectInfo? redirectInfo;

  InstrumentResponse({this.type, this.redirectInfo});

  InstrumentResponse.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    redirectInfo = json["redirectInfo"] == null ? null : RedirectInfo.fromJson(json["redirectInfo"]);
  }

  static List<InstrumentResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => InstrumentResponse.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    if(redirectInfo != null) {
      _data["redirectInfo"] = redirectInfo?.toJson();
    }
    return _data;
  }
}

class RedirectInfo {
  String? url;
  String? method;

  RedirectInfo({this.url, this.method});

  RedirectInfo.fromJson(Map<String, dynamic> json) {
    url = json["url"];
    method = json["method"];
  }

  static List<RedirectInfo> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => RedirectInfo.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["url"] = url;
    _data["method"] = method;
    return _data;
  }
}