// Etapa 2 — Contrato de datos. Habla el idioma del dominio.

import 'package:ecotrack_meta/dominio/consumo.dart';

abstract class ConsumoRepository {
  Future<void> guardar(Consumo consumo);
  Future<List<Consumo>> todos();
}
