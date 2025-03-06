# Datos.gd
extends Node

signal tarea_completada2_global

var tarea1_eliminada = false
var tarea2_eliminada = false

var tarea_activa: String = ""
var personajes_seleccionados: Array = []
var tiempos_seleccionados: Array[int] = []
var estados_tareas: Array = [] 

var tiempo_final_tarea1 = 0
var tiempo_final_tarea2 = 0
var tiempo_final_tarea3 = 0

var cofre_menu_mostrado = false
var cofre2_menu_mostrado = false
var cofre3_menu_mostrado = false

signal cofre_changed(new_value)

# Variable interna que almacena el valor real
var _cofre_acepto: bool = false

# Propiedad que utiliza getter y setter
var cofre_acepto: bool:
	get:
		return _cofre_acepto
	set(value):
		if _cofre_acepto != value:
			_cofre_acepto = value
			emit_signal("cofre_changed", _cofre_acepto)

# Variable interna para el cofre2
var _cofre2_acepto: bool = false

# Propiedad para cofre2_acepto, con getter y setter
var cofre2_acepto: bool:
	get:
		return _cofre2_acepto
	set(value):
		if _cofre2_acepto != value:
			_cofre2_acepto = value
			emit_signal("cofre2_changed", _cofre2_acepto)


var _cofre3_acepto: bool = false

# Propiedad para cofre2_acepto, con getter y setter
var cofre3_acepto: bool:
	get:
		return _cofre3_acepto
	set(value):
		if _cofre3_acepto != value:
			_cofre3_acepto = value
			emit_signal("cofre3_changed", _cofre3_acepto)
# Señal para notificar cambios en cofre2_acepto
signal cofre3_changed(new_value)
signal cofre2_changed(new_value)
signal estado_changed(new_estado)

var _estado_tarea: String = "Sin comenzar"
var estado_tarea: String:
	get:
		return _estado_tarea
	set(value):
		if _estado_tarea != value:
			_estado_tarea = value
			emit_signal("estado_changed", _estado_tarea)

# Datos.gd
func actualizar_estado_tarea(index: int, nuevo_estado: String) -> void:
	print("Actualizando índice ", index, " a ", nuevo_estado)
	# Asegurarse de que el índice exista en el arreglo
	if index < estados_tareas.size():
		estados_tareas[index] = nuevo_estado
		emit_signal("estado_changed", nuevo_estado) # Si deseas que las escenas se enteren del cambio
