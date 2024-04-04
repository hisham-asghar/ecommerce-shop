class OrderPaymentIntent {
  OrderPaymentIntent({
    required this.ephemeralKey,
    required this.paymentIntent,
    required this.customer,
  });
  final String ephemeralKey;
  final String paymentIntent;
  final String customer;

  OrderPaymentIntent copyWith({
    String? ephemeralKey,
    String? paymentIntent,
    String? customer,
  }) {
    return OrderPaymentIntent(
      ephemeralKey: ephemeralKey ?? this.ephemeralKey,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      customer: customer ?? this.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ephemeralKey': ephemeralKey,
      'paymentIntent': paymentIntent,
      'customer': customer,
    };
  }

  factory OrderPaymentIntent.fromMap(Map<String, dynamic> map) {
    return OrderPaymentIntent(
      ephemeralKey: map['ephemeralKey'],
      paymentIntent: map['paymentIntent'],
      customer: map['customer'],
    );
  }

  @override
  String toString() =>
      'OrderPaymentIntent(ephemeralKey: $ephemeralKey, paymentIntent: $paymentIntent, customer: $customer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderPaymentIntent &&
        other.ephemeralKey == ephemeralKey &&
        other.paymentIntent == paymentIntent &&
        other.customer == customer;
  }

  @override
  int get hashCode =>
      ephemeralKey.hashCode ^ paymentIntent.hashCode ^ customer.hashCode;
}
