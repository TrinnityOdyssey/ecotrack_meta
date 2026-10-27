// Etapa 4a — Vistas tontas: reciben datos y callbacks, no saben qué gestor hay arriba.

import 'package:ecotrack_meta/dominio/consumo.dart';
import 'package:flutter/material.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({
    super.key,
    required this.alGuardar,
    required this.error,
    required this.guardando,
  });

  final Future<bool> Function(String laboratorio, String litros) alGuardar;
  final String? error;
  final bool guardando;

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  // Estado efímero: solo le importa a este formulario.
  final TextEditingController _litros = TextEditingController();
  String _laboratorio = laboratoriosUtez.first;

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final seGuardo = await widget.alGuardar(_laboratorio, _litros.text);
    // Después de un await, se revisa mounted antes de usar el context.
    if (!mounted) return;
    if (seGuardo) {
      _litros.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consumo guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _laboratorio,
            decoration: const InputDecoration(labelText: 'Laboratorio'),
            items: [
              for (final lab in laboratoriosUtez)
                DropdownMenuItem(value: lab, child: Text(lab)),
            ],
            onChanged: (valor) {
              if (valor != null) setState(() => _laboratorio = valor);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('litros'),
            controller: _litros,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: widget.error,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: widget.guardando ? null : _guardar,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class ListaHistorial extends StatelessWidget {
  const ListaHistorial({
    super.key,
    required this.consumos,
    required this.total,
  });

  final List<Consumo> consumos;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }
    return ListView(
      children: [
        ListTile(
          title: Text(
            'Total: ${total.toStringAsFixed(1)} L',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        for (final c in consumos)
          ListTile(
            title: Text(c.laboratorio),
            trailing: Text('${c.litros.toStringAsFixed(1)} L'),
          ),
      ],
    );
  }
}

class PanelMeta extends StatelessWidget {
  const PanelMeta({
    super.key,
    required this.usado,
    required this.meta,
    required this.avance,
    required this.superada,
    required this.alSubir,
    required this.alBajar,
  });

  final double usado;
  final double meta;
  final double avance;
  final bool superada;
  final VoidCallback alSubir;
  final VoidCallback alBajar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usado: ${usado.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: avance),
          const SizedBox(height: 12),
          Text(superada ? 'Te pasaste de la meta' : 'Dentro de la meta'),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                key: const Key('bajarMeta'),
                onPressed: alBajar,
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                key: const Key('subirMeta'),
                onPressed: alSubir,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PantallasEcoTrack extends StatefulWidget {
  const PantallasEcoTrack({
    super.key,
    required this.titulo,
    required this.registro,
    required this.historial,
    required this.meta,
  });

  final String titulo;
  final Widget registro;
  final Widget historial;
  final Widget meta;

  @override
  State<PantallasEcoTrack> createState() => _PantallasEcoTrackState();
}

class _PantallasEcoTrackState extends State<PantallasEcoTrack> {
  // Estado efímero: la pestaña activa.
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      // IndexedStack mantiene montadas las tres pestañas y solo enseña una.
      body: IndexedStack(
        index: _indice,
        children: [widget.registro, widget.historial, widget.meta],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit), label: 'Registro'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Meta'),
        ],
      ),
    );
  }
}
