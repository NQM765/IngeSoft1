extends Area2D

# Referencias a nodos de la escena
@onready var menu: Panel = $CanvasLayer/Panel
@onready var btn_ir_a_tarea: Button = $CanvasLayer2/button_ir_a_tarea
@onready var timer_cambio: Timer = $Timer_cambio
@onready var Tarea3 = $Tarea3  # Nodo que emite la señal "tareacompletada3"

var tarea_completada: bool = false

func _ready() -> void:
	print("Posición inicial del nodo 3:", global_position)
	# Conectar la señal de colisión "body_entered" con un Callable
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Inicializar la UI
	btn_ir_a_tarea.hide()  
	
	if Datos.cofre3_menu_mostrado:
		menu.hide()
		btn_ir_a_tarea.show()
		get_tree().paused = false
	
	# Conectar la señal "tareacompletada3" del nodo TareaLimpiar3
	if Tarea3 and not Tarea3.is_connected("tareacompletada3", Callable(self, "_on_tarea_completada3")):
		Tarea3.connect("tareacompletada3", Callable(self, "_on_tarea_completada3"))
	
	# Conectar la señal "timeout" del timer
	timer_cambio.connect("timeout", Callable(self, "_on_timer_cambio_timeout"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		if not Datos.cofre3_menu_mostrado:
			mostrar_menu()
			Datos.cofre3_menu_mostrado = true

func mostrar_menu() -> void:
	menu.show()
	get_tree().paused = true  # Pausar el juego

func ocultar_menu() -> void:
	menu.hide()
	get_tree().paused = false  # Reanudar el juego

func _on_button_si_pressed() -> void:
	Datos.actualizar_estado_tarea(2, "En proceso")
	get_tree().paused = false
	Datos.cofre3_acepto = true
	print(Datos.cofre3_acepto, "menu 3")
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	
func _on_button_no_pressed() -> void:
	Datos.cofre3_menu_mostrado = false
	get_tree().paused = false
	menu.hide()

# Esta función se ejecuta cuando se emite la señal "tareacompletada3"
func _on_tarea_completada3() -> void:
	print("Tarea completada detectada en el cofre. Ejecutando lógica de finalización en el cofre.")
	# Actualizar estados y detener el timer.
	TimerData3.detener_timer()
	Datos.cofre3_acepto = false
	Datos.tiempo_final_tarea3 = TimerData3.tiempo_restante
	timer_cambio.start()

# Esta función se ejecuta cuando el timer "timer_cambio" emite "timeout"
func _on_timer_cambio_timeout() -> void:
	print("Volviendo a TareaActual desde Tarea 3")
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	timer_cambio.stop()
