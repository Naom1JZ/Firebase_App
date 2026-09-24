import 'package:flutter/material.dart';

import '../models/registro_model.dart';

class RegistroCard extends StatelessWidget {
  const RegistroCard({
    super.key,
    required this.registro,
    required this.onEstadoChanged,
    required this.onDelete,
  });

  final Registro registro;
  final ValueChanged<String> onEstadoChanged;
  final VoidCallback onDelete;

  Color _colorEstado(BuildContext context) {
    switch (registro.estado) {
      case 'Entregado':
        return Colors.green.shade700;
      case 'En camino':
        return Colors.orange.shade800;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorEstado(context);
    final fecha = registro.fechaCreacion == null
        ? 'Fecha pendiente'
        : '${registro.fechaCreacion!.day.toString().padLeft(2, '0')}/${registro.fechaCreacion!.month.toString().padLeft(2, '0')}/${registro.fechaCreacion!.year}';
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(30),
                  foregroundColor: color,
                  child: const Icon(Icons.local_shipping_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    registro.titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(registro.descripcion),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(registro.tipoEntrega),
                  avatar: const Icon(Icons.local_shipping_outlined, size: 16),
                ),
                Chip(
                  label: Text(registro.estado),
                  avatar: Icon(Icons.circle, size: 12, color: color),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Creado: $fecha · Autor: ${registro.autor}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Cambiar estado',
                  onSelected: onEstadoChanged,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Recibido', child: Text('Recibido')),
                    PopupMenuItem(value: 'En camino', child: Text('En camino')),
                    PopupMenuItem(value: 'Entregado', child: Text('Entregado')),
                  ],
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
