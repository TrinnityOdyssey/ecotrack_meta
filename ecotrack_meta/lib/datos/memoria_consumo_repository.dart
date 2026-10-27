// Etapa 2 — Implementación en memoria del contrato.

import 'package:ecotrack_meta/datos/consumo_repository.dart';
import 'package:ecotrack_meta/dominio/consumo.dart';

class MemoriaConsumoRepository implements ConsumoRepository {
  // Fuente de verdad. Es privada: nadie de fuera la toca.
  final List<Consumo> _consumos = [];

  @override
  Future<void> guardar(Consumo consumo) async {
    _consumos.add(consumo);
  }

  @override
  Future<List<Consumo>> todos() async {
    // Copia no modificable: modificarla lanza UnsupportedError.
    return List.unmodifiable(_consumos);
  }
}
