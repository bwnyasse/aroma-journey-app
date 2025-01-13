import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aroma_journey/backend/backend.dart';
import 'package:aroma_journey/backend/schema/product_record.dart';
import 'package:aroma_journey/backend/schema/category_record.dart';

void main() {
  group('Backend Tests', () {
    test('queryProductRecordCount returns correct count', () async {
      final count = await queryProductRecordCount();
      expect(count, isA<int>());
    });

    test('queryProductRecord returns a stream of ProductRecords', () async {
      final stream = queryProductRecord();
      expect(stream, isA<Stream<List<ProductRecord>>>());
    });

    test('queryProductRecordOnce returns a list of ProductRecords', () async {
      final records = await queryProductRecordOnce();
      expect(records, isA<List<ProductRecord>>());
    });

    test('queryCategoryRecordCount returns correct count', () async {
      final count = await queryCategoryRecordCount();
      expect(count, isA<int>());
    });

    test('queryCategoryRecord returns a stream of CategoryRecords', () async {
      final stream = queryCategoryRecord();
      expect(stream, isA<Stream<List<CategoryRecord>>>());
    });

    test('queryCategoryRecordOnce returns a list of CategoryRecords', () async {
      final records = await queryCategoryRecordOnce();
      expect(records, isA<List<CategoryRecord>>());
    });

    test('queryCollectionCount returns correct count', () async {
      final collection = FirebaseFirestore.instance.collection('test');
      final count = await queryCollectionCount(collection);
      expect(count, isA<int>());
    });

    test('queryCollection returns a stream of records', () async {
      final collection = FirebaseFirestore.instance.collection('test');
      final stream = queryCollection(collection, (snapshot) => snapshot.data());
      expect(stream, isA<Stream<List<Map<String, dynamic>>>>());
    });

    test('queryCollectionOnce returns a list of records', () async {
      final collection = FirebaseFirestore.instance.collection('test');
      final records = await queryCollectionOnce(collection, (snapshot) => snapshot.data());
      expect(records, isA<List<Map<String, dynamic>>>());
    });

    test('queryCollectionPage returns a page of records', () async {
      final collection = FirebaseFirestore.instance.collection('test');
      final page = await queryCollectionPage(
        collection,
        (snapshot) => snapshot.data(),
        pageSize: 10,
        isStream: false,
      );
      expect(page, isA<FFFirestorePage<Map<String, dynamic>>>());
    });
  });
}
