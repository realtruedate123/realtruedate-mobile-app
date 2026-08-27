class PaymentHistoryModel {
  final bool? success;
  final String? message;
  final PaymentHistoryData? data;

  PaymentHistoryModel({
    this.success,
    this.message,
    this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PaymentHistoryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class PaymentHistoryData {
  final List<HistoryData>? history;
  final int? total;

  PaymentHistoryData({
    this.history,
    this.total,
  });

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) => PaymentHistoryData(
    history: json["history"] == null ? [] : List<HistoryData>.from(json["history"]!.map((x) => HistoryData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toJson())),
    "total": total,
  };
}

class HistoryData {
  final String? id;
  final String? title;
  final String? productId;
  final String? packageIdentifier;
  final String? transactionIdentifier;
  final String? eventType;
  final double? amount;
  final String? currency;
  final String? amountFormatted;
  final bool? isActive;
  final String? expirationDate;
  final bool? willRenew;
  final String? purchasedAt;
  final String? createdAt;

  HistoryData({
    this.id,
    this.title,
    this.productId,
    this.packageIdentifier,
    this.transactionIdentifier,
    this.eventType,
    this.amount,
    this.currency,
    this.amountFormatted,
    this.isActive,
    this.expirationDate,
    this.willRenew,
    this.purchasedAt,
    this.createdAt,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
    id: json["id"],
    title: json["title"],
    productId: json["product_id"],
    packageIdentifier: json["package_identifier"],
    transactionIdentifier: json["transaction_identifier"],
    eventType: json["event_type"],
    amount: json["amount"],
    currency: json["currency"],
    amountFormatted: json["amount_formatted"],
    isActive: json["is_active"],
    expirationDate: json["expiration_date"],
    willRenew: json["will_renew"],
    purchasedAt: json["purchased_at"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "product_id": productId,
    "package_identifier": packageIdentifier,
    "transaction_identifier": transactionIdentifier,
    "event_type": eventType,
    "amount": amount,
    "currency": currency,
    "amount_formatted": amountFormatted,
    "is_active": isActive,
    "expiration_date": expirationDate,
    "will_renew": willRenew,
    "purchased_at": purchasedAt,
    "created_at": createdAt,
  };
}