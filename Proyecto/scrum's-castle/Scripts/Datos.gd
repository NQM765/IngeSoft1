# Datos.gd
extends Node

var personajes_seleccionados: Array = []
var tiempos_seleccionados: Array[int] = []

var cofre_menu_mostrado: bool = false

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

signal estado_changed(new_estado)

var _estado_tarea: String = "Sin comenzar"
var estado_tarea: String:
	get:
		return _estado_tarea
	set(value):
		if _estado_tarea != value:
			_estado_tarea = value
			emit_signal("estado_changed", _estado_tarea)
