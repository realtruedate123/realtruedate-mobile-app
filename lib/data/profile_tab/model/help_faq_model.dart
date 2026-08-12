import 'package:get/get.dart';

class FAQItemModel {
  final String id;
  final String question;
  final String answer;
  final RxBool isExpanded; // Controls individual card expansion state

  FAQItemModel({
    required this.id,
    required this.question,
    required this.answer,
    bool initialExpanded = false,
  }) : isExpanded = initialExpanded.obs;
}

/// FAQModel
class FAQListModel {
  final bool? success;
  final String? message;
  final FAQData? data;

  FAQListModel({
    this.success,
    this.message,
    this.data,
  });

  factory FAQListModel.fromJson(Map<String, dynamic> json) => FAQListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : FAQData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class FAQData {
  final List<FAQObjectModel>? faqs;
  final int? count;

  FAQData({
    this.faqs,
    this.count,
  });

  factory FAQData.fromJson(Map<String, dynamic> json) => FAQData(
    faqs: json["faqs"] == null ? [] : List<FAQObjectModel>.from(json["faqs"]!.map((x) => FAQObjectModel.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "faqs": faqs == null ? [] : List<dynamic>.from(faqs!.map((x) => x.toJson())),
    "count": count,
  };
}

class FAQObjectModel {
  final String? id;
  final String? question;
  final String? answer;
  final int? order;

  FAQObjectModel({
    this.id,
    this.question,
    this.answer,
    this.order,
  });

  factory FAQObjectModel.fromJson(Map<String, dynamic> json) => FAQObjectModel(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "order": order,
  };
}