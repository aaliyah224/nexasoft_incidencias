
class Incidencia {
  String id;
  String titulo;
  String descripcion;
  String cliente;
  String categoria;
  String estado;
  String fecha;

  // FEAT-001: Prioridad de la incidencia.
  String prioridad;

  Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.cliente,
    required this.categoria,
    required this.estado,
    required this.fecha,
    this.prioridad = 'Media',
  });

  factory Incidencia.desdeJson(Map<String, dynamic> m) {
    // Leemos la prioridad guardada.
    String prioridadGuardada = m['prioridad']?.toString() ?? 'Media';

    // Solo aceptamos las tres prioridades permitidas.
    if (!['Baja', 'Media', 'Alta'].contains(prioridadGuardada)) {
      prioridadGuardada = 'Media';
    }

    return Incidencia(
      id: m['id']?.toString() ?? '',
      titulo: m['titulo']?.toString() ?? '',
      descripcion: m['descripcion']?.toString() ?? '',
      cliente: m['cliente']?.toString() ?? '',
      categoria: m['categoria']?.toString() ?? 'Software',
      estado: m['estado']?.toString() ?? 'Pendiente',
      fecha: m['fecha']?.toString() ?? '',
      prioridad: prioridadGuardada,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'cliente': cliente,
      'categoria': categoria,
      'estado': estado,
      'fecha': fecha,
      'prioridad': prioridad,
    };
  }
}
