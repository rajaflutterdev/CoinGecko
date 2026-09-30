import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/coin_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> setData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .set(
        data,
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? 'Failed to save data',
      );
    } catch (e) {
      throw Exception(
        'Failed to save data: $e',
      );
    }
  }

  Future<List<CoinModel>> getAllData({
    required String collection,
    required String docName,
  }) async {
    try {
      final snapshot =
      await _firestore
          .collection(collection).doc(docName)
          .get();

      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.data();

      if (data == null) {
        return [];
      }

      final List<dynamic> coinsData = data['coins'] ?? [];

      return coinsData
          .map(
            (coin) => CoinModel.fromJson(
          Map<String, dynamic>.from(coin as Map),
        ),
      )
          .toList();

    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? 'Failed to get data',
      );
    } catch (e) {
      throw Exception(
        'Failed to get data: $e',
      );
    }
  }

}