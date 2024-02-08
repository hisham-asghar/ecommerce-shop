import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/models/app_user.dart';

@immutable
class FakeAppUser implements AppUser {
  const FakeAppUser({
    required this.uid,
    this.email,
  });
  // True if user is an admin
  @override
  final String uid;

  @override
  final String? email;

  @override
  Future<bool> isAdminUser() => Future.value(true);

  FakeAppUser copyWith({
    String? uid,
    String? email,
  }) {
    return FakeAppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'MockAppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FakeAppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
