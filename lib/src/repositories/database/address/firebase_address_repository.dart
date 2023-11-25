import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address_repository.dart';

class FirebaseAddressRepository implements AddressRepository {
  FirebaseAddressRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String addressPath(String uid) => 'users/$uid/private/address';

  @override
  Future<Address?> getAddress(String uid) async {
    final ref = _addressRef(uid);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  @override
  Stream<Address?> address(String uid) {
    final ref = _addressRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Future<void> submitAddress(String uid, Address address) {
    return _addressRef(uid).set(address);
  }

  DocumentReference<Address> _addressRef(String uid) =>
      _firestore.doc(addressPath(uid)).withConverter(
            fromFirestore: (doc, _) => Address.fromMap(doc.data()!),
            toFirestore: (Address address, options) => address.toMap(),
          );
}
