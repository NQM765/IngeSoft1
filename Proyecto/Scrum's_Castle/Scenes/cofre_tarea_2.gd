extends Area2D

@onready var menu: Panel = $Menu_cofre/Panel         # Menú original
@onready var btn_ir_a_tarea: Button = $Volver_a_Tarea/button_ir_a_tarea
@onready var panel_felicidad: Panel = $Mensaje_final/Panel_felicidades
@onready var panel_consejo: Panel = $CanvasLayer4/Panel_consejo
@onready var timer_cambio: Timer = $Timer_cambio

func _ready() -> void:
	print("[DEBUG] TareaLimpiar2:", TareaLimpiar2)
	print("Posición inicial del nodo2:", global_position)
	# Conectar la señal de colisión.
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	panel_felicidad.hide()
	panel_consejo.hide()
	btn_ir_a_tarea.hide()  
	if Datos.cofre2_menu_mostrado:
		# Si ya se mostró el menú en interacciones previas:
		menu.hide()
		btn_ir_a_tarea.show()
		get_tree().paused = false
	
	# Conectar la señal "tarea_completada" emitida por Tarea2.
	if TareaLimpiar2 and not TareaLimpiar2.is_connected("tarea_completada2", Callable(self, "_on_tarea_completada2")):
		TareaLimpiar2.connect("tarea_completada2", Callable(self, "_on_tarea_completada2"))
		print("[DEBUG] Señal tarea_completada2 conectada correctamente")
	
	Datos.connect("tarea_completada2_global", Callable(self, "_on_tarea_completada2"))
	# Conectar la señal "timeout" del timer
	timer_cambio.connect("timeout", Callable(self, "_on_TimerCambio_timeout"))
	
func _on_tarea_completada2() -> void:
	print("Tarea completada detectada en el cofre.")
	TimerData2.detener_timer()
	Datos.cofre2_acepto = false
	Datos.tiempo_final_tarea2 = TimerData2.tiempo_restante
	
	# Condición para mostrar panel diferente según personaje
	if Datos.personajes_seleccionados[1] != "Granjero":  # Ajusta el valor según tu sistema
		panel_consejo.show()
		panel_felicidad.show()
	else:
		panel_felicidad.show()
	
	timer_cambio.start()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		if not Datos.cofre2_menu_mostrado:
			mostrar_menu()
			Datos.cofre2_menu_mostrado = true

func mostrar_menu() -> void:
	menu.show()
	get_tree().paused = false  # Pausar el juego

func ocultar_menu() -> void:
	menu.hide()
	get_tree().paused = false  # Reanudar el juego

func _on_button_si_pressed() -> void:
	print("Botón Sí presionado, cambiando a Tarea_limpiar_2.tscn")
	Datos.actualizar_estado_tarea(1, "En proceso")
	get_tree().paused = false
	Datos.cofre2_acepto = true
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	
func _on_button_no_pressed() -> void:
	# Acción del botón "No": reanudar y ocultar el menú.
	Datos.cofre_menu_mostrado = false
	get_tree().paused = false
	menu.hide()

func _on_button_ir_a_tarea_pressed() -> void:
	get_tree().paused = false
	TareaLimpiar2.hide() 
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")

# Esta función se ejecuta cuando Tarea2 emite la señal "tarea_completada".


	# Aquí podrías mostrar un panel de felicitaciones si lo deseas.
	
func _on_TimerCambio_timeout() -> void:
	print("Volviendo a TareaActual desde Tarea 2")
	panel_felicidad.hide()
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	timer_cambio.stop()
