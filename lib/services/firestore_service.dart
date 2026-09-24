import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/registro_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const collectionName = 'pedidos';

  Stream<List<Registro>> streamRegistros() => _firestore
      .collection(collectionName)
      .orderBy('fechaCreacion', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Registro.fromDocument).toList());

  Future<void> crearRegistro({
    required String titulo,
    required String descripcion,
    required String tipoEntrega,
  }) => _firestore.collection(collectionName).add({
    'titulo': titulo.trim(),
    'descripcion': descripcion.trim(),
    'estado': 'Recibido',
    'fechaCreacion': FieldValue.serverTimestamp(),
    'autor': '2026',
    'tipoEntrega': tipoEntrega,
  });

  Future<void> actualizarEstado(String id, String estado) =>
      _firestore.collection(collectionName).doc(id).update({'estado': estado});

  Future<void> eliminarRegistro(String id) =>
      _firestore.collection(collectionName).doc(id).delete();
}
