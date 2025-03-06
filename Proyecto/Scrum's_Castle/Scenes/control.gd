extends Control

@onready var opciones_personajes = [
	$GridContainer/OptionButton, $GridContainer/OptionButton2, $GridContainer/OptionButton3    # Tarea 1
]

@onready var campos_tiempo = [
	$GridContainer/OptionButton5, $GridContainer/OptionButton6, $GridContainer/OptionButton7        # Tiempo Tarea 1
]

@onready var etiquetas_estado = [
	$GridContainer/Label5, $GridContainer/Label6, $GridContainer/Label7         # Estado Tarea 1
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
	# Validar que todos los campos de personajes estén llenos
	for opcion in opciones_personajes:
		if opcion.text.strip_edges() == "":
			print("Por favor, complete todos los campos de personajes.")
			return  # Detiene la función si hay un campo vacío

	# Validar que todos los campos de tiempo estén llenos
	for tiempo in campos_tiempo:
		if tiempo.text.strip_edges() == "":
			print("Por favor, complete todos los campos de tiempo.")
			return  # Detiene la función si hay un campo vacío

	# Si se han completado todos los campos, continúa con la lógica:
	Datos.personajes_seleccionados.clear()
	Datos.tiempos_seleccionados.clear()
	Datos.estados_tareas.clear()

	for opcion in opciones_personajes:
		Datos.personajes_seleccionados.append(opcion.text)

	for tiempo in campos_tiempo:
		Datos.tiempos_seleccionados.append(int(tiempo.text))
	
	# Actualizar el estado de la tarea al comenzar
	Datos.estados_tareas = ["Sin comenzar", "Sin comenzar", "Sin comenzar"]

	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	PersonajeSeleccionado.personaje = Datos.personajes_seleccionados[0]
