extends Control

@onready var label_character: Label = $GridContainer/Label_personaje
@onready var label_time: Label = $GridContainer/Label_tiempo
@onready var etiquetas_estado = $GridContainer/Label1
@onready var label_character2: Label = $GridContainer/Label_personaje2
@onready var label_time2: Label = $GridContainer/Label_tiempo2
@onready var etiquetas_estado2 = $GridContainer/Label2
@onready var label_character3: Label = $GridContainer/Label_personaje3
@onready var label_time3: Label = $GridContainer/Label_tiempo3
@onready var etiquetas_estado3 = $GridContainer/Label3

func _ready():
	# Mostrar el personaje seleccionado
	TareaLimpiar.hide() 
	TareaLimpiar2.hide() 
	
	if Datos.personajes_seleccionados.size() > 0:
		label_character.text = Datos.personajes_seleccionados[0] 
		label_character2.text = Datos.personajes_seleccionados[1]
		label_character3.text = Datos.personajes_seleccionados[2]
	else:
		label_character.text = "Sin personaje"

	# Iniciar el timer global solo si la tarea aún no se completó
	if Datos.tiempos_seleccionados.size() > 1 and Datos.estados_tareas[1] == "En proceso" and not TimerData2.timer_iniciado:
		var minutos2 = int(Datos.tiempos_seleccionados[1])
		TimerData2.iniciar_timer(minutos2)
	
	if Datos.tiempos_seleccionados.size() > 0 and Datos.estados_tareas[0] == "En proceso" and not TimerData.timer_iniciado:
		var minutos = int(Datos.tiempos_seleccionados[0])
		TimerData.iniciar_timer(minutos)
		
	if Datos.tiempos_seleccionados.size() > 2 and Datos.estados_tareas[2] == "En proceso" and not TimerData3.timer_iniciado:
		var minutos3 = int(Datos.tiempos_seleccionados[2])
		TimerData3.iniciar_timer(minutos3)
	
	
	
	actualizar_etiqueta()
	
	# Actualizar el estado de cada tarea individualmente
	if Datos.estados_tareas.size() > 1:
		etiquetas_estado2.text = Datos.estados_tareas[1]
		match Datos.estados_tareas[1]:
			"Sin comenzar":
				etiquetas_estado2.add_theme_color_override("font_color", Color.GRAY)
			"En proceso":
				etiquetas_estado2.add_theme_color_override("font_color", Color.YELLOW)
			"Completado":
				etiquetas_estado2.add_theme_color_override("font_color", Color.GREEN)
			"Fallido":
				etiquetas_estado2.add_theme_color_override("font_color", Color.RED)
			_:
				etiquetas_estado2.add_theme_color_override("font_color", Color.WHITE)
	else:
		etiquetas_estado2.text = "Sin estado"
		
	if Datos.estados_tareas.size() > 0:
		etiquetas_estado.text = Datos.estados_tareas[0]
		match Datos.estados_tareas[0]:
			"Sin comenzar":
				etiquetas_estado.add_theme_color_override("font_color", Color.GRAY)
			"En proceso":
				etiquetas_estado.add_theme_color_override("font_color", Color.YELLOW)
			"Completado":
				etiquetas_estado.add_theme_color_override("font_color", Color.GREEN)
			"Fallido":
				etiquetas_estado.add_theme_color_override("font_color", Color.RED)
			_:
				etiquetas_estado.add_theme_color_override("font_color", Color.WHITE)
	else:
		etiquetas_estado.text = "Sin estado"

	if Datos.estados_tareas.size() > 2:
		etiquetas_estado3.text = Datos.estados_tareas[2]
		match Datos.estados_tareas[2]:
			"Sin comenzar":
				etiquetas_estado3.add_theme_color_override("font_color", Color.GRAY)
			"En proceso":
				etiquetas_estado3.add_theme_color_override("font_color", Color.YELLOW)
			"Completado":
				etiquetas_estado3.add_theme_color_override("font_color", Color.GREEN)
			"Fallido":
				etiquetas_estado3.add_theme_color_override("font_color", Color.RED)
			_:
				etiquetas_estado3.add_theme_color_override("font_color", Color.WHITE)
	else:
		etiquetas_estado3.text = "Sin estado"


func _process(delta):
	actualizar_etiqueta()

func actualizar_etiqueta():
	# Para la tarea 1 (índice 0)
	if Datos.estados_tareas[0] == "Completado":
		var min = Datos.tiempo_final_tarea1 / 60
		var sec = Datos.tiempo_final_tarea1 % 60
		label_time.text = "%02d:%02d" % [min, sec]
	elif not TimerData.timer_iniciado and Datos.tiempos_seleccionados.size() > 0:
		label_time.text = "%02d:00" % [int(Datos.tiempos_seleccionados[0])]
	else:
		var min = TimerData.tiempo_restante / 60
		var sec = TimerData.tiempo_restante % 60
		label_time.text = "%02d:%02d" % [min, sec]
	
	# Para la tarea 2 (índice 1)
	if Datos.estados_tareas[1] == "Completado":
		var min2 = Datos.tiempo_final_tarea2 / 60
		var sec2 = Datos.tiempo_final_tarea2 % 60
		label_time2.text = "%02d:%02d" % [min2, sec2]
	elif not TimerData2.timer_iniciado and Datos.tiempos_seleccionados.size() > 1:
		label_time2.text = "%02d:00" % [int(Datos.tiempos_seleccionados[1])]
	else:
		var min2 = TimerData2.tiempo_restante / 60
		var sec2 = TimerData2.tiempo_restante % 60
		label_time2.text = "%02d:%02d" % [min2, sec2]
	
		# Para la tarea 3 (índice 2)
	if Datos.estados_tareas[2] == "Completado":
		var min3 = Datos.tiempo_final_tarea3 / 60
		var sec3 = Datos.tiempo_final_tarea3 % 60
		label_time3.text = "%02d:%02d" % [min3, sec3]
	elif not TimerData3.timer_iniciado and Datos.tiempos_seleccionados.size() > 2:
		label_time3.text = "%02d:00" % [int(Datos.tiempos_seleccionados[2])]
	else:
		var min3 = TimerData3.tiempo_restante / 60
		var sec3 = TimerData3.tiempo_restante % 60
		label_time3.text = "%02d:%02d" % [min3, sec3]



func _on_button_volver_pressed():
	get_tree().paused = false
	if Datos.cofre3_acepto and Datos.estados_tareas[2] == "En proceso":
		get_tree().change_scene_to_file("res://Scenes/Tarea_3.tscn")
		print(Datos.cofre_acepto,"volver2")
	elif Datos.cofre_acepto and Datos.estados_tareas[0] == "En proceso":
		TareaLimpiar.show()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
		print(Datos.cofre2_acepto,"volver2")
	elif Datos.cofre2_acepto and Datos.estados_tareas[1] == "En proceso":
		TareaLimpiar2.show()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	#cambio- tarea 3}
	else:
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
