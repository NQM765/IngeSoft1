extends Control

@onready var label_character: Label = $GridContainer/Label_personaje
@onready var label_time: Label = $GridContainer/Label_tiempo
@onready var etiquetas_estado = $GridContainer/Label5

func _ready():
	# Mostrar el personaje seleccionado
	if Datos.personajes_seleccionados.size() > 0:
		label_character.text = Datos.personajes_seleccionados[0]
	else:
		label_character.text = "Sin personaje"

	# Iniciar el timer global solo si la tarea aún no se completó
	if Datos.tiempos_seleccionados.size() > 0 and Datos.estado_tarea != "Completado" and Datos.estado_tarea != "Fallido" and not TimerData.timer_iniciado:
		var minutos = int(Datos.tiempos_seleccionados[0])
		TimerData.iniciar_timer(minutos)
	
	actualizar_etiqueta()
	
	# Si la tarea ya está en proceso o completada, actualizamos el label de estado
	etiquetas_estado.text = Datos.estado_tarea
	if Datos.estado_tarea == "En proceso":
		etiquetas_estado.add_theme_color_override("font_color", Color.GRAY)
	elif Datos.estado_tarea == "Completado":
		etiquetas_estado.add_theme_color_override("font_color", Color.GREEN)
	elif Datos.estado_tarea == "Fallido":
		etiquetas_estado.add_theme_color_override("font_color", Color.RED)


func _process(delta):
	actualizar_etiqueta()

func actualizar_etiqueta():
	var min = TimerData.tiempo_restante / 60
	var sec = TimerData.tiempo_restante % 60
	label_time.text = "%02d:%02d" % [min, sec]

func _on_button_volver_pressed():
	Datos.cofre_acepto = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
