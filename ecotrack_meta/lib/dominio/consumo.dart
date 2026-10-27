// Etapa 1 — Dominio: Dart puro, sin Flutter.

// Laboratorios disponibles. Es una constante de configuración, no estado.
const laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

// Un registro de consumo de agua.
class Consumo {
  const Consumo({required this.laboratorio, required this.litros});

  final String laboratorio;
  final double litros;
}

// Regla de negocio: devuelve el mensaje de error, o null si los litros son válidos.
String? validarLitros(double? litros) {
  if (litros == null) return 'Escribe los litros con número';
  if (litros <= 0) return 'Los litros deben ser mayores que cero';
  if (litros > 10000) return 'Los litros superan el tope de 10000';
  return null;
}
