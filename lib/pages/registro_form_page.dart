import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class RegistroFormPage extends StatefulWidget {
  const RegistroFormPage({super.key});

  @override
  State<RegistroFormPage> createState() => _RegistroFormPageState();
}

class _RegistroFormPageState extends State<RegistroFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _service = FirestoreService();
  String _tipoEntrega = 'Domicilio';
  bool _guardando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await _service.crearRegistro(
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        tipoEntrega: _tipoEntrega,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar el pedido. Intenta de nuevo.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nuevo pedido')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Registra una entrega',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Los campos con * son obligatorios.'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Titulo del pedido *',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escribe el titulo del pedido.'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descripcionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Descripcion del pedido *',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_outlined),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escribe una descripcion del pedido.'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _tipoEntrega,
            decoration: const InputDecoration(
              labelText: 'Tipo de entrega',
              prefixIcon: Icon(Icons.local_shipping_outlined),
            ),
            items: ['Domicilio', 'Punto de retiro', 'Envio express']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _tipoEntrega = value!),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_guardando ? 'Guardando...' : 'Guardar en Firestore'),
          ),
        ],
      ),
    ),
  );
}
