import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

/// Firestore-backed data model for [UserEntity].
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.nombre,
    required super.email,
    required super.fechaRegistro,
    super.talla,
  });

  /// Create from a Firestore document snapshot.
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      fechaRegistro:
          (data['fechaRegistro'] as Timestamp?)?.toDate() ?? DateTime.now(),
      talla: data['talla'] ?? '',
    );
  }

  /// Convert to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'email': email,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
      'talla': talla,
    };
  }
}
