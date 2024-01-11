import 'package:flutter/rendering.dart';

class CategoryInvoiceEntity {
  final String id;
  final int user;
  final String title;
  final String color;

  CategoryInvoiceEntity(
      {required this.id,
      required this.user,
      required this.title,
      required this.color});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'title': title,
      'color': color,
    };
  }
  CategoryInvoiceEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      user = json['user'],
      title = json['title'],
      color = json['color'];

}
