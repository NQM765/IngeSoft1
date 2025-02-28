extends Control

@onready var opciones_personajes = [
	$GridContainer/OptionButton,        # Tarea 1
]

@onready var campos_tiempo = [
	$GridContainer/OptionButton5,       # Tiempo Tarea 1
]

@onready var etiquetas_estado = [
	$GridContainer/Label5,              # Estado Tarea 1
]

func _ready():
	# Configurar estado inicial de cada tarea usando la variable de Datos
	for etiqueta in etiquetas_estado:
		etiqueta.text = Datos.estado_tarea
		etiqueta.add_theme_color_override("font_color", Color.GRAY)
	
	# Conectar la señal para actualizar el estado cuando cambie
	Datos.estado_changed.connect(_on_estado_changed)



func _on_estado_changed(new_estado: String) -> void:
	for etiqueta in etiquetas_estado:
		etiqueta.text = new_estado
		match new_estado:
			"Sin comenzar":
				etiqueta.add_theme_color_override("font_color", Color.GRAY)
			"En proceso":
				etiqueta.add_theme_color_override("font_color", Color.YELLOW)
			"Completado":
				etiqueta.add_theme_color_override("font_color", Color.GREEN)
			_:
				etiqueta.add_theme_color_override("font_color", Color.WHITE)

func _on_button_comenzar_pressed():
	Datos.personajes_seleccionados.clear()
	Datos.tiempos_seleccionados.clear()

	for opcion in opciones_personajes:
		Datos.personajes_seleccionados.append(opcion.text)

	for tiempo in campos_tiempo:
		Datos.tiempos_seleccionados.append(int(tiempo.text))
	
	# Actualizar el estado de la tarea al comenzar
	Datos.estado_tarea = "En proceso"
	
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
