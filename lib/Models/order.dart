import 'cart_item.dart';

class Order {
  final int id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}