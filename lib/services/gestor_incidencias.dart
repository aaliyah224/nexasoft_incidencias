import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];
  
Future<void> iniciar() async {
  // Cargamos las incidencias que están guardadas.
  incidencias = await datos.leer();
}
 
  // FEAT-002: Buscar incidencias combinando texto, estado y prioridad.
  List<Incidencia> buscar(
    String texto, {
    String estado = 'Todos',
    String prioridad = 'Todas',
  }) {
    // BUG-002: La búsqueda no distingue mayúsculas y minúsculas.
    String busqueda = texto.trim().toLowerCase();

    return incidencias.where((x) {

      // Comprobamos si el título contiene el texto buscado.
      bool coincideTexto =
          x.titulo.toLowerCase().contains(busqueda);

      // Si seleccionamos "Todos", aceptamos cualquier estado.
      bool coincideEstado =
          estado == 'Todos' || x.estado == estado;

      // Si seleccionamos "Todas", aceptamos cualquier prioridad.
      bool coincidePrioridad =
          prioridad == 'Todas' || x.prioridad == prioridad;

      // La incidencia debe cumplir las tres condiciones.
      return coincideTexto && coincideEstado && coincidePrioridad;

    }).toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }
  // BUG-003: Contar las incidencias según su estado actual.
  int contar(String estado) {
    // Contamos las incidencias que tienen el estado solicitado.
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;

        // Guardamos los cambios.
        await datos.guardar(incidencias);

        break;
      }
    }
  }

  
  // FEAT-001: Cambiar y guardar la prioridad.
  Future<void> cambiarPrioridad(String id, String prioridad) async {

    // Solo permitimos las tres prioridades aprobadas.
    if (!['Baja', 'Media', 'Alta'].contains(prioridad)) {
      return;
    }

    // Buscamos la incidencia por su identificador.
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {

        // Actualizamos su prioridad.
        incidencias[i].prioridad = prioridad;

        // Guardamos el cambio para conservarlo al reiniciar.
        await datos.guardar(incidencias);

        break;
      }
    }
  }


 
  // FEAT-001: Crear una incidencia con su prioridad.
  Future<void> crear(
    String titulo,
    String descripcion,
    String cliente,
    String categoria,
    String prioridad,
  ) async {

    // Creamos la nueva incidencia con los datos del formulario.
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,

      // Guardamos únicamente una prioridad permitida.
      prioridad: ['Baja', 'Media', 'Alta'].contains(prioridad)
          ? prioridad
          : 'Media',
    );

    // Agregamos la incidencia al principio de la lista.
    incidencias.insert(0, nuevo);

    // Guardamos las incidencias en el almacenamiento local.
    await datos.guardar(incidencias);
  }


  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
