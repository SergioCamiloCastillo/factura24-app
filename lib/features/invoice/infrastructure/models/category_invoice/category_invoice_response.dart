// To parse this JSON data, do
//
//     final categoryInvoiceResponse = categoryInvoiceResponseFromJson(jsonString);

import 'dart:convert';

List<CategoryInvoiceResponse> categoryInvoiceResponseFromJson(String str) =>
    List<CategoryInvoiceResponse>.from(
        json.decode(str).map((x) => CategoryInvoiceResponse.fromJson(x)));

String categoryInvoiceResponseToJson(List<CategoryInvoiceResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryInvoiceResponse {
  final String id;
  final String title;
  final int user;
  final String color;

  CategoryInvoiceResponse({
    required this.id,
    required this.title,
    required this.user,
    required this.color,
  });

  factory CategoryInvoiceResponse.fromJson(Map<String, dynamic> json) =>
      CategoryInvoiceResponse(
        id: json["id"],
        title: json["title"],
        user: json["user"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "user": user,
        "color": color,
      };
}
