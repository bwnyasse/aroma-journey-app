# this one is an export of the lib/ of a previous project in which I used FlutterFlow and FlutterModular to build a coffee app : Code Source Bellow
## Directory Structure
```
lib
├── backend
│   ├── backend.dart
│   ├── firebase
│   │   └── firebase_options.dart
│   ├── palm
│   │   └── palm_util.dart
│   └── schema
│       ├── category_record.dart
│       ├── firestore.indexes.json
│       ├── firestore.rules
│       ├── other
│       ├── product_record.dart
│       └── util
│           ├── firestore_util.dart
│           └── schema_util.dart
├── extra
│   └── flutter_flow
│       ├── custom_functions.dart
│       ├── flutter_flow_animations.dart
│       ├── flutter_flow_choice_chips.dart
│       ├── flutter_flow_icon_button.dart
│       ├── flutter_flow_model.dart
│       ├── flutter_flow_theme.dart
│       ├── flutter_flow_toggle_icon.dart
│       ├── flutter_flow_util.dart
│       ├── flutter_flow_widgets.dart
│       ├── form_field_controller.dart
│       ├── internationalization.dart
│       ├── lat_lng.dart
│       ├── place.dart
│       └── uploaded_file.dart
├── main.dart
├── main_module.dart
├── main_widget.dart
├── modules
│   ├── auth
│   │   ├── auth_module.dart
│   │   ├── auth_service.dart
│   │   ├── bloc
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── model
│   │   │   └── user.dart
│   │   └── pages
│   │       ├── auth_page.dart
│   │       └── login_widget.dart
│   ├── favorite
│   ├── home
│   │   ├── hello.dart 17-13-11-726.dart
│   │   ├── home_module.dart
│   │   ├── pages
│   │   │   ├── home_model.dart
│   │   │   └── home_page.dart
│   │   └── widgets
│   │       ├── home_categories_widget.dart
│   │       └── home_header_widget.dart
│   ├── product
│   │   ├── bloc
│   │   │   ├── product_bloc.dart
│   │   │   ├── product_event.dart
│   │   │   └── product_state.dart
│   │   ├── model
│   │   │   └── product_invention_model.dart
│   │   ├── pages
│   │   │   ├── product_invention_page.dart
│   │   │   ├── product_model.dart
│   │   │   └── product_page.dart
│   │   ├── product_module.dart
│   │   ├── product_service.dart
│   │   └── widgets
│   ├── quizz
│   │   ├── pages
│   │   │   └── quizz_pages.dart
│   │   ├── quizz_module.dart
│   │   └── quizz_service.dart
│   ├── shared
│   │   ├── loading_indicator.dart
│   │   ├── navbar_page.dart
│   │   └── shared.dart
│   └── splash
│       └── splash_page.dart
└── services

28 directories, 56 files
```

 ## lib
 ## backend
 ### backend.dart
 ```dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema/util/firestore_util.dart';

import 'schema/product_record.dart';
import 'schema/category_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';
export 'package:flutter/material.dart' show Color, Colors;
export 'schema/product_record.dart';
export 'schema/category_record.dart';

/// Functions to query ProductRecords (as a Stream and as a Future).
Future<int> queryProductRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ProductRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ProductRecord>> queryProductRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ProductRecord.collection,
      ProductRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ProductRecord>> queryProductRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ProductRecord.collection,
      ProductRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CategoryRecords (as a Stream and as a Future).
Future<int> queryCategoryRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CategoryRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CategoryRecord>> queryCategoryRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CategoryRecord.collection,
      CategoryRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CategoryRecord>> queryCategoryRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CategoryRecord.collection,
      CategoryRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
  }).then((value) => value.count);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}
 ```

 ## firebase
 ### firebase_options.dart
 ```dart
// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBF-cbdkMHIePHIKeJfQH4IRVZMQTCddW0',
    appId: '1:167171721391:web:990d0f904cdb73f8e46c5a',
    messagingSenderId: '167171721391',
    projectId: 'aroma-journey-8f041',
    authDomain: 'aroma-journey-8f041.firebaseapp.com',
    storageBucket: 'aroma-journey-8f041.appspot.com',
    measurementId: 'G-82RXXC0QKC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqPwK-vDHh7VTncWalLyQLcM6RLTl3JkU',
    appId: '1:167171721391:android:c2b3adf5b11cc305e46c5a',
    messagingSenderId: '167171721391',
    projectId: 'aroma-journey-8f041',
    storageBucket: 'aroma-journey-8f041.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDd4xow242Df97ixJy8_X_TW3kBp3_4gDw',
    appId: '1:167171721391:ios:1d6d3b47d23634eee46c5a',
    messagingSenderId: '167171721391',
    projectId: 'aroma-journey-8f041',
    storageBucket: 'aroma-journey-8f041.appspot.com',
    iosClientId: '167171721391-c1rb66bjdqav4m65qckr6ikq6e3a5b91.apps.googleusercontent.com',
    iosBundleId: 'net.bwnyasse.aromaJourney',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDd4xow242Df97ixJy8_X_TW3kBp3_4gDw',
    appId: '1:167171721391:ios:1d6d3b47d23634eee46c5a',
    messagingSenderId: '167171721391',
    projectId: 'aroma-journey-8f041',
    storageBucket: 'aroma-journey-8f041.appspot.com',
    iosClientId: '167171721391-c1rb66bjdqav4m65qckr6ikq6e3a5b91.apps.googleusercontent.com',
    iosBundleId: 'net.bwnyasse.aromaJourney',
  );
}
 ```

 ## palm
 ### palm_util.dart
 ```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_language_api/google_generative_language_api.dart';

class PaLMUtil {
  /// Generates text from a prompt using the PaLM 2.0 model.
  static Future<String> generateTextFormPaLM({
    required String exampleInput1,
    required String exampleOutput1,
    required String exampleInput2,
    required String exampleOutput2,
    required String exampleInput3,
    required String exampleOutput3,
    required String input,
  }) async {
    /// The API key is stored in the local .env file. Create one if you want to run
    /// this example or replace this apiKey with your own.
    ///
    /// DO NOT PUBLICLY SHARE YOUR API KEY.
    /// .env file should have a line that looks like this:
    ///
    /// API_KEY=<PALM_API_KEY>
    ///
    String apiKey = dotenv.env['PALM_API_KEY']!;

    // PaLM 2.0 model
    String textModel = 'models/text-bison-001';

    // Construct the prompt string with input examples
    String promptString = '''input: $exampleInput1
    output: $exampleOutput1
    
    input: $exampleInput2
    output: $exampleOutput2
    
    input: $exampleInput3
    output: $exampleOutput3
    
    input: $input
    output:''';

    // Configure the text generation request
    GenerateTextRequest textRequest = GenerateTextRequest(
        prompt: TextPrompt(text: promptString),
        // optional, 0.0 always uses the highest-probability result
        temperature: 0.7,
        // optional, how many candidate results to generate
        candidateCount: 1,
        // optional, number of most probable tokens to consider for generation
        topK: 40,
        // optional, for nucleus sampling decoding strategy
        topP: 0.95,
        // optional, maximum number of output tokens to generate
        maxOutputTokens: 1024,
        // optional, sequences at which to stop model generation
        stopSequences: [],
        // optional, safety settings
        safetySettings: const [
          // Define safety settings to filter out harmful content
          SafetySetting(
              category: HarmCategory.derogatory,
              threshold: HarmBlockThreshold.lowAndAbove),
          SafetySetting(
              category: HarmCategory.toxicity,
              threshold: HarmBlockThreshold.lowAndAbove),
          SafetySetting(
              category: HarmCategory.violence,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.sexual,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.medical,
              threshold: HarmBlockThreshold.mediumAndAbove),
          SafetySetting(
              category: HarmCategory.dangerous,
              threshold: HarmBlockThreshold.mediumAndAbove),
        ]);

    // Call the PaLM API to generate text
    final GeneratedText response = await GenerativeLanguageAPI.generateText(
      modelName: textModel,
      request: textRequest,
      apiKey: apiKey,
    );

    // Extract and return the generated text
    if (response.candidates.isNotEmpty) {
      TextCompletion candidate = response.candidates.first;
      return candidate.output;
    }
    return '';
  }
}
 ```

 ## schema
 ### category_record.dart
 ```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import 'package:collection/collection.dart';

class CategoryRecord extends FirestoreRecord {
  CategoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('category');

  static Stream<CategoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CategoryRecord.fromSnapshot(s));

  static Future<CategoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CategoryRecord.fromSnapshot(s));

  static CategoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CategoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CategoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CategoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CategoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CategoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCategoryRecordData({
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class CategoryRecordDocumentEquality implements Equality<CategoryRecord> {
  const CategoryRecordDocumentEquality();

  @override
  bool equals(CategoryRecord? e1, CategoryRecord? e2) {
    return e1?.name == e2?.name;
  }

  @override
  int hash(CategoryRecord? e) => const ListEquality().hash([e?.name]);

  @override
  bool isValidKey(Object? o) => o is CategoryRecord;
}
 ```

 ### firestore.indexes.json
 ```dart
{
  "indexes": []
} ```

 ### firestore.rules
 ```dart
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /product/{document} {
      allow create: if true;
      allow read: if true;
      allow write: if false;
      allow delete: if false;
    }

    match /category/{document} {
      allow create: if true;
      allow read: if true;
      allow write: if false;
      allow delete: if false;
    }
  }
}
 ```

 ## other
 ### product_record.dart
 ```dart
import 'package:aroma_journey/backend/schema/util/firestore_util.dart';
import 'package:aroma_journey/backend/schema/util/schema_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ProductRecord extends FirestoreRecord {

  ProductRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "info" field.
  String? _info;
  String get info => _info ?? '';
  bool hasInfo() => _info != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "category_name" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? '';
  bool hasCategoryName() => _categoryName != null;

  // "category_ref" field.
  DocumentReference? _categoryRef;
  DocumentReference? get categoryRef => _categoryRef;
  bool hasCategoryRef() => _categoryRef != null;

  // "isLiked" field.
  bool? _isLiked;
  bool get isLiked => _isLiked ?? false;
  bool hasIsLiked() => _isLiked != null;

  // "offer_description" field.
  String? _offerDescription;
  String get offerDescription => _offerDescription ?? '';
  bool hasOfferDescription() => _offerDescription != null;

  // "isOffer" field.
  bool? _isOffer;
  bool get isOffer => _isOffer ?? false;
  bool hasIsOffer() => _isOffer != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _info = snapshotData['info'] as String?;
    _image = snapshotData['image'] as String?;
    _categoryName = snapshotData['category_name'] as String?;
    _categoryRef = snapshotData['category_ref'] as DocumentReference?;
    _isLiked = snapshotData['isLiked'] as bool?;
    _offerDescription = snapshotData['offer_description'] as String?;
    _isOffer = snapshotData['isOffer'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('product');

  static Stream<ProductRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductRecord.fromSnapshot(s));

  static Future<ProductRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductRecord.fromSnapshot(s));

  static ProductRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductRecordData({
  String? name,
  String? info,
  String? image,
  String? categoryName,
  DocumentReference? categoryRef,
  bool? isLiked,
  String? offerDescription,
  bool? isOffer,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'info': info,
      'image': image,
      'category_name': categoryName,
      'category_ref': categoryRef,
      'isLiked': isLiked,
      'offer_description': offerDescription,
      'isOffer': isOffer,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductRecordDocumentEquality implements Equality<ProductRecord> {
  const ProductRecordDocumentEquality();

  @override
  bool equals(ProductRecord? e1, ProductRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.info == e2?.info &&
        e1?.image == e2?.image &&
        e1?.categoryName == e2?.categoryName &&
        e1?.categoryRef == e2?.categoryRef &&
        e1?.isLiked == e2?.isLiked &&
        e1?.offerDescription == e2?.offerDescription &&
        e1?.isOffer == e2?.isOffer;
  }

  @override
  int hash(ProductRecord? e) => const ListEquality().hash([
        e?.name,
        e?.info,
        e?.image,
        e?.categoryName,
        e?.categoryRef,
        e?.isLiked,
        e?.offerDescription,
        e?.isOffer
      ]);

  @override
  bool isValidKey(Object? o) => o is ProductRecord;
}
 ```

 ## util
 ### firestore_util.dart
 ```dart
import 'package:aroma_journey/backend/schema/util/schema_util.dart';
import 'package:aroma_journey/extra/flutter_flow/lat_lng.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

typedef RecordBuilder<T> = T Function(DocumentSnapshot snapshot);

abstract class FirestoreRecord {
  FirestoreRecord(this.reference, this.snapshotData);
  Map<String, dynamic> snapshotData;
  DocumentReference reference;
}

abstract class FFFirebaseStruct extends BaseStruct {
  FFFirebaseStruct(this.firestoreUtilData);

  /// Utility class for Firestore updates
  FirestoreUtilData firestoreUtilData = const FirestoreUtilData();
}

class FirestoreUtilData {
  const FirestoreUtilData({
    this.fieldValues = const {},
    this.clearUnsetFields = true,
    this.create = false,
    this.delete = false,
  });
  final Map<String, dynamic> fieldValues;
  final bool clearUnsetFields;
  final bool create;
  final bool delete;
  static String get name => 'firestoreUtilData';
}

Map<String, dynamic> mapFromFirestore(Map<String, dynamic> data) =>
    mergeNestedFields(data)
        .where((k, _) => k != FirestoreUtilData.name)
        .map((key, value) {
      // Handle Timestamp
      if (value is Timestamp) {
        value = value.toDate();
      }
      // Handle list of Timestamp
      if (value is Iterable && value.isNotEmpty && value.first is Timestamp) {
        value = value.map((v) => (v as Timestamp).toDate()).toList();
      }
      // Handle GeoPoint
      if (value is GeoPoint) {
        value = value.toLatLng();
      }
      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is GeoPoint) {
        value = value.map((v) => (v as GeoPoint).toLatLng()).toList();
      }
      // Handle nested data.
      if (value is Map) {
        value = mapFromFirestore(value as Map<String, dynamic>);
      }
      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

Map<String, dynamic> mapToFirestore(Map<String, dynamic> data) =>
    data.where((k, v) => k != FirestoreUtilData.name).map((key, value) {
      // Handle GeoPoint
      if (value is LatLng) {
        value = value.toGeoPoint();
      }
      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is LatLng) {
        value = value.map((v) => (v as LatLng).toGeoPoint()).toList();
      }
      // Handle Color
      if (value is Color) {
        value = value.toCssString();
      }
      // Handle list of Color
      if (value is Iterable && value.isNotEmpty && value.first is Color) {
        value = value.map((v) => (v as Color).toCssString()).toList();
      }
      // Handle nested data.
      if (value is Map) {
        value = mapFromFirestore(value as Map<String, dynamic>);
      }
      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

List<GeoPoint>? convertToGeoPointList(List<LatLng>? list) =>
    list?.map((e) => e.toGeoPoint()).toList();

extension GeoPointExtension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

extension LatLngExtension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

DocumentReference toRef(String ref) => FirebaseFirestore.instance.doc(ref);

T? safeGet<T>(T Function() func, [Function(dynamic)? reportError]) {
  try {
    return func();
  } catch (e) {
    reportError?.call(e);
  }
  return null;
}

Map<String, dynamic> mergeNestedFields(Map<String, dynamic> data) {
  final nestedData = data.where((k, _) => k.contains('.'));
  final fieldNames = nestedData.keys.map((k) => k.split('.').first).toSet();
  // Remove nested values (e.g. 'foo.bar') and merge them into a map.
  data.removeWhere((k, _) => k.contains('.'));
  fieldNames.forEach((name) {
    final mergedValues = mergeNestedFields(
      nestedData
          .where((k, _) => k.split('.').first == name)
          .map((k, v) => MapEntry(k.split('.').skip(1).join('.'), v)),
    );
    final existingValue = data[name];
    data[name] = {
      if (existingValue != null && existingValue is Map)
        ...existingValue as Map<String, dynamic>,
      ...mergedValues,
    };
  });
  // Merge any nested maps inside any of the fields as well.
  data.where((_, v) => v is Map).forEach((k, v) {
    data[k] = mergeNestedFields(v as Map<String, dynamic>);
  });

  return data;
}

extension _WhereMapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K, V) test) =>
      Map.fromEntries(entries.where((e) => test(e.key, e.value)));
}
 ```

 ### schema_util.dart
 ```dart
import 'dart:convert';

import 'package:aroma_journey/extra/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

typedef StructBuilder<T> = T Function(Map<String, dynamic> data);

abstract class BaseStruct {
  Map<String, dynamic> toSerializableMap();
  String serialize() => json.encode(toSerializableMap());
}

List<T>? getStructList<T>(
  dynamic value,
  StructBuilder<T> structBuilder,
) =>
    value is! List
        ? null
        : value
            .whereType<Map<String, dynamic>>()
            .map((e) => structBuilder(e))
            .toList();

Color? getSchemaColor(dynamic value) => value is String
    ? fromCssColor(value)
    : value is Color
        ? value
        : null;

List<Color>? getColorsList(dynamic value) =>
    value is! List ? null : value.map(getSchemaColor).withoutNulls;

List<T>? getDataList<T>(dynamic value) =>
    value is! List ? null : value.map((e) => castToType<T>(e)!).toList();

T? castToType<T>(dynamic value) {
  if (value == null) {
    return null;
  }
  switch (T) {
    case double:
      // Doubles may be stored as ints in some cases.
      return value.toDouble() as T;
    case int:
      // Likewise, ints may be stored as doubles. If this is the case
      // (i.e. no decimal value), return the value as an int.
      if (value is num && value.toInt() == value) {
        return value.toInt() as T;
      }
      break;
    default:
      break;
  }
  return value as T;
}

extension MapDataExtensions on Map<String, dynamic> {
  Map<String, dynamic> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}
 ```

 ## extra
 ## flutter_flow
 ### custom_functions.dart
 ```dart


double returncartprice(double value) {
  return value * -1;
}
 ```

 ### flutter_flow_animations.dart
 ```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AnimationTrigger {
  onPageLoad,
  onActionTrigger,
}

class AnimationInfo {
  AnimationInfo({
    required this.trigger,
    required this.effects,
    this.loop = false,
    this.reverse = false,
    this.applyInitialState = true,
  });
  final AnimationTrigger trigger;
  final List<Effect<dynamic>> effects;
  final bool applyInitialState;
  final bool loop;
  final bool reverse;
  late AnimationController controller;
}

void createAnimation(AnimationInfo animation, TickerProvider vsync) {
  final newController = AnimationController(vsync: vsync);
  animation.controller = newController;
}

void setupAnimations(Iterable<AnimationInfo> animations, TickerProvider vsync) {
  animations.forEach((animation) => createAnimation(animation, vsync));
}

extension AnimatedWidgetExtension on Widget {
  Widget animateOnPageLoad(AnimationInfo animationInfo) => Animate(
      effects: animationInfo.effects,
      child: this,
      onPlay: (controller) => animationInfo.loop
          ? controller.repeat(reverse: animationInfo.reverse)
          : null,
      onComplete: (controller) => !animationInfo.loop && animationInfo.reverse
          ? controller.reverse()
          : null);

  Widget animateOnActionTrigger(
    AnimationInfo animationInfo, {
    bool hasBeenTriggered = false,
  }) =>
      hasBeenTriggered || animationInfo.applyInitialState
          ? Animate(
              controller: animationInfo.controller,
              autoPlay: false,
              effects: animationInfo.effects,
              child: this)
          : this;
}

class TiltEffect extends Effect<Offset> {
  const TiltEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? const Offset(0.0, 0.0),
          end: end ?? const Offset(0.0, 0.0),
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<Offset> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (_, __) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(animation.value.dx)
          ..rotateY(animation.value.dy),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
 ```

 ### flutter_flow_choice_chips.dart
 ```dart
import 'form_field_controller.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChipData {
  const ChipData(this.label, [this.iconData]);
  final String label;
  final IconData? iconData;
}

class ChipStyle {
  const ChipStyle({
    this.backgroundColor,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.labelPadding,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? labelPadding;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
}

class FlutterFlowChoiceChips extends StatefulWidget {
  const FlutterFlowChoiceChips({
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.selectedChipStyle,
    required this.unselectedChipStyle,
    required this.chipSpacing,
    this.rowSpacing = 0.0,
    required this.multiselect,
    this.initialized = true,
    this.alignment = WrapAlignment.start,
    this.disabledColor,
  });

  final List<ChipData> options;
  final void Function(List<String>?)? onChanged;
  final FormFieldController<List<String>> controller;
  final ChipStyle selectedChipStyle;
  final ChipStyle unselectedChipStyle;
  final double chipSpacing;
  final double rowSpacing;
  final bool multiselect;
  final bool initialized;
  final WrapAlignment alignment;
  final Color? disabledColor;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  late List<String> choiceChipValues;
  ValueListenable<List<String>?> get changeSelectedValues => widget.controller;
  List<String> get selectedValues => widget.controller.value ?? [];

  @override
  void initState() {
    super.initState();
    choiceChipValues = List.from(widget.controller.initialValue ?? []);
    if (!widget.initialized && choiceChipValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(choiceChipValues);
          }
        },
      );
    }
    changeSelectedValues.addListener(() {
      if (!listEquals(choiceChipValues, selectedValues)) {
        setState(() => choiceChipValues = List.from(selectedValues));
      }
      if (widget.onChanged != null) {
        widget.onChanged!(selectedValues);
      }
    });
  }

  @override
  void dispose() {
    changeSelectedValues.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: widget.chipSpacing,
        runSpacing: widget.rowSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...widget.options.map(
            (option) {
              final selected = choiceChipValues.contains(option.label);
              final style = selected
                  ? widget.selectedChipStyle
                  : widget.unselectedChipStyle;
              return ChoiceChip(
                selected: selected,
                onSelected: widget.onChanged != null
                    ? (isSelected) {
                        if (isSelected) {
                          widget.multiselect
                              ? choiceChipValues.add(option.label)
                              : choiceChipValues = [option.label];
                          widget.controller.value = List.from(choiceChipValues);
                          setState(() {});
                        } else {
                          if (widget.multiselect) {
                            choiceChipValues.remove(option.label);
                            widget.controller.value =
                                List.from(choiceChipValues);
                            setState(() {});
                          }
                        }
                      }
                    : null,
                label: Text(
                  option.label,
                  style: style.textStyle,
                ),
                labelPadding: style.labelPadding,
                avatar: option.iconData != null
                    ? FaIcon(
                        option.iconData,
                        size: style.iconSize,
                        color: style.iconColor,
                      )
                    : null,
                elevation: style.elevation,
                disabledColor: widget.disabledColor,
                selectedColor:
                    selected ? widget.selectedChipStyle.backgroundColor : null,
                backgroundColor: selected
                    ? null
                    : widget.unselectedChipStyle.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: style.borderRadius ?? BorderRadius.circular(16),
                  side: BorderSide(
                    color: style.borderColor ?? Colors.transparent,
                    width: style.borderWidth ?? 0,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ).toList(),
        ],
      );
}
 ```

 ### flutter_flow_icon_button.dart
 ```dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlutterFlowIconButton extends StatefulWidget {
  const FlutterFlowIconButton({
    Key? key,
    required this.icon,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.fillColor,
    this.disabledColor,
    this.disabledIconColor,
    this.hoverColor,
    this.hoverIconColor,
    this.onPressed,
    this.showLoadingIndicator = false,
  }) : super(key: key);

  final Widget icon;
  final double? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Color? disabledColor;
  final Color? disabledIconColor;
  final Color? hoverColor;
  final Color? hoverIconColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showLoadingIndicator;
  final Function()? onPressed;

  @override
  State<FlutterFlowIconButton> createState() => _FlutterFlowIconButtonState();
}

class _FlutterFlowIconButtonState extends State<FlutterFlowIconButton> {
  bool loading = false;
  late double? iconSize;
  late Color? iconColor;
  late Widget effectiveIcon;

  @override
  void initState() {
    super.initState();
    _updateIcon();
  }

  @override
  void didUpdateWidget(FlutterFlowIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateIcon();
  }

  void _updateIcon() {
    final isFontAwesome = widget.icon is FaIcon;
    if (isFontAwesome) {
      FaIcon icon = widget.icon as FaIcon;
      effectiveIcon = FaIcon(
        icon.icon,
        size: icon.size,
      );
      iconSize = icon.size;
      iconColor = icon.color;
    } else {
      Icon icon = widget.icon as Icon;
      effectiveIcon = Icon(
        icon.icon,
        size: icon.size,
      );
      iconSize = icon.size;
      iconColor = icon.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            side: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0,
            ),
          );
        },
      ),
      iconColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled) &&
              widget.disabledIconColor != null) {
            return widget.disabledIconColor;
          }
          if (states.contains(MaterialState.hovered) &&
              widget.hoverIconColor != null) {
            return widget.hoverIconColor;
          }
          return iconColor;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled) &&
              widget.disabledColor != null) {
            return widget.disabledColor;
          }
          if (states.contains(MaterialState.hovered) &&
              widget.hoverColor != null) {
            return widget.hoverColor;
          }

          return widget.fillColor;
        },
      ),
    );

    return SizedBox(
      width: widget.buttonSize,
      height: widget.buttonSize,
      child: Theme(
        data: Theme.of(context).copyWith(useMaterial3: true),
        child: IgnorePointer(
          ignoring: (widget.showLoadingIndicator && loading),
          child: IconButton(
            icon: (widget.showLoadingIndicator && loading)
                ? Container(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        iconColor ?? Colors.white,
                      ),
                    ),
                  )
                : effectiveIcon,
            onPressed: widget.onPressed == null
                ? null
                : () async {
                    if (loading) {
                      return;
                    }
                    setState(() => loading = true);
                    try {
                      await widget.onPressed!();
                    } finally {
                      if (mounted) {
                        setState(() => loading = false);
                      }
                    }
                  },
            splashRadius: widget.buttonSize,
            style: style,
          ),
        ),
      ),
    );
  }
}
 ```

 ### flutter_flow_model.dart
 ```dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

Widget wrapWithModel<T extends FlutterFlowModel>({
  required T model,
  required Widget child,
  required VoidCallback updateCallback,
  bool updateOnChange = false,
}) {
  // Set the component to optionally update the page on updates.
  model.setOnUpdate(
    onUpdate: updateCallback,
    updateOnChange: updateOnChange,
  );
  // Models for components within a page will be disposed by the page's model,
  // so we don't want the component widget to dispose them until the page is
  // itself disposed.
  model.disposeOnWidgetDisposal = false;
  // Wrap in a Provider so that the model can be accessed by the component.
  return Provider<T>.value(
    value: model,
    child: child,
  );
}

T createModel<T extends FlutterFlowModel>(
  BuildContext context,
  T Function() defaultBuilder,
) {
  final model = context.read<T?>() ?? defaultBuilder();
  model._init(context);
  return model;
}

abstract class FlutterFlowModel {
  // Initialization methods
  bool _isInitialized = false;
  void initState(BuildContext context);
  void _init(BuildContext context) {
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
  }

  // Dispose methods
  // Whether to dispose this model when the corresponding widget is
  // disposed. By default this is true for pages and false for components,
  // as page/component models handle the disposal of their children.
  bool disposeOnWidgetDisposal = true;
  void dispose();
  void maybeDispose() {
    if (disposeOnWidgetDisposal) {
      dispose();
    }
  }

  // Whether to update the containing page / component on updates.
  bool updateOnChange = false;
  // Function to call when the model receives an update.
  VoidCallback _updateCallback = () {};
  void onUpdate() => updateOnChange ? _updateCallback() : () {};
  FlutterFlowModel setOnUpdate({
    bool updateOnChange = false,
    required VoidCallback onUpdate,
  }) =>
      this
        .._updateCallback = onUpdate
        ..updateOnChange = updateOnChange;
  // Update the containing page when this model received an update.
  void updatePage(VoidCallback callback) {
    callback();
    _updateCallback();
  }
}

class FlutterFlowDynamicModels<T extends FlutterFlowModel> {
  FlutterFlowDynamicModels(this.defaultBuilder);

  final T Function() defaultBuilder;
  final Map<String, T> _childrenModels = {};
  final Map<String, int> _childrenIndexes = {};
  Set<String>? _activeKeys;

  T getModel(String uniqueKey, int index) {
    _updateActiveKeys(uniqueKey);
    _childrenIndexes[uniqueKey] = index;
    return _childrenModels[uniqueKey] ??= defaultBuilder();
  }

  List<S> getValues<S>(S? Function(T) getValue) {
    return _childrenIndexes.entries
        // Sort keys by index.
        .sorted((a, b) => a.value.compareTo(b.value))
        .where((e) => _childrenModels[e.key] != null)
        // Map each model to the desired value and return as list. In order
        // to preserve index order, rather than removing null values we provide
        // default values (for types with reasonable defaults).
        .map((e) => getValue(_childrenModels[e.key]!) ?? _getDefaultValue<S>()!)
        .toList();
  }

  S? getValueAtIndex<S>(int index, S? Function(T) getValue) {
    final uniqueKey =
        _childrenIndexes.entries.firstWhereOrNull((e) => e.value == index)?.key;
    return getValueForKey(uniqueKey, getValue);
  }

  S? getValueForKey<S>(String? uniqueKey, S? Function(T) getValue) {
    final model = _childrenModels[uniqueKey];
    return model != null ? getValue(model) : null;
  }

  void dispose() => _childrenModels.values.forEach((model) => model.dispose());

  void _updateActiveKeys(String uniqueKey) {
    final shouldResetActiveKeys = _activeKeys == null;
    _activeKeys ??= {};
    _activeKeys!.add(uniqueKey);

    if (shouldResetActiveKeys) {
      // Add a post-frame callback to remove and dispose of unused models after
      // we're done building, then reset `_activeKeys` to null so we know to do
      // this again next build.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _childrenIndexes.removeWhere((k, _) => !_activeKeys!.contains(k));
        _childrenModels.keys
            .toSet()
            .difference(_activeKeys!)
            // Remove and dispose of unused models since they are  not being used
            // elsewhere and would not otherwise be disposed.
            .forEach((k) => _childrenModels.remove(k)?.dispose());
        _activeKeys = null;
      });
    }
  }
}

T? _getDefaultValue<T>() {
  switch (T) {
    case int:
      return 0 as T;
    case double:
      return 0.0 as T;
    case String:
      return '' as T;
    case bool:
      return false as T;
    default:
      return null as T;
  }
}

extension TextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? asValidator(BuildContext context) =>
      this != null ? (val) => this!(context, val) : null;
}
 ```

 ### flutter_flow_theme.dart
 ```dart
// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color primaryBtnText;
  late Color lineColor;
  late Color btnText;
  late Color customColor3;
  late Color customColor4;
  late Color white;
  late Color background;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF846046);
  late Color secondary = const Color(0xFF00731F);
  late Color tertiary = const Color(0xFFDCB5A1);
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryText = const Color(0xFF101213);
  late Color secondaryText = const Color(0xFF57636C);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0xFF616161);
  late Color accent2 = const Color(0xFF757575);
  late Color accent3 = const Color(0xFFE0E0E0);
  late Color accent4 = const Color(0xFFEEEEEE);
  late Color success = const Color(0xFF04A24C);
  late Color warning = const Color(0xFFFCDC0C);
  late Color error = const Color(0xFFE21C3D);
  late Color info = const Color(0xFF1C4494);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFFE0E3E7);
  late Color btnText = Color(0xFFFFFFFF);
  late Color customColor3 = Color(0xFFDF3F3F);
  late Color customColor4 = Color(0xFF090F13);
  late Color white = Color(0xFFFFFFFF);
  late Color background = Color(0xFF1D2429);
}

abstract class Typography {
  String get displayLargeFamily;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  TextStyle get bodySmall;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Poppins';
  TextStyle get displayLarge => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );
  String get displayMediumFamily => 'Poppins';
  TextStyle get displayMedium => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
      );
  String get displaySmallFamily => 'Poppins';
  TextStyle get displaySmall => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      );
  String get headlineLargeFamily => 'Poppins';
  TextStyle get headlineLarge => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Poppins';
  TextStyle get headlineMedium => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      );
  String get headlineSmallFamily => 'Poppins';
  TextStyle get headlineSmall => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      );
  String get titleLargeFamily => 'Poppins';
  TextStyle get titleLarge => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleMediumFamily => 'Poppins';
  TextStyle get titleMedium => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Poppins';
  TextStyle get titleSmall => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Poppins';
  TextStyle get labelLarge => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelMediumFamily => 'Poppins';
  TextStyle get labelMedium => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );
  String get labelSmallFamily => 'Poppins';
  TextStyle get labelSmall => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 11.0,
      );
  String get bodyLargeFamily => 'Poppins';
  TextStyle get bodyLarge => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Poppins';
  TextStyle get bodyMedium => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Poppins';
  TextStyle get bodySmall => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
 ```

 ### flutter_flow_toggle_icon.dart
 ```dart
import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  const ToggleIcon({
    required this.value,
    required this.onPressed,
    required this.onIcon,
    required this.offIcon,
  });

  final bool value;
  final Function() onPressed;
  final Widget onIcon;
  final Widget offIcon;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: value ? onIcon : offIcon,
      );
}
 ```

 ### flutter_flow_util.dart
 ```dart
import 'dart:io';

import 'package:aroma_journey/main_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:intl/intl.dart';
import 'package:json_path/json_path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

export 'dart:convert' show jsonEncode, jsonDecode;
export 'dart:math' show min, max;
export 'dart:typed_data' show Uint8List;

export 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FirebaseFirestore;
export 'package:intl/intl.dart';
export 'package:page_transition/page_transition.dart';

//export '../../app_state.dart';
export 'flutter_flow_model.dart';
export 'lat_lng.dart';
export 'place.dart';
export 'uploaded_file.dart';

T valueOrDefault<T>(T? value, T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    return timeago.format(dateTime, locale: locale, allowFromNow: true);
  }
  return DateFormat(format, locale).format(dateTime);
}

Future launchURL(String url) async {
  var uri = Uri.parse(url).toString();
  try {
    await launch(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

Color colorFromCssString(String color, {Color? defaultColor}) {
  try {
    return fromCssColor(color);
  } catch (_) {}
  return defaultColor ?? Colors.black;
}

enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

String formatNumber(
  num? value, {
  required FormatType formatType,
  DecimalType? decimalType,
  String? currency,
  bool toLowerCase = false,
  String? format,
  String? locale,
}) {
  if (value == null) {
    return '';
  }
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType!) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          break;
        case DecimalType.commaDecimal:
          formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

DateTime get getCurrentTimestamp => DateTime.now();
DateTime dateTimeFromSecondsSinceEpoch(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

extension DateTimeConversionExtension on DateTime {
  int get secondsSinceEpoch => (millisecondsSinceEpoch / 1000).round();
}

extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);
  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

dynamic getJsonField(
  dynamic response,
  String jsonPath, [
  bool isForList = false,
]) {
  final field = JsonPath(jsonPath).read(response);
  if (field.isEmpty) {
    return null;
  }
  if (field.length > 1) {
    return field.map((f) => f.value).toList();
  }
  final value = field.first.value;
  return isForList && value is! Iterable ? [value] : value;
}

Rect? getWidgetBoundingBox(BuildContext context) {
  try {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox!.localToGlobal(Offset.zero) & renderBox.size;
  } catch (_) {
    return null;
  }
}

bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isiOS => !kIsWeb && Platform.isIOS;
bool get isWeb => kIsWeb;

const kBreakpointSmall = 479.0;
const kBreakpointMedium = 767.0;
const kBreakpointLarge = 991.0;
bool isMobileWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kBreakpointSmall;
bool responsiveVisibility({
  required BuildContext context,
  bool phone = true,
  bool tablet = true,
  bool tabletLandscape = true,
  bool desktop = true,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < kBreakpointSmall) {
    return phone;
  } else if (width < kBreakpointMedium) {
    return tablet;
  } else if (width < kBreakpointLarge) {
    return tabletLandscape;
  } else {
    return desktop;
  }
}

const kTextValidatorUsernameRegex = r'^[a-zA-Z][a-zA-Z0-9_-]{2,16}$';
const kTextValidatorEmailRegex =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
const kTextValidatorWebsiteRegex =
    r'(https?:\/\/)?(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|(https?:\/\/)?(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';

extension FFTextEditingControllerExt on TextEditingController? {
  String get text => this == null ? '' : this!.text;
  set text(String newText) => this?.text = newText;
}

extension IterableExt<T> on Iterable<T> {
  List<S> mapIndexed<S>(S Function(int, T) func) => toList()
      .asMap()
      .map((index, value) => MapEntry(index, func(index, value)))
      .values
      .toList();
}

extension StringDocRef on String {
  DocumentReference get ref => FirebaseFirestore.instance.doc(this);
}

void setAppLanguage(BuildContext context, String language) =>
    MainWidget.of(context).setLocale(language);

void setDarkModeSetting(BuildContext context, ThemeMode themeMode) =>
    MainWidget.of(context).setThemeMode(themeMode);


void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: Container(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

extension FFStringExt on String {
  String maybeHandleOverflow({int? maxChars, String replacement = ''}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;
}

extension ListFilterExt<T> on Iterable<T?> {
  List<T> get withoutNulls => where((s) => s != null).map((e) => e!).toList();
}

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, t]).expand((i) => i).toList()
        ..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) =>
      enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) =>
      enumerate.map((e) => e.value).toList()..add(t);
}
 ```

 ### flutter_flow_widgets.dart
 ```dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
    this.hoverColor,
    this.hoverBorderSide,
    this.hoverTextColor,
    this.hoverElevation,
    this.maxLines,
  });

  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final int? maxLines;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color? hoverColor;
  final BorderSide? hoverBorderSide;
  final Color? hoverTextColor;
  final double? hoverElevation;
}

class FFButtonWidget extends StatefulWidget {
  const FFButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = true,
  }) : super(key: key);

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final Function()? onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;

  @override
  State<FFButtonWidget> createState() => _FFButtonWidgetState();
}

class _FFButtonWidgetState extends State<FFButtonWidget> {
  bool loading = false;

  int get maxLines => widget.options.maxLines ?? 1;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? Center(
            child: Container(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.options.textStyle!.color ?? Colors.white,
                ),
              ),
            ),
          )
        : AutoSizeText(
            widget.text,
            style: widget.options.textStyle?.withoutColor(),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          );

    final onPressed = widget.onPressed != null
        ? (widget.showLoadingIndicator
            ? () async {
                if (loading) {
                  return;
                }
                setState(() => loading = true);
                try {
                  await widget.onPressed!();
                } finally {
                  if (mounted) {
                    setState(() => loading = false);
                  }
                }
              }
            : () => widget.onPressed!())
        : null;

    ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) {
          if (states.contains(MaterialState.hovered) &&
              widget.options.hoverBorderSide != null) {
            return RoundedRectangleBorder(
              borderRadius:
                  widget.options.borderRadius ?? BorderRadius.circular(8),
              side: widget.options.hoverBorderSide!,
            );
          }
          return RoundedRectangleBorder(
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
            side: widget.options.borderSide ?? BorderSide.none,
          );
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled) &&
              widget.options.disabledTextColor != null) {
            return widget.options.disabledTextColor;
          }
          if (states.contains(MaterialState.hovered) &&
              widget.options.hoverTextColor != null) {
            return widget.options.hoverTextColor;
          }
          return widget.options.textStyle?.color;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled) &&
              widget.options.disabledColor != null) {
            return widget.options.disabledColor;
          }
          if (states.contains(MaterialState.hovered) &&
              widget.options.hoverColor != null) {
            return widget.options.hoverColor;
          }
          return widget.options.color;
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return widget.options.splashColor;
        }
        return null;
      }),
      padding: MaterialStateProperty.all(widget.options.padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0)),
      elevation: MaterialStateProperty.resolveWith<double?>(
        (states) {
          if (states.contains(MaterialState.hovered) &&
              widget.options.hoverElevation != null) {
            return widget.options.hoverElevation!;
          }
          return widget.options.elevation;
        },
      ),
    );

    if ((widget.icon != null || widget.iconData != null) && !loading) {
      return Container(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: widget.options.iconPadding ?? EdgeInsets.zero,
            child: widget.icon ??
                FaIcon(
                  widget.iconData,
                  size: widget.options.iconSize,
                  color: widget.options.iconColor ??
                      widget.options.textStyle!.color,
                ),
          ),
          label: textWidget,
          onPressed: onPressed,
          style: style,
        ),
      );
    }

    return Container(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: textWidget,
      ),
    );
  }
}

extension _WithoutColorExtension on TextStyle {
  TextStyle withoutColor() => TextStyle(
        inherit: inherit,
        color: null,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        // The _package field is private so unfortunately we can't set it here,
        // but it's almost always unset anyway.
        // package: _package,
        overflow: overflow,
      );
}
 ```

 ### form_field_controller.dart
 ```dart
import 'package:flutter/foundation.dart';

class FormFieldController<T> extends ValueNotifier<T?> {
  FormFieldController(this.initialValue) : super(initialValue);

  final T? initialValue;

  void reset() => value = initialValue;
}
 ```

 ### internationalization.dart
 ```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
  }) =>
      [enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap =
    <Map<String, Map<String, String>>>[].reduce((a, b) => a..addAll(b));
 ```

 ### lat_lng.dart
 ```dart
class LatLng {
  const LatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  String toString() => 'LatLng(lat: $latitude, lng: $longitude)';

  String serialize() => '$latitude,$longitude';

  @override
  int get hashCode => latitude.hashCode + longitude.hashCode;

  @override
  bool operator ==(other) =>
      other is LatLng &&
      latitude == other.latitude &&
      longitude == other.longitude;
}
 ```

 ### place.dart
 ```dart
import 'lat_lng.dart';

class FFPlace {
  const FFPlace({
    this.latLng = const LatLng(0.0, 0.0),
    this.name = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.zipCode = '',
  });

  final LatLng latLng;
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  @override
  String toString() => '''FFPlace(
        latLng: $latLng,
        name: $name,
        address: $address,
        city: $city,
        state: $state,
        country: $country,
        zipCode: $zipCode,
      )''';

  @override
  int get hashCode => latLng.hashCode;

  @override
  bool operator ==(other) =>
      other is FFPlace &&
      latLng == other.latLng &&
      name == other.name &&
      address == other.address &&
      city == other.city &&
      state == other.state &&
      country == other.country &&
      zipCode == other.zipCode;
}
 ```

 ### uploaded_file.dart
 ```dart
import 'dart:convert';
import 'dart:typed_data' show Uint8List;

class FFUploadedFile {
  const FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
  });

  final String? name;
  final Uint8List? bytes;
  final double? height;
  final double? width;
  final String? blurHash;

  @override
  String toString() =>
      'FFUploadedFile(name: $name, bytes: ${bytes?.length ?? 0}, height: $height, width: $width, blurHash: $blurHash,)';

  String serialize() => jsonEncode(
        {
          'name': name,
          'bytes': bytes,
          'height': height,
          'width': width,
          'blurHash': blurHash,
        },
      );

  static FFUploadedFile deserialize(String val) {
    final serializedData = jsonDecode(val) as Map<String, dynamic>;
    final data = {
      'name': serializedData['name'] ?? '',
      'bytes': serializedData['bytes'] ?? Uint8List.fromList([]),
      'height': serializedData['height'],
      'width': serializedData['width'],
      'blurHash': serializedData['blurHash'],
    };
    return FFUploadedFile(
      name: data['name'] as String,
      bytes: Uint8List.fromList(data['bytes'].cast<int>().toList()),
      height: data['height'] as double?,
      width: data['width'] as double?,
      blurHash: data['blurHash'] as String?,
    );
  }

  @override
  int get hashCode => Object.hash(
        name,
        bytes,
        height,
        width,
        blurHash,
      );

  @override
  bool operator ==(other) =>
      other is FFUploadedFile &&
      name == other.name &&
      bytes == other.bytes &&
      height == other.height &&
      width == other.width &&
      blurHash == other.blurHash;
}
 ```

 ### main.dart
 ```dart
import 'dart:async';

import 'package:aroma_journey/backend/firebase/firebase_options.dart';
import 'package:aroma_journey/main_module.dart';
import 'package:aroma_journey/main_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

final log = Logger('AmoraJourney');

void main() async {
  Logger.root.level = Level.ALL;
  runZonedGuarded(() {
    // This is the block of code that will be executed in a new zone with a custom error handler.
    _mainInZone();
  }, (error, stackTrace) {
    // This is the error handler that will be called if an error occurs in the block of code.
    log.severe('An error occurred: $error');
    log.severe('Stack trace: $stackTrace');
  });
}

void _mainInZone() async {
  WidgetsFlutterBinding.ensureInitialized();
  // To load the .env file contents into dotenv.
  await dotenv.load(fileName: ".env");
  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );*/
  return runApp(ModularApp(
    module: MainModule(),
    child: const MainWidget(),
  ));
}
 ```

 ### main_module.dart
 ```dart
import 'package:aroma_journey/modules/auth/auth_module.dart';
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:aroma_journey/modules/auth/bloc/auth_bloc.dart';
import 'package:aroma_journey/modules/home/home_module.dart';
import 'package:aroma_journey/modules/product/product_module.dart';
import 'package:aroma_journey/modules/product/product_service.dart';
import 'package:aroma_journey/modules/quizz/quizz_module.dart';
import 'package:aroma_journey/modules/quizz/quizz_service.dart';
import 'package:aroma_journey/modules/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(AuthBloc.new);
    i.addSingleton(AuthService.new);
    i.addSingleton(ProductService.new);
    i.addSingleton(QuizzService.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/product', module: ProductModule());
    r.module('/quizz', module: QuizzModule());
  }
}
 ```

 ### main_widget.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/internationalization.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();

  static _MainWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainWidgetState>()!;
}

class _MainWidgetState extends State<MainWidget> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: Asuka.builder,
      title: 'Aroma Journey',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      themeMode: _themeMode,
      routerConfig: Modular.routerConfig,
    );
  }
}
 ```

 ## modules
 ## auth
 ### auth_module.dart
 ```dart
import 'package:aroma_journey/modules/auth/pages/auth_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthPage());
  }
}
 ```

 ### auth_service.dart
 ```dart
import 'package:aroma_journey/modules/auth/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceException implements Exception {
  final Object error;
  final String message;

  AuthServiceException(this.message, this.error) {
    print(error);
  }
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///
  /// User wants to sign in with Google Credentials
  ///
  Future<CurrentUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase Auth using Google credentials
        await _firebaseAuth.signInWithCredential(credential);

        // Return the signed-in user's information
        return getUser();
      }
    } catch (error) {
      // Handle any errors that occur during sign-in
      throw AuthServiceException('signInWithGoogle error', error);
    }

    return null; // Return null if the sign-in process didn't complete
  }

  ///
  /// User wants to sign out
  ///
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // Sign out from Google if not on web platform
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  ///
  /// Check is the current user is signed in
  ///
  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null || currentUser.toString().isEmpty;
  }

  ///
  /// Retrieve the signed in User
  ///
  CurrentUser getUser() {
    User? user = _firebaseAuth.currentUser;

    return CurrentUser(
      email: user?.email ?? 'notfound@email.com',
      displayName: user?.displayName ?? 'notfound',
      photoURL: user?.photoURL?.replaceAll("s96-c", "s300-c") ??
          'https://source.unsplash.com/XOhI_kW_TaM',
    );
  }
}
 ```

 ## bloc
 ### auth_bloc.dart
 ```dart
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<AuthInitEvent>((event, emit) => _onAuthInitEvent(emit));
    on<AuthLoginWithGoogleEvent>((event, emit) => _onAuthLoginEvent(emit));
    on<AuthSuccessEvent>((event, emit) => _onAuthSuccessEvent(emit));
    on<AuthFailedEvent>((event, emit) => _onAuthFailedEvent(emit));
    on<AuthLoadingEvent>((event, emit) => emit(AuthLoadingState()));
  }

  ///
  /// On AuthInitEvent
  ///
  void _onAuthInitEvent(Emitter<AuthState> emit) {
    try {
      final isSignedIn = service.isSignedIn();
      if (isSignedIn) {
        final currentUser = service.getUser();
        emit(_userToState(currentUser));
      } else {
        emit(AuthFailedState());
      }
    } catch (_) {
      print("1");
      emit(AuthErrorState());
    }
  }

  ///
  /// On AuthLoginWithGoogleEvent
  ///
  void _onAuthLoginEvent(Emitter<AuthState> emit) async {
    try {
      await service.signInWithGoogle();
      final isSignedIn = service.isSignedIn();
      if (isSignedIn) {
        final currentUser = service.getUser();
        emit(_userToState(currentUser));
      } else {
        emit(AuthFailedState());
      }
    } catch (e) {
      print("2");
      emit(AuthErrorState());
    }
  }

  ///
  /// On AuthSuccessEvent
  ///
  void _onAuthSuccessEvent(Emitter<AuthState> emit) {
    final currentUser = service.getUser();
    emit(_userToState(currentUser));
  }

  ///
  /// On AuthFailedEvent
  ///
  void _onAuthFailedEvent(Emitter<AuthState> emit) {
    emit(AuthFailedState());
    service.signOut();
  }

  AuthState _userToState(final currentUser) {
    if (currentUser != null) {
      return AuthSuccessState(user: currentUser);
    } else {
      print("3");
      return AuthErrorState();
    }
  }

  AuthService get service => Modular.get<AuthService>();
}
 ```

 ### auth_event.dart
 ```dart

abstract class AuthEvent {}

///
/// Event triggered when App is starting - Check Auth State of the User
///
class AuthInitEvent extends AuthEvent {}

///
/// Event triggered when App is Loading for  - Check Auth State of the User
///
class AuthLoadingEvent extends AuthEvent {}

///
/// Event triggered when user try to log with Google
///
class AuthLoginWithGoogleEvent extends AuthEvent {}

///
/// Event triggered when Auth is ok
///
class AuthSuccessEvent extends AuthEvent {}

///
/// Event triggered when Auth is ko
///
class AuthFailedEvent extends AuthEvent {} ```

 ### auth_state.dart
 ```dart
import 'package:aroma_journey/modules/auth/model/user.dart';

abstract class AuthState {}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

///
/// This is the state when user is authenticated and user object is created.
///
class AuthSuccessState extends AuthState {
  final CurrentUser user;

  // user is a required parameter to create the Authenticated state
  AuthSuccessState({required this.user});
}

///
/// state when user authentication fails
///
class AuthFailedState extends AuthState {}

///
/// state whe error occurs during the auth process
///
class AuthErrorState extends AuthState {}
 ```

 ## model
 ### user.dart
 ```dart
///
/// After auth is ok , the current user is populated
///
class CurrentUser {
  final String displayName;
  final String photoURL;
  final String email;

  CurrentUser({
    required this.email,
    required this.displayName,
    required this.photoURL,
  });
}
 ```

 ## pages
 ### auth_page.dart
 ```dart
import 'package:aroma_journey/modules/auth/pages/login_widget.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      child: LoginWidget(scaffoldKey: scaffoldKey),
      listener: (context, state) {
        if (state is AuthFailedState) {
          AsukaSnackbar.warning("AuthFailedState").show();
        }
        if (state is AuthErrorState) {
          AsukaSnackbar.alert("AuthFailedState").show();
        }
        if (state is AuthSuccessState) {
          AsukaSnackbar.success("Welcome to Aroma").show();
        }
      },
    );
  }
}
 ```

 ### login_widget.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/modules/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

import '../bloc/auth_event.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();

class OnboardingPageConstants {
  // https://source.unsplash.com/Ic8RmXGyfNc
  // https://source.unsplash.com/pnmRtTHWqDM
  // https://source.unsplash.com/pMW4jzELQCw
  static const String coverImageUrl =
      'https://images.unsplash.com/photo-1517640033243-dc06bb716df5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4NTA3OTI3NA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080';

  static const String title = """Aroma Journey,
  Coffee's Stories""";

  static const String subTitle = """Explore, Sip, and 
  Connect Through Every Cup""";
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF14181B),
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 1.0,
        child: Stack(
          children: [
            PageView(
              // FIXME
              // controller: _model.pageViewController ??= PageController(initialPage: 0),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14181B),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network(
                        OnboardingPageConstants.coverImageUrl,
                      ).image,
                    ),
                  ),
                  child: Container(
                    width: 100.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: const BoxDecoration(
                      color: Color(0x990F1113),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 30.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                OnboardingPageConstants.title,
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 30.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 120.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  OnboardingPageConstants.subTitle,
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 70.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  authBloc.add(AuthLoginWithGoogleEvent());
                                },
                                text: 'Get Started',
                                icon: SvgPicture.asset(
                                  "assets/google.svg",
                                  width: 32,
                                ),
                                options: FFButtonOptions(
                                  width: 240.0,
                                  height: 60.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  elevation: 2.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 200.0),
                child: smooth_page_indicator.SmoothPageIndicator(
                  //FIXME
                  // controller: _model.pageViewController ??= PageController(initialPage: 0),
                  controller: PageController(initialPage: 0),
                  count: 3,
                  axisDirection: Axis.horizontal,
                  /*onDotClicked: (i) async {
                    await _model.pageViewController!.animateToPage(
                      i,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },*/
                  effect: smooth_page_indicator.ExpandingDotsEffect(
                    expansionFactor: 4.0,
                    spacing: 8.0,
                    radius: 40.0,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    dotColor: const Color(0xFFD9D9D9),
                    activeDotColor: FlutterFlowTheme.of(context).primary,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 ```

 ## favorite
 ## home
 ### hello.dart 17-13-11-726.dart
 ```dart
const json = '''
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com",
  "isVerified": true,
  "favorites": {
    "color": "blue",
    "food": "pizza",
    "number": 7
  },
  "friends": [
    {
      "id": 2,
      "name": "Jane Smith",
      "email": "jane.smith@example.com",
      "isVerified": false
    },
    {
      "id": 3,
      "name": "Bob Brown",
      "email": "bob.brown@example.com",
      "isVerified": true
    }
  ]
}
''';


class User {
  final int id;
  final String name;
  final String email;
  final bool isVerified;
  final Favorites favorites;
  final List<Friend> friends;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.favorites,
    required this.friends,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        isVerified: json['isVerified'],
        favorites: Favorites.fromJson(json['favorites']),
        friends: List<Friend>.from(json['friends'].map((x) => Friend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'isVerified': isVerified,
        'favorites': favorites.toJson(),
        'friends': List<dynamic>.from(friends.map((x) => x.toJson())),
      };
}

class Favorites {
  final String color;
  final String food;
  final int number;

  Favorites({
    required this.color,
    required this.food,
    required this.number,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        color: json['color'],
        food: json['food'],
        number: json['number'],
      );

  Map<String, dynamic> toJson() => {
        'color': color,
        'food': food,
        'number': number,
      };
}

class Friend {
  final int id;
  final String name;
  final String email;
  final bool isVerified;

  Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        isVerified: json['isVerified'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'isVerified': isVerified,
      };
}
 ```

 ### home_module.dart
 ```dart
import 'package:aroma_journey/modules/home/pages/home_page.dart';
import 'package:aroma_journey/modules/shared/navbar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const NavBarPage(initialPage: HomePage.routeKey));
  }
}
 ```

 ## pages
 ### home_model.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_model.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for search widget.
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;
  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue;
  FormFieldController<List<String>>? choiceChipsValueController;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    searchController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
} ```

 ### home_page.dart
 ```dart
import 'package:aroma_journey/modules/home/widgets/home_categories_widget.dart';
import 'package:aroma_journey/modules/home/widgets/home_header_widget.dart';
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../auth/bloc/auth_bloc.dart';

AuthBloc get authBloc => Modular.get<AuthBloc>();
AuthService get authService => Modular.get<AuthService>();

class HomePage extends StatefulWidget {
  static const String routeKey = 'home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: const SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          HomeHeaderWidget(),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HomeCategoriesWidget(),
                                ]),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
 ```

 ## widgets
 ### home_categories_widget.dart
 ```dart
import 'package:aroma_journey/backend/backend.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_model.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:aroma_journey/modules/home/pages/home_model.dart';
import 'package:aroma_journey/modules/product/model/product_invention_model.dart';
import 'package:aroma_journey/modules/product/product_service.dart';
import 'package:aroma_journey/modules/shared/loading_indicator.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ProductService get productService => Modular.get<ProductService>();

class HomeCategoriesWidget extends StatefulWidget {
  const HomeCategoriesWidget({
    super.key,
  });

  @override
  State<HomeCategoriesWidget> createState() => _HomeCategoriesWidgetState();
}

class _HomeCategoriesWidgetState extends State<HomeCategoriesWidget> {
  late HomeModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    _model.searchController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Categories',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
              ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 13, 0, 13),
                    child: FlutterFlowChoiceChips(
                      options: const [
                        ChipData('Cappuccino', FontAwesomeIcons.mugSaucer),
                        ChipData('Cold Brew', Icons.local_cafe_outlined),
                        ChipData('Expresso', FontAwesomeIcons.mugHot)
                      ],
                      onChanged: (val) =>
                          setState(() => _model.choiceChipsValue = val?.first),
                      selectedChipStyle: ChipStyle(
                        backgroundColor: const Color(0xFF846046),
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                        iconColor: Colors.white,
                        iconSize: 15,
                        elevation: 2,
                      ),
                      unselectedChipStyle: ChipStyle(
                        backgroundColor: Colors.white,
                        textStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                        iconColor: Colors.black,
                        iconSize: 18,
                        elevation: 0,
                      ),
                      chipSpacing: 10,
                      rowSpacing: 12,
                      multiselect: false,
                      initialized: _model.choiceChipsValue != null,
                      alignment: WrapAlignment.start,
                      controller: _model.choiceChipsValueController ??=
                          FormFieldController<List<String>>(
                        ['Cappuccino'],
                      ),
                    ).animateOnPageLoad(
                        animationsMap['choiceChipsOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
            child: FutureBuilder<List<ProductRecord>>(
              future: queryProductRecordOnce(
                queryBuilder: (productRecord) => productRecord
                    .where('category_name', isEqualTo: _model.choiceChipsValue),
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<ProductRecord> productListProductRecordList =
                    snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                      productListProductRecordList.length,
                      (productListIndex) {
                        final productListProductRecord =
                            productListProductRecordList[productListIndex];
                        return Stack(
                          children: [
                            Container(
                              width: 160,
                              height: 185,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            Container(
                              width: 145,
                              height: 165,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 5),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Modular.to.navigate('/product/',
                                          arguments: productListProductRecord);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(7, 7, 7, 0),
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                  productListProductRecord
                                                      .image,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(7, 0, 0, 0),
                                          child: Text(
                                            productListProductRecord.name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 10.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    'Brewing by PaLM API',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ).animateOnPageLoad(
                      animationsMap['textOnPageLoadAnimation2']!),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 10.0, 0.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<ProductInventionModel>>(
                future: productService.generateInventions(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return const LoadinIndicator();
                  }
                  List<ProductInventionModel> productInventionModelList =
                      snapshot.data!;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(productInventionModelList.length,
                        (offerListIndex) {
                      final productInventionModel =
                          productInventionModelList[offerListIndex];
                      return Stack(
                        children: [
                          Container(
                            width: 310.0,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          Container(
                            width: 300.0,
                            height: 130.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 5.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Stack(
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Modular.to.navigate('/product/invention/',
                                        arguments: productInventionModel);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10.0, 10.0, 10.0, 0.0),
                                        child: Container(
                                          width: 140.0,
                                          height: 105.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            image: const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                'https://images.unsplash.com/photo-1516743619420-154b70a65fea?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                                              ),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 20.0, 0.0, 10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () {
                                                  //FIXME nothing to do
                                                },
                                                text: 'genAi',
                                                options: FFButtonOptions(
                                                  width: 80.0,
                                                  height: 20.0,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                  elevation: 2.0,
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        7.0, 0.0, 7.0, 0.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "${productInventionModel.categoryName}:",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Text(
                                                      productInventionModel
                                                          .name,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 ```

 ### home_header_widget.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthService get authService => Modular.get<AuthService>();

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 500),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  imageUrl: authService.getUser().photoURL,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              // Generated code for this location Widget...
              /*Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.location_on,
                    color:
                        FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  Text(
                    'Porto Alegre, Brazil',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                  ),
                ],
              ),*/
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: FFButtonWidget(
                  onPressed: () async {
                    authService.signOut();
                  },
                  text: 'Logout',
                  options: FFButtonOptions(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  'Welcome, ${authService.getUser().displayName.split(' ')[0]}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
 ```

 ## product
 ## bloc
 ### product_bloc.dart
 ```dart
import 'package:aroma_journey/modules/product/product_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitState()) {
    on<ProductInitEvent>(
        (event, emit) => _onProductInitEvent(event.product, emit));
  }

  void _onProductInitEvent(String coffee, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      Map<String, String> response = await service.multiGeneration(coffee);
      emit(ProductSuccessState(response: response));
    } catch (_) {
      emit(ProductErrorState());
    }
  }

  ProductService get service => Modular.get<ProductService>();
}
 ```

 ### product_event.dart
 ```dart
abstract class ProductEvent {}

class ProductInitEvent extends ProductEvent {
  final String product;

  ProductInitEvent(this.product);
}
 ```

 ### product_state.dart
 ```dart
abstract class ProductState {}

class ProductInitState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final Map<String, String> response;

  ProductSuccessState({required this.response});
}

class ProductErrorState extends ProductState {}

class ProductContentState extends ProductState {
  final String content;

  ProductContentState({required this.content});
}
 ```

 ## model
 ### product_invention_model.dart
 ```dart
class ProductInventionModel {
  final String categoryName;
  final String name;
  final String info;
  final String offerDescription;
  final bool isOffer;

  ProductInventionModel({
    required this.categoryName,
    required this.name,
    required this.info,
    required this.offerDescription,
    required this.isOffer,
  });

  factory ProductInventionModel.fromJson(Map<String, dynamic> json) {
    return ProductInventionModel(
      categoryName: json['category_name'] ?? '',
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      offerDescription: json['offer_description'] ?? '',
      isOffer: true,
    );
  }
} ```

 ## pages
 ### product_invention_page.dart
 ```dart
import 'dart:ui';

import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_icon_button.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_toggle_icon.dart';
import 'package:aroma_journey/modules/product/model/product_invention_model.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductInventionPage extends StatefulWidget {
  const ProductInventionPage({
    Key? key,
    required this.productInventionModel,
  }) : super(key: key);

  final ProductInventionModel productInventionModel;

  @override
  State<ProductInventionPage> createState() => _ProductInventionPageState();
}

class _ProductInventionPageState extends State<ProductInventionPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: generateMainContent(context, widget.productInventionModel),
    );
  }

  SizedBox generateMainContent(
      BuildContext context, ProductInventionModel productInventionModel) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: const AlignmentDirectional(0.0, -1.0),
        children: [
          const Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Image(
              // 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
              image: AssetImage('assets/background_Product.png'),
              width: double.infinity,
              height: 500.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 105.0, 0.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: const Color(0x90000000),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Generate by PaLM API',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              productInventionModel.categoryName,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).animateOnPageLoad(
              animationsMap['blurOnPageLoadAnimation']!,
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.0, -0.87),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x520E151B),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 8.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        Modular.to.navigate('/home/');
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print("action 1");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'added to favorites!',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          );
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0x26FFFFFF),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ToggleIcon(
                            onPressed: () async {
                              print("action 2");
                            },
                            value: true,
                            onIcon: Icon(
                              Icons.favorite,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                            offIcon: Icon(
                              Icons.favorite_border,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 140.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 400.0,
                  decoration: const BoxDecoration(
                    color: Color(0x59000000),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productInventionModel.name,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 300.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 1800.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F7FA),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x320E151B),
                              offset: Offset(0.0, -2.0),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // FIXME: Hide for the moment
                              //buildExtraContainer(context).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 30.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Description',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 5.0, 40.0, 0.0),
                                                child: Positioned.fill(
                                                  child: AnimatedOpacity(
                                                    opacity: 1.0,
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    child: MarkdownBody(
                                                        data: productInventionModel
                                                            .offerDescription),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation1']!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 ```

 ### product_model.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_model.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for coffeeSizeOptions widget.
  String? productSizeOptionsValue;
  FormFieldController<List<String>>? productSizeOptionsValueController;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
 ```

 ### product_page.dart
 ```dart
import 'dart:ui';

import 'package:aroma_journey/backend/schema/product_record.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_icon_button.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_toggle_icon.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_util.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:aroma_journey/modules/product/bloc/product_bloc.dart';
import 'package:aroma_journey/modules/product/bloc/product_event.dart';
import 'package:aroma_journey/modules/product/bloc/product_state.dart';
import 'package:aroma_journey/modules/product/pages/product_model.dart';
import 'package:aroma_journey/modules/shared/loading_indicator.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.productRecord,
  }) : super(key: key);

  final ProductRecord productRecord;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  late ProductModel _model;
  Map<String, String> palm2Response = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());
    BlocProvider.of<ProductBloc>(context)
        .add(ProductInitEvent(widget.productRecord.name));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      bloc: BlocProvider.of<ProductBloc>(context),
      listener: (context, state) {
        if (state is ProductLoadingState) {
          AsukaSnackbar.warning("ProductLoadingState").show();
        }
        if (state is ProductErrorState) {
          AsukaSnackbar.alert("ProductErrorState").show();
        }
        if (state is ProductSuccessState) {
          AsukaSnackbar.success("ProductSuccessState").show();
        }
        if (state is ProductContentState) {
          print(state.content);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: StreamBuilder<ProductRecord>(
            stream: ProductRecord.getDocument(widget.productRecord.reference),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return const LoadinIndicator();
              } else {
                final stackProductRecord = snapshot.data!;
                return generateMainContent(context, stackProductRecord);
              }
            },
          ),
        ),
      ),
    );
  }

  SizedBox generateMainContent(
      BuildContext context, ProductRecord stackProductRecord) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: const AlignmentDirectional(0.0, -1.0),
        children: [
          const Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Image(
              // 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
              image: AssetImage('assets/background_Product.png'),
              width: double.infinity,
              height: 500.0,
              fit: BoxFit.cover,
            ),
          ),
          if (stackProductRecord.isOffer)
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 105.0, 0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        color: const Color(0x90000000),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            stackProductRecord.offerDescription,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animateOnPageLoad(
                animationsMap['blurOnPageLoadAnimation']!,
              ),
            ),
          Align(
            alignment: const AlignmentDirectional(0.0, -0.87),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x520E151B),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 8.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        Modular.to.navigate('/home/');
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print("action 1");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'added to favorites!',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          );
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0x26FFFFFF),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ToggleIcon(
                            onPressed: () async {
                              print("action 2");
                            },
                            value: true,
                            onIcon: Icon(
                              Icons.favorite,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                            offIcon: Icon(
                              Icons.favorite_border,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 140.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 400.0,
                  decoration: const BoxDecoration(
                    color: Color(0x59000000),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stackProductRecord.name,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                stackProductRecord.info.maybeHandleOverflow(
                                  maxChars: 45,
                                  replacement: '…',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 300.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 1800.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F7FA),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x320E151B),
                              offset: Offset(0.0, -2.0),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // FIXME: Hide for the moment
                              //buildExtraContainer(context).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 30.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Details',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProductBloc, ProductState>(
                                  builder: (context, state) {
                                if (state is ProductLoadingState) {
                                  return const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 100, 0, 0),
                                    child: LoadinIndicator(),
                                  );
                                }
                                if (state is ProductSuccessState) {
                                  palm2Response = state.response;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 18.0, 0.0, 8.0),
                                        child: FlutterFlowChoiceChips(
                                          options: const [
                                            ChipData('Brewing'),
                                            ChipData('Taste'),
                                            ChipData('Health')
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              _model.productSizeOptionsValue =
                                                  val?.first;
                                            });
                                          },
                                          selectedChipStyle: ChipStyle(
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                            iconColor: Colors.white,
                                            iconSize: 18.0,
                                            labelPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    15.0, 5.0, 15.0, 5.0),
                                            elevation: 41.0,
                                          ),
                                          unselectedChipStyle: ChipStyle(
                                            backgroundColor: Colors.white,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color:
                                                      const Color(0xCC000000),
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                            iconColor: const Color(0xCC000000),
                                            iconSize: 18.0,
                                            labelPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    15.0, 5.0, 15.0, 5.0),
                                            elevation: 4.0,
                                          ),
                                          chipSpacing: 30.0,
                                          rowSpacing: 12.0,
                                          multiselect: false,
                                          initialized:
                                              _model.productSizeOptionsValue !=
                                                  null,
                                          alignment: WrapAlignment.start,
                                          controller: _model
                                                  .productSizeOptionsValueController ??=
                                              FormFieldController<List<String>>(
                                            ['Brewing'],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 30.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Generate by PaLM API',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 20.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          for (String key in palm2Response.keys)
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              5.0, 40.0, 0.0),
                                                      child: Positioned.fill(
                                                        child: AnimatedOpacity(
                                                          opacity:
                                                              _model.productSizeOptionsValue ==
                                                                      key
                                                                  ? 1.0
                                                                  : 0.0,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          child: MarkdownBody(
                                                              data:
                                                                  palm2Response[
                                                                      key]!),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return const Text('');
                              }),
                            ],
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation1']!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildExtraContainer(BuildContext context) {
    return Container(
      width: 350.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: const Color(0x35A6A6AA),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Coffee',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(
              height: 50.0,
              child: VerticalDivider(
                thickness: 1.0,
              ),
            ),
            Text(
              'Chocolate',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(
              height: 50.0,
              child: VerticalDivider(
                thickness: 1.0,
              ),
            ),
            Text(
              'Medium Roasted',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
 ```

 ### product_module.dart
 ```dart
import 'package:aroma_journey/modules/product/bloc/product_bloc.dart';
import 'package:aroma_journey/modules/product/pages/product_invention_page.dart';
import 'package:aroma_journey/modules/product/pages/product_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/:productRef',
        child: (context) => BlocProvider(
              create: (context) => ProductBloc(),
              child: ProductPage(productRecord: r.args.data),
            ));
    r.child(
      '/invention/:productInvention',
      child: (context) =>
          ProductInventionPage(productInventionModel: r.args.data),
    );
  }
}
 ```

 ### product_service.dart
 ```dart
import 'dart:convert';

import 'package:aroma_journey/backend/palm/palm_util.dart';
import 'package:aroma_journey/modules/shared/shared.dart' as shared;
import 'package:aroma_journey/modules/product/model/product_invention_model.dart';

class PromptProductDetail {
  static const String exampleInput1 =
      'Could you provide step-by-step instructions on how to brew a delicious Mocha Cold Brew ? The ouput must be in markdown format.';
  static const String exampleOutput1 =
      '''Here's a step-by-step guide to brewing a delightful Mocha Cold Brew:

1. **Gather Your Ingredients:**
   - Coarsely ground coffee beans
   - Cold, filtered water
   - Chocolate syrup
   - Milk (dairy or non-dairy)

2. **Coffee-to-Water Ratio:**
   - Use a 1:4 coffee-to-water ratio. For example, if you have 1 cup of coarsely ground coffee, use 4 cups of cold water.

3. **Combine Coffee and Water:**
   - In a large jar or pitcher, combine the coarsely ground coffee and cold water. Stir well to ensure even saturation.

4. **Steep Time:**
   - Cover the jar/pitcher and let the coffee steep in the refrigerator for about 12-24 hours. This slow steeping process extracts flavors without bitterness.

5. **Filtering:**
   - After steeping, use a fine-mesh strainer or a cold brew coffee maker to separate the liquid from the coffee grounds.

6. **Mix in Chocolate Syrup:**
   - To create the Mocha flavor, add a generous amount of chocolate syrup to the cold brew concentrate. Adjust the amount to your taste preference.

7. **Add Milk:**
   - Fill a glass with ice and pour in the cold brew concentrate, leaving some space at the top. Top off with milk, whether it's dairy or your preferred non-dairy option.

8. **Stir and Enjoy:**
   - Give the Mocha Cold Brew a good stir to combine all the flavors. Sip and savor the harmonious blend of coffee and chocolate, enhanced by the cold and refreshing nature of the brew.

9. **Optional Garnish:**
   - If you like, you can add whipped cream, a drizzle of extra chocolate syrup, or a sprinkle of cocoa powder as a finishing touch.

10. **Experiment and Customize:**
   - Feel free to experiment with the coffee-to-water ratio and chocolate syrup amount to create your perfect Mocha Cold Brew. Enjoy!"

Remember, the key to a delicious Mocha Cold Brew is finding the right balance between coffee, chocolate, and milk. Enjoy your brewing adventure!''';

  static const String exampleInput2 =
      'Could you describe the flavor profile of Classic Espresso, highlighting its aroma, primary taste notes, and any undertones that coffee enthusiasts can expect to savor? The ouput must be in markdown format.';
  static const String exampleOutput2 =
      '''Let's delve into the captivating flavor journey of Classic Espresso:

**Aroma:**
As you bring a cup of Classic Espresso to your nose, you'll be greeted by a rich and invigorating aroma. The scent is deep and earthy, with prominent notes of roasted coffee beans and a hint of bittersweet cocoa. The aroma sets the stage for the bold and complex taste that's about to unfold.

**Primary Taste Notes:**
Upon your first sip, Classic Espresso envelops your palate with a full-bodied and intense flavor. The primary taste notes are characterized by the robust essence of dark chocolate and a pleasantly balanced bitterness reminiscent of unsweetened cocoa. These notes provide a strong foundation that's quintessential to a classic espresso experience. You'll also notice a subtle nutty undertone that adds a layer of depth to the flavor.

**Undertones:**
As you explore the depths of Classic Espresso's flavor profile, you'll discover delicate undertones that enhance the overall taste. A fleeting hint of toasted almonds dances on the edges of your palate, complementing the chocolate and adding a touch of sweetness. These undertones offer a gentle contrast to the boldness of the coffee, creating a harmonious and satisfying balance.

**Finish:**
The journey concludes with a smooth and lingering finish. The bitterness of the espresso is well-balanced, leaving a refined and memorable aftertaste that beckons you to savor every sip. Classic Espresso's finish is both invigorating and comforting, leaving you with a sense of satisfaction that lingers pleasantly.

In summary, Classic Espresso is a symphony of flavors that intertwine to create a remarkable experience. From the deep and earthy aroma to the interplay of dark chocolate, nutty undertones, and a balanced finish, this espresso embodies the essence of traditional craftsmanship. Whether enjoyed on its own or as the foundation for other coffee creations, Classic Espresso is a timeless journey of taste that coffee enthusiasts will thoroughly enjoy.
''';

  static const String exampleInput3 =
      '''Could you provide insights into the potential health effects of incorporating Vanilla Cappuccino into one's routine, including considerations related to ingredients and nutritional aspects?''';
  static const String exampleOutput3 =
      '''Could you provide insights into the potential health effects of incorporating Vanilla Cappuccino into one's routine, including considerations related to ingredients and nutritional aspects?
output: Let's explore the potential health effects and considerations when incorporating Vanilla Cappuccino into your routine:

**Ingredients and Nutritional Aspects:**
Vanilla Cappuccino is a delightful fusion of espresso, steamed milk, and a touch of sweet vanilla flavor. The nutritional profile can vary based on factors such as the type of milk used (dairy or non-dairy), the amount of vanilla syrup, and whether any additional toppings are added.

**Moderation and Sugar Content:**
It's important to be mindful of the sugar content in Vanilla Cappuccino, especially if it includes flavored syrups. While the vanilla syrup adds a pleasant sweetness, it can contribute to the overall sugar intake. Opting for sugar-free or reduced-sugar syrups can be a way to enjoy the flavors without excess sugar.

**Balancing Calories:**
Vanilla Cappuccino, like any coffee-based beverage, contributes to your daily caloric intake. The addition of milk and syrups can increase the calorie count. If you're mindful of your calorie consumption, you might consider choosing lower-fat milk options or smaller serving sizes.

**Caffeine Content:**
Espresso-based drinks, including Vanilla Cappuccino, contain caffeine. While caffeine can provide an energy boost and enhance alertness, it's advisable to be aware of your overall caffeine intake. Some individuals are more sensitive to caffeine's effects, so adjusting your consumption based on your preferences is a good practice.

**Balanced Diet and Enjoyment:**
Incorporating Vanilla Cappuccino into your routine can certainly be a delightful treat. Enjoyment is a key aspect of a balanced approach to nutrition. If you're mindful of the ingredients and portion sizes, Vanilla Cappuccino can be a part of your overall diet without causing concerns.

**Personalized Choices:**
Ultimately, the health effects of enjoying Vanilla Cappuccino depend on your individual dietary goals, preferences, and lifestyle. If you're looking to reduce sugar or calories, you might explore alternative milk options or adjust the sweetness level. For those who appreciate the occasional indulgence, Vanilla Cappuccino can be a rewarding and satisfying choice.

In summary, Vanilla Cappuccino can be a delightful addition to your routine when enjoyed mindfully. It's advisable to consider factors such as sugar content, caloric intake, and caffeine sensitivity. Making informed choices based on your own health goals will help you savor this beverage in a way that aligns with your preferences and well-being.
''';
}

class PromptProductInvention {
  static const String exampleInput1 =
      '''input: Create a new coffee creation in the "Cold Brew" category. Provide its details in JSON format. { "category_name": "Cold Brew", "name": "", "info": "", "offer_description": "" }''';
  static const String exampleOutput1 =
      '''{"category_name":"Cold Brew","name":"Tropical Chill","info":"Tropical Chill is a refreshing cold brew coffee with a tropical twist. It's crafted using the finest cold brew method, resulting in a smooth and naturally sweet coffee base. Infused with hints of coconut and a touch of pineapple essence, this unique creation captures the essence of a beachside getaway in every sip.","offer_description":"Indulge in the paradise of flavor with Tropical Chill. Experience the soothing coolness of cold brew coffee combined with the exotic allure of the tropics. This coffee creation promises a delightful escape from the ordinary, making it the perfect companion for those seeking a refreshing and revitalizing coffee experience."}''';

  static const String exampleInput2 =
      '''input: Create a new coffee creation in the "Cappuccino" category. Provide its details in JSON format. { "category_name": "Cappuccino", "name": "", "info": "", "offer_description": "" }''';
  static const String exampleOutput2 =
      '''{"category_name":"Cappuccino","name":"Velvet Bliss","info":"Velvet Bliss is an exquisite cappuccino creation that redefines indulgence. It starts with a rich, double-shot espresso base, meticulously blended with velvety steamed milk. The magic happens with a drizzle of artisanal dark chocolate and a whisper of Madagascar vanilla, culminating in a coffee experience that's pure luxury.","offer_description":"Elevate your senses with Velvet Bliss, where every sip is an invitation to luxury. This cappuccino masterpiece combines the boldness of espresso with the silkiness of steamed milk, kissed by the sweetness of dark chocolate and vanilla. It's the epitome of coffee opulence, crafted to delight the most discerning coffee enthusiasts."}''';

  static const String exampleInput3 =
      '''input: Create a new coffee creation in the "Espresso" category. Provide its details in JSON format. { "category_name": "Espresso", "name": "", "info": "", "offer_description": "" }''';
  static const String exampleOutput3 =
      '''{"category_name":"Espresso","name":"Midnight Elegance","info":"Midnight Elegance is a bold and robust espresso that combines the intensity of dark roasted beans with a hint of smoky aroma. Its unique profile is characterized by a velvety texture and a rich, full-bodied flavor. This espresso boasts a satisfyingly long-lasting crema, making it perfect for those who savor the essence of strong, aromatic coffee.","offer_description":"Experience the allure of Midnight Elegance, where every sip is an indulgence in the dark artistry of espresso. Specially crafted for espresso aficionados, this coffee creation promises a journey into the depths of flavor. Discover a world of boldness and complexity with each cup."}''';
}

class ProductService {
  Future<List<ProductInventionModel>> generateInventions() async {
    final List<String> randomCategory = List.generate(
      2,
      (_) => shared.getRandomCategory(),
    );

    final List<ProductInventionModel> records = [];

    for (final category in randomCategory) {
      final String output = await _generatedProductInventions(category);
      final model = ProductInventionModel.fromJson(json.decode(output));
      records.add(model);
    }

    return records;
  }

  Future<Map<String, String>> multiGeneration(String coffee) {
    return Future.wait([
      _generatedProductDetail(
          "Could you provide step-by-step instructions on how to brew a delicious $coffee ? The ouput must be in markdown format."),
      _generatedProductDetail(
          "Could you describe the flavor profile of $coffee, highlighting its aroma, primary taste notes, and any undertones that coffee enthusiasts can expect to savor? The ouput must be in markdown format."),
      _generatedProductDetail(
          "Could you provide insights into the potential health effects of incorporating $coffee into one's routine, including considerations related to ingredients and nutritional aspects?"),
    ]).then((value) => {
          'Brewing': value[0],
          'Taste': value[1],
          'Health': value[2],
        });
  }

  Future<String> _generatedProductInventions(String category) async =>
      PaLMUtil.generateTextFormPaLM(
        exampleInput1: PromptProductInvention.exampleInput1,
        exampleOutput1: PromptProductInvention.exampleOutput1,
        exampleInput2: PromptProductInvention.exampleInput2,
        exampleOutput2: PromptProductInvention.exampleOutput2,
        exampleInput3: PromptProductInvention.exampleInput3,
        exampleOutput3: PromptProductInvention.exampleOutput3,
        input:
            """Create a new coffee creation in the "$category" category. Provide its details in JSON format. { "category_name": "$category", "name": "", "info": "", "offer_description": "" }""",
      );

  Future<String> _generatedProductDetail(String input) async =>
      PaLMUtil.generateTextFormPaLM(
        exampleInput1: PromptProductDetail.exampleInput1,
        exampleOutput1: PromptProductDetail.exampleOutput1,
        exampleInput2: PromptProductDetail.exampleInput2,
        exampleOutput2: PromptProductDetail.exampleOutput2,
        exampleInput3: PromptProductDetail.exampleInput3,
        exampleOutput3: PromptProductDetail.exampleOutput3,
        input: input,
      );
}
 ```

 ## widgets
 ## quizz
 ## pages
 ### quizz_pages.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_widgets.dart';
import 'package:aroma_journey/modules/quizz/quizz_service.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

QuizzService get quizzService => Modular.get<QuizzService>();

bool isQuizzSubmit = false;

class QuizQuestion {
  final String question;
  bool? userChoice; // Added property to store user choice
  final bool correct;

  QuizQuestion({
    required this.question,
    required this.correct,
  });

  @override
  String toString() {
    return 'Question: $question\nCorrect Answer: $correct';
  }
}

class QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final ValueChanged<bool> onChoiceChanged;
  const QuestionCard(this.question, this.onChoiceChanged);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              question.question,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  label: 'True',
                  isSelected: question.userChoice != null &&
                      question.userChoice == true,
                  onTap: () {
                    onChoiceChanged(true);
                  },
                ),
                const SizedBox(width: 20),
                ChoiceButton(
                  label: 'False',
                  isSelected: question.userChoice != null &&
                      question.userChoice == false,
                  onTap: () {
                    onChoiceChanged(false);
                  },
                ),
                const SizedBox(width: 10),
                if (isQuizzSubmit &&
                    question.userChoice != question.correct) ...[
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const ChoiceButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: onTap,
      options: FFButtonOptions(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.grey,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
        elevation: 2.0,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      text: label,
    );
  }
}

class QuizzPage extends StatefulWidget {
  static const String routeKey = 'quizz';
  const QuizzPage({super.key});

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<QuizQuestion> questions = [];
  String resultStatus = '';

  @override
  void initState() {
    quizzService.generateRandomQuizQuestions().then((value) {
      setState(() {
        questions = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Generated code for this Text Widget...
                            Expanded(
                              child: Text(
                                "Today's Quiz by PaLM API",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Generated code for this Text Widget...
                            Expanded(
                              child: Text(
                                resultStatus,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                              ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (questions.isEmpty)
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5.0,
                        ),
                      ),
                    ),
                  if (questions.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Builder(
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (var question in questions)
                                  QuestionCard(question, (choice) {
                                    setState(() {
                                      question.userChoice = choice;
                                    });
                                  }),
                                const SizedBox(height: 10),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: () {
                                          // Reset user choices
                                          setState(() {
                                            for (var question in questions) {
                                              question.userChoice = null;
                                            }
                                            resultStatus = '';
                                            isQuizzSubmit = false;
                                          });
                                        },
                                        options: FFButtonOptions(
                                          width: 120.0,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        text: 'Reset',
                                        icon: const Icon(
                                          Icons.restart_alt_outlined,
                                          size: 24.0,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      FFButtonWidget(
                                        onPressed: () {
                                          // Evaluate the quiz and display result
                                          int correctAnswers = 0;
                                          for (var question in questions) {
                                            if (question.userChoice ==
                                                question.correct) {
                                              // Evaluate user choice, you can adjust this based on your evaluation logic
                                              correctAnswers++;
                                            }
                                          }
                                          setState(() {
                                            resultStatus =
                                                'You got $correctAnswers out of ${questions.length} questions correct.';
                                            isQuizzSubmit = true;
                                          });
                                        },
                                        options: FFButtonOptions(
                                          width: 120.0,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        text: 'Submit',
                                        icon: const Icon(
                                          Icons.send_outlined,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 ```

 ### quizz_module.dart
 ```dart
import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:aroma_journey/modules/shared/navbar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuizzModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const NavBarPage(initialPage: QuizzPage.routeKey));
  }
}
 ```

 ### quizz_service.dart
 ```dart
import 'dart:math';

import 'package:aroma_journey/backend/palm/palm_util.dart';
import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:aroma_journey/modules/shared/shared.dart' as shared;

const String exampleInput1 =
    'Could you generate a true or false question about Classic Expression for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput1 =
    '''True or False: Classic Espresso is a coffee beverage made by combining equal parts espresso, steamed milk, and milk foam. {False}''';

const String exampleInput2 =
    'Could you generate a true or false question about Caramel Cappuccino for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput2 =
    '''True or False: Caramel Cappuccino is a coffee drink made with equal parts espresso, steamed milk, and milk foam, combined with the sweetness of caramel drizzle. {True}''';

const String exampleInput3 =
    'Could you generate a true or false question about Mocha Cold Brew for me? Please include the answer at the end within curly braces {}.';
const String exampleOutput3 =
    '''True or False: Mocha Cold Brew is a chilled coffee beverage made by steeping coarsely ground coffee in cold water and then adding a touch of chocolate syrup or cocoa powder for a rich mocha flavor. {True}''';

class QuizzService {
  QuizQuestion _parseQuizQuestion(String input) {
    final String questionText = input.substring(15, input.indexOf('{')).trim();
    final bool correct = input.endsWith('{True}');

    return QuizQuestion(
      question: questionText,
      correct: correct,
    );
  }

  Future<List<QuizQuestion>> generateRandomQuizQuestions() async {
    final List<String> randomCoffeeTypes = List.generate(
      3,
      (_) => shared.getRandomCoffeeType(),
    );

    final List<QuizQuestion> quizQuestions = [];

    for (final coffeeType in randomCoffeeTypes) {
      final String output = await _generativeAIQuizzCoffeJourney(coffeeType);
      final QuizQuestion question = _parseQuizQuestion(output);
      quizQuestions.add(question);
    }

    return quizQuestions;
  }

  Future<String> _generativeAIQuizzCoffeJourney(String coffee) async =>
      PaLMUtil.generateTextFormPaLM(
        exampleInput1: exampleInput1,
        exampleOutput1: exampleOutput1,
        exampleInput2: exampleInput2,
        exampleOutput2: exampleOutput2,
        exampleInput3: exampleInput3,
        exampleOutput3: exampleOutput3,
        input:
            "Could you generate a true or false question about $coffee for me? Please include the answer at the end within curly braces {}.",
      );
}
 ```

 ## shared
 ### loading_indicator.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class LoadinIndicator extends StatelessWidget {
  const LoadinIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
              'Loading from PaLM API ...'), // Text widget for your loading text
          const SizedBox(height: 16),
          SizedBox(
            width: 200.0,
            height: 5.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
 ```

 ### navbar_page.dart
 ```dart
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/modules/home/pages/home_page.dart';
import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:flutter/material.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = HomePage.routeKey;
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      HomePage.routeKey: const HomePage(),
      QuizzPage.routeKey: const QuizzPage(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: const Color(0x8A000000),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 24.0,
            ),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.quiz_outlined,
              size: 24.0,
            ),
            label: 'Quizz',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
 ```

 ### shared.dart
 ```dart
import 'dart:math';

import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final animationsMap = {
  'textOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1190.ms,
        begin: const Offset(0, -34),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'columnOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1190.ms,
        begin: const Offset(0, 51),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'rowOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1120.ms,
        begin: const Offset(-46.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'textOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1120.ms,
        begin: const Offset(-46.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'rowOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 720.ms,
        begin: const Offset(0.0, -27.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'choiceChipsOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeIn,
        delay: 0.ms,
        duration: 1040.ms,
        begin: 0.0,
        end: 1.0,
      ),
    ],
  ),
  'rowOnPageLoadAnimation3': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1080.ms,
        begin: const Offset(41.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'textOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.elasticOut,
        delay: 0.ms,
        duration: 1230.ms,
        begin: const Offset(-44.99999999999999, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  ),
  'blurOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      ShakeEffect(
        curve: Curves.easeInOut,
        delay: 80.ms,
        duration: 1000.ms,
        hz: 5,
        offset: const Offset(0, 0),
        rotation: 0.105,
      ),
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 80.ms,
        duration: 1000.ms,
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
      ),
    ],
  ),
  'containerOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 300.ms,
        begin: const Offset(0, 100),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'containerOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: const Offset(0.6, 0.6),
        end: const Offset(1, 1),
      ),
    ],
  ),
};

String getRandomCoffeeType() {
  final List<String> coffeeTypes = [
    'Caramel Capuccino',
    'Vanilla Capuccino',
    'Classic Capuccino',
    'Mocha Cold Brew',
    'Vanilla Cold Brew',
    'Classic Cold Brew',
    'Double Shot Expresso',
    'Expresso Macchiato',
    'Classic Expresso',
  ];
  final random = Random();
  final randomIndex = random.nextInt(coffeeTypes.length);
  return coffeeTypes[randomIndex];
}

String getRandomCategory() {
  final List<String> coffeeTypes = [
    'Capuccino',
    'Cold Brew',
    'Expresso',
  ];
  final random = Random();
  final randomIndex = random.nextInt(coffeeTypes.length);
  return coffeeTypes[randomIndex];
}
 ```

 ## splash
 ### splash_page.dart
 ```dart
import 'package:aroma_journey/modules/auth/pages/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Modular.to.navigate('/auth/');
      } else {
        Modular.to.navigate('/home/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14181B),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.network(
              OnboardingPageConstants.coverImageUrl,
            ).image,
          ),
        ),
      ),
    );
  }
}
 ```

 ## services
