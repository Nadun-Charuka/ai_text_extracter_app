import 'package:ai_text_extracter_app/models/conversion_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class StoreConversionsFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //save converstions
  Future<void> storeConversionData(
      {required conversionData, required conversionDate}) async {
    try {
      //check is there existing user
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }
      final userId = _firebaseAuth.currentUser!.uid;

      //create a reference to the collection in the firestore
      CollectionReference conversion =
          _firebaseFirestore.collection('conversions');

      //data
      final ConversionModel conversionModel = ConversionModel(
        userId: userId,
        conversionData: conversionData,
        conversionDate: conversionDate,
      );

      //strore data
      await conversion.add(conversionModel.toJson());
      debugPrint("Data stored");
    } catch (e) {
      debugPrint("Error from firestore $e");
    }
  }

  //method to get all conversions documents for the current user (Strem)
  Stream<List<ConversionModel>> getUserConversions() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firebaseFirestore
        .collection("conversions")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => ConversionModel.fromJson(doc.data()))
            .toList();
      } catch (e) {
        debugPrint("Error parsing conversions: $e");
        return []; // Return an empty list if an error occurs
      }
    });
  }
}
