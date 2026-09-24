import 'package:cloud_firestore/cloud_firestore.dart';

class Registro {
  const Registro({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fechaCreacion,
    required this.autor,
    required this.tipoEntrega,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String estado;
  final DateTime? fechaCreacion;
  final String autor;
  final String tipoEntrega;

  factory Registro.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final timestamp = data['fechaCreacion'];
    return Registro(
      id: doc.id,
      titulo: data['titulo'] as String? ?? 'Sin titulo',
      descripcion: data['descripcion'] as String? ?? '',
      estado: data['estado'] as String? ?? 'Recibido',
      fechaCreacion: timestamp is Timestamp ? timestamp.toDate() : null,
      autor: data['autor'] as String? ?? '0000',
      tipoEntrega: data['tipoEntrega'] as String? ?? 'Domicilio',
    );
  }

  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'descripcion': descripcion,
    'estado': estado,
    'fechaCreacion': fechaCreacion == null
        ? FieldValue.serverTimestamp()
        : Timestamp.fromDate(fechaCreacion!),
    'autor': autor,
    'tipoEntrega': tipoEntrega,
  };
}
