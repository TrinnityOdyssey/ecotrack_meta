// Etapa 1 — Reglas de la meta semanal (Dart puro).

const metaInicial = 100.0;
const pasoMeta = 10.0;
const metaMinima = 10.0;

// Suma el cambio a la meta actual, pero nunca baja de metaMinima.
double ajustarMeta(double actual, double cambio) {
  final nueva = actual + cambio;
  return nueva < metaMinima ? metaMinima : nueva;
}

// Fracción de la meta ya usada, entre 0 y 1. Cuida la división entre cero.
double avanceDeMeta({required double total, required double meta}) {
  if (meta <= 0) return 0;
  return (total / meta).clamp(0.0, 1.0).toDouble();
}
