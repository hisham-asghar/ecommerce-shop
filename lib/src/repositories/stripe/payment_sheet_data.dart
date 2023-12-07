class PaymentSheetData {
  PaymentSheetData({
    required this.paymentIntent,
    required this.ephemeralKey,
  });
  final String paymentIntent;
  final String ephemeralKey;

  factory PaymentSheetData.fromMap(Map<String, dynamic> map) {
    return PaymentSheetData(
      paymentIntent: map['paymentIntent'],
      ephemeralKey: map['ephemeralKey'],
    );
  }

  @override
  String toString() =>
      'PaymentSheetData(paymentIntent: $paymentIntent, ephemeralKey: $ephemeralKey)';
}
