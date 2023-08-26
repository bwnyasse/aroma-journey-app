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
