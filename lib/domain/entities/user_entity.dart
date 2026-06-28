/// Domain entity representing a registered user.
class UserEntity {
  final String id;
  final String nombre;
  final String email;
  final DateTime fechaRegistro;
  final String talla;

  const UserEntity({
    required this.id,
    required this.nombre,
    required this.email,
    required this.fechaRegistro,
    this.talla = '',
  });
}
