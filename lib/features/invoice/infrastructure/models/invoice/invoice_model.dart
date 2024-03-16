

import 'dart:convert';

List<InvoiceResponse> invoiceResponseFromJson(String str) => List<InvoiceResponse>.from(json.decode(str).map((x) => InvoiceResponse.fromJson(x)));

String invoiceResponseToJson(List<InvoiceResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceResponse {
    final String id;
    final String description;
    final int userId;
    final int categoryId;
    final String createdAt;
    final String attachmentUrl;

    InvoiceResponse({
        required this.id,
        required this.description,
        required this.userId,
        required this.categoryId,
        required this.createdAt,
        required this.attachmentUrl,
    });

    factory InvoiceResponse.fromJson(Map<String, dynamic> json) => InvoiceResponse(
        id: json["id"],
        description: json["description"],
        userId: json["userId"],
        categoryId: json["categoryId"],
        createdAt: DateTime.parse(json["createdAt"]).toString(),
        attachmentUrl: json["attachmentUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "userId": userId,
        "categoryId": categoryId,
        "createdAt": createdAt.toString(),
        "attachmentUrl": attachmentUrl,
    };
}
