import 'package:flutter/material.dart';

import '../models/registro_model.dart';
import '../services/firestore_service.dart';
import '../widgets/registro_card.dart';
import 'registro_form_page.dart';

class FirestoreHomePage extends StatelessWidget {
  const FirestoreHomePage({super.key});

  static final _service = FirestoreService();

  Future<void> _eliminar(BuildContext context, Registro registro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar pedido'),
        content: Text(
          'Se eliminara "${registro.titulo}". Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    try {
      await _service.eliminarRegistro(registro.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo eliminar el pedido.')),
        );
      }
    }
  }

  Future<void> _actualizarEstado(
    BuildContext context,
    Registro registro,
    String estado,
  ) async {
    try {
      await _service.actualizarEstado(registro.id, estado);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar la entrega.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Seguimiento de entregas'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cloud_done_outlined),
          tooltip: 'Conectado',
        ),
      ],
    ),
    body: StreamBuilder<List<Registro>>(
      stream: _service.streamRegistros(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _MessageState(
            icon: Icons.cloud_off_outlined,
            title: 'No se pudo cargar',
            detail:
                'Revisa tu configuracion de Firebase y vuelve a intentarlo.',
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final registros = snapshot.data ?? [];
        if (registros.isEmpty) {
          return const _MessageState(
            icon: Icons.inventory_2_outlined,
            title: 'No hay pedidos registrados',
            detail: 'Agrega el primer pedido para comenzar el seguimiento.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 96),
          children: [
            Text(
              'Seguimiento de pedidos',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '${registros.length} ${registros.length == 1 ? 'pedido' : 'pedidos'} sincronizados en tiempo real.',
            ),
            const SizedBox(height: 20),
            ...registros.map(
              (registro) => RegistroCard(
                registro: registro,
                onEstadoChanged: (estado) =>
                    _actualizarEstado(context, registro, estado),
                onDelete: () => _eliminar(context, registro),
              ),
            ),
          ],
        );
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistroFormPage()),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo pedido'),
    ),
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.detail,
  });
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 58, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(detail, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
