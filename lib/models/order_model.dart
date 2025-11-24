class Order {
  final int id;
  final int userId;
  final int carId;
  final String carName;
  final String carImage;
  final String startDate;
  final String endDate;
  final String pickupTime;
  final String status;
  final double amount;
  final String currency;
  final String method;
  final String receiptPath;

  Order({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.carImage,
    required this.startDate,
    required this.endDate,
    required this.pickupTime,
    required this.status,
    required this.amount,
    required this.currency,
    required this.method,
    this.receiptPath = '',
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['order_id'] ?? map['id'] ?? 0,
      userId: map['user_id'] ?? 0,
      carId: map['car_id'] ?? 0,
      carName: map['car_name'] ?? '',
      carImage: map['car_image'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      pickupTime: map['pickup_time'] ?? '',
      status: map['status'] ?? '',
      method: map['method'] ?? '-',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'IDR',
      receiptPath: map['pdf_path'] ?? '',
    );
  }

  double get totalPrice => amount;
}
