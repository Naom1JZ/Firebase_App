import 'package:flutter_test/flutter_test.dart';

import 'package:tarea_firestore/models/registro_model.dart';

void main() {
  test('un registro conserva sus datos principales', () {
    const registro = Registro(
      id: 'pedido-1',
      titulo: 'Pedido de utiles',
      descripcion: 'Entrega para el aula',
      estado: 'Recibido',
      fechaCreacion: null,
      autor: '2026',
      tipoEntrega: 'Domicilio',
    );

    expect(registro.toMap()['titulo'], 'Pedido de utiles');
    expect(registro.toMap()['tipoEntrega'], 'Domicilio');
    expect(registro.toMap()['estado'], 'Recibido');
  });
}
