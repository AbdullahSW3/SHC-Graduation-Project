import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {


  static void updateAvailabilityDoctors(List<String> documentIds) {
    final _firestore = FirebaseFirestore.instance;
    final field = FieldPath(['date_time']);
    try {
      _firestore
          .collection('doctors')
          .doc(documentIds[0])
          .update({field: DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  static void updateAvailabilityUsers(List<String> documentIds) {
    final _firestore = FirebaseFirestore.instance;
    final field = FieldPath(['date_time']);
    try {
      _firestore
          .collection('users')
          .doc(documentIds[0])
          .update({field: DateTime.now()});
    } catch (e) {
      print(e);
    }
  }



}
