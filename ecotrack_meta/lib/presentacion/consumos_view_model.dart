// Etapa 3 — ViewModel: único dueño del estado compartido.
// Importa foundation.dart (no material.dart): el ViewModel no dibuja.

import 'package:ecotrack_meta/datos/consumo_repository.dart';
import 'package:ecotrack_meta/dominio/consumo.dart';
import 'package:ecotrack_meta/dominio/meta.dart';
import 'package:flutter/foundation.dart';

class ConsumosViewModel extends ChangeNotifier {
  // Recibe el contrato; nunca sabe si es memoria, disco o nube.
  ConsumosViewModel(this._repositorio);

  final ConsumoRepository _repositorio;

  // Estado compartido.
  List<Consumo> consumos = const [];
  String? error;
  bool guardando = false;
  double meta = metaInicial;

  // Estado derivado: se calcula, no se guarda.
  double get total => consumos.fold(0.0, (suma, c) => suma + c.litros);
  double get avance => avanceDeMeta(total: total, meta: meta);
  bool get metaSuperada => total > meta;

  Future<void> cargar() async {
    consumos = await _repositorio.todos();
    notifyListeners();
  }

  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    // Acepta coma decimal y espacios.
    final limpio = litrosTexto.replaceAll(' ', '').replaceAll(',', '.');
    final litros = double.tryParse(limpio);

    // La regla vive en el dominio.
    final mensaje = validarLitros(litros);
    if (mensaje != null) {
      error = mensaje;
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(
      Consumo(laboratorio: laboratorio, litros: litros!),
    );
    // Se reasigna con lo que dice la fuente de verdad.
    consumos = await _repositorio.todos();

    guardando = false;
    notifyListeners();
    return true;
  }

  void subirMeta() {
    meta = ajustarMeta(meta, pasoMeta);
    notifyListeners();
  }

  void bajarMeta() {
    meta = ajustarMeta(meta, -pasoMeta);
    notifyListeners();
  }
}
