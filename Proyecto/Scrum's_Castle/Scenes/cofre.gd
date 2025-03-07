extends Area2D

@onready var menu: Panel = $CanvasLayer/Panel         # Menú original
@onready var btn_ir_a_tarea: Button = $CanvasLayer2/button_ir_a_tarea
@onready var panel_felicidad: Panel = $CanvasLayer3/Panel_felicidades
@onready var panel_consejo: Panel = $CanvasLayer4/Panel_consejo
@onready var timer_cambio: Timer = $Timer_cambio

func _ready() -> void:
	print("Posición inicial del nodo2:", global_position)
	# Conectar la señal de colisión.
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	panel_felicidad.hide()
	panel_consejo.hide()
	btn_ir_a_tarea.hide()  
	if Datos.cofre_menu_mostrado:
		# Si ya se mostró el menú en interacciones previas:
		menu.hide()
		btn_ir_a_tarea.show()
		get_tree().paused = false
	
	# Conectar la señal "tarea_completada" emitida por Tarea2.
	if TareaLimpiar and not TareaLimpiar.is_connected("tarea_completada", Callable(self, "_on_tarea_completada")):
		TareaLimpiar.connect("tarea_completada", Callable(self, "_on_tarea_completada"))
	
	# Conectar la señal "timeout" del timer
	timer_cambio.connect("timeout", Callable(self, "_on_TimerCambio_timeout"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		if not Datos.cofre_menu_mostrado:
			mostrar_menu()
			Datos.cofre_menu_mostrado = true

func mostrar_menu() -> void:
	menu.show()
	get_tree().paused = true  # Pausar el juego

func ocultar_menu() -> void:
	menu.hide()
	get_tree().paused = false  # Reanudar el juego

func _on_button_si_pressed() -> void:
	print("Botón Sí presionado, cambiando a Tarea_limpiar_2.tscn")
	Datos.actualizar_estado_tarea(0, "En proceso")
	get_tree().paused = false
	Datos.cofre_acepto = true
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	
func _on_button_no_pressed() -> void:
	# Acción del botón "No": reanudar y ocultar el menú.
	Datos.cofre_menu_mostrado = false
	get_tree().paused = false
	menu.hide()

func _on_button_ir_a_tarea_pressed() -> void:
	get_tree().paused = false
	TareaLimpiar.hide() 
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")

# Esta función se ejecuta cuando Tarea2 emite la señal "tarea_completada".
func _on_tarea_completada() -> void:
	print("Tarea completada detectada en el cofre.")
	TimerData.detener_timer()
	Datos.cofre_acepto = false
	Datos.tiempo_final_tarea1 = TimerData.tiempo_restante
	
	# Condición para mostrar panel diferente según personaje
	if Datos.personajes_seleccionados[0] != "Mago":  # Ajusta el valor según tu sistema
		panel_consejo.show()
		panel_felicidad.show()
	else:
		panel_felicidad.show()
	
	timer_cambio.start()
	
func _on_TimerCambio_timeout() -> void:
	print("Volviendo a TareaActual desde Tarea1")
	panel_felicidad.hide()
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	timer_cambio.stop()
